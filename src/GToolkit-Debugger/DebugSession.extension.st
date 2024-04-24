Extension { #name : #DebugSession }

{ #category : #'*GToolkit-Debugger' }
DebugSession >> allDebuggerProviders [
	^ ((self allStandaloneDebuggerProviders
		, self allMoldableExceptionDebuggersProviders)
			reject: [ :aDebuggerProvider |
				aDebuggerProvider isNil ])
			sorted: [ :aDebuggerProvider |
				aDebuggerProvider priority ] ascending
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> allMoldableExceptionDebuggersProviders [
	| pragmas |
	self exception ifNil: [ ^ #() ].
	
	pragmas := Pragma
		allNamed: #gtDebuggerConfiguration
		from: self exception class
		to: Exception.

	^ pragmas collect: [ :aPragma | 
		GtMoldableExceptionDebuggerProvider forConfiguration:  (self exception 
			perform: aPragma methodSelector) ].
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> allStandaloneDebuggerProviders [
	^ Smalltalk tools registeredDebuggersWithRanks 
		collect: [ :assoc |
			assoc key debuggerProvider
				ifNil: [ nil ]
				ifNotNil: [ :aProvider |
					aProvider
						priority: assoc value;
						yourself ] ]
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> applicableDebuggerProviders [
	^ ((self applicableStandaloneDebuggerProviders
		, self applicableMoldableExceptionDebuggersProviders)
			reject: [ :aDebuggerProvider |
				aDebuggerProvider isNil ])
			sorted: [ :aDebuggerProvider |
				aDebuggerProvider priority ] ascending
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> applicableMoldableExceptionDebuggersProviders [
	| possibleProviders |

	possibleProviders := self allMoldableExceptionDebuggersProviders.
			
	^ possibleProviders select: [ :aProvider |
		aProvider handlesDebugSession: self ]
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> applicableStandaloneDebuggerProviders [
	^ self applicableStandaloneDebuggerTypesWithRanks 
		collect: [ :assoc |
			assoc key debuggerProvider
				ifNil: [ nil ]
				ifNotNil: [ :aProvider |
					aProvider
						priority: assoc value;
						yourself ] ]
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> applicableStandaloneDebuggerTypesWithRanks [
	^ Smalltalk tools debuggersWithRankForDebugSession: self
]

{ #category : #'*GToolkit-Debugger' }
DebugSession class >> debuggingActionsForPragma: aSymbol for: aDebugger [
	^ (DebugAction allSubclasses reject: [ :each | each hasAbstractMethods ])
		inject: OrderedCollection new
		into: [ :currentActions :aClass | 
			currentActions
				addAll: (self debuggingActionsFromClass: aClass forPragma: aSymbol forDebugger: aDebugger);
				yourself ]
]

{ #category : #'*GToolkit-Debugger' }
DebugSession class >> debuggingActionsForPragmas: aSymbolsCollection for: aDebugger [
	self flag: 'split me'.
	^ (((aSymbolsCollection 
		inject: OrderedCollection new
		into: [ :currentActions :aSymbol | 
			currentActions 
				addAll: (self debuggingActionsForPragma: aSymbol for: aDebugger);
				yourself ]) 
					select: [ :aDebugAction | 
						aDebugAction appliesToDebugger: aDebugger ]) 
					collect: [ :aDebugAction | 
						aDebugAction
							forDebugger: aDebugger;
							yourself ]) 
					sort: [ :action1 :action2 | 
						action1 order < action2 order ]
]

{ #category : #'*GToolkit-Debugger' }
DebugSession class >> debuggingActionsFromClass: aClass forPragma: aSymbol forDebugger: aDebugger [
	| pragmas actions |
	pragmas := Pragma
		allNamed: aSymbol
		from: aClass class
		to: aClass class.
	actions := OrderedCollection new.
	pragmas
		do: [ :aPragma | 
			actions
				addAll:
					((aPragma methodClass soleInstance
						perform: aPragma methodSelector
						withEnoughArguments: {aDebugger}) asOrderedCollection
						collect: [ :each | each asDebugAction ]) ].
	^ actions
]

{ #category : #'*GToolkit-Debugger' }
DebugSession class >> forExceptionFromExampleFor: anException [
	"Instantiate a debugging session, including a process, for the given exception.
	This should be used from examples, where the exception was captured by on:do:."

	| context process session |

	"Ensure the entire exception stack is frozen"
	anException freezeUpTo: nil.
	
	context := anException signalerContext.
	process := Process
		forContext: context
		priority: Processor userInterruptPriority.
	session := DebugSession
		named: anException description
		on: process
		startedAt: context.
	session exception: anException.
	
	^ session
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> gtViewDebuggerSpecificationsFor: aView [
	<gtView>
	
	^ aView columnedList 
		title: 'Debugger Specifications';
		items: [ 
			(self allDebuggerProviders collect: [ :aDebuggerProvider |	
				aDebuggerProvider -> (aDebuggerProvider 
					handlesDebugSession: self) ]) ];
		column: 'Type' textDo: [ :aColumn |
			aColumn 
				format: [ :assoc | assoc key debuggerClass
					asRopedText foreground: (assoc value 
					ifTrue: [ Color black] 
					ifFalse: [ Color lightGray ] ) ] ];
		column: 'Icon' icon: [ :assoc |
			assoc key icon ];
		column: 'Title' textDo: [ :aColumn |
			aColumn 
				format: [ :assoc | assoc key title
					asRopedText foreground: (assoc value 
					ifTrue: [ Color black] 
					ifFalse: [ Color lightGray ] ) ] ];
		column: 'Priority' textDo: [ :aColumn |
			aColumn 
				width: 80;
				format: [ :assoc | assoc key priority
					asRopedText foreground: (assoc value 
					ifTrue: [ Color black] 
					ifFalse: [ Color lightGray ] ) ] ];
		column: 'Is applicable' textDo: [ :aColumn |
			aColumn 
				width: 80;
				format: [ :assoc | 
					(assoc value ifTrue: ['Yes'] ifFalse: ['No'])
						asRopedText foreground: (assoc value 
							ifTrue: [ Color black] 
							ifFalse: [ Color lightGray ] ) ] ];
		send: [ :assoc | assoc key ]
	
		
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> isInterruptedContextPostMortem [
	
	^ self isContextPostMortem: self interruptedContext
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> restartInterruptedContext [
	self restart: self interruptedContext
]

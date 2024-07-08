Extension { #name : #DebugSession }

{ #category : #'*GToolkit-Debugger' }
DebugSession >> allDebuggerSpecifications [
	^ ((self allStandaloneDebuggerSpecifications
		, self allMoldableExceptionDebuggersSpecifications)
			reject: [ :aDebuggerSpecifications |
				aDebuggerSpecifications isNil ])
			sorted: [ :aDebuggerSpecifications |
				aDebuggerSpecifications priority ] ascending
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> allMoldableExceptionDebuggersSpecifications [
	| pragmas |
	self exception ifNil: [ ^ #() ].
	
	pragmas := Pragma
		allNamed: #gtDebuggerSpecification
		from: self exception class
		to: Exception.

	^ pragmas collect: [ :aPragma | 
		 self exception 
			perform: aPragma methodSelector ].
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> allStandaloneDebuggerSpecifications [
	^ Smalltalk tools registeredDebuggersWithRanks 
		collect: [ :assoc |
			assoc key debuggerSpecification
				ifNil: [ nil ]
				ifNotNil: [ :aDebuggerSpecifications |
					aDebuggerSpecifications
						priority: assoc value;
						yourself ] ]
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> applicableDebuggerSpecifications [
	^ ((self applicableStandaloneDebuggerSpecifications
		, self applicableMoldableExceptionDebuggersSpecifications)
			reject: [ :aDebuggerSpecifications |
				aDebuggerSpecifications isNil ])
			sorted: [ :aDebuggerSpecifications |
				aDebuggerSpecifications priority ] ascending
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> applicableMoldableExceptionDebuggersSpecifications [
	| possibleSpecifications |

	possibleSpecifications := self allMoldableExceptionDebuggersSpecifications.
			
	^ possibleSpecifications select: [ :aDebuggerSpecification |
		aDebuggerSpecification handlesDebugSession: self ]
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> applicableStandaloneDebuggerSpecifications [
	^ self applicableStandaloneDebuggerTypesWithRanks 
		collect: [ :assoc |
			assoc key debuggerSpecification
				ifNil: [ nil ]
				ifNotNil: [ :aDebuggerSpecification |
					aDebuggerSpecification
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
DebugSession >> findContextSuchThat: aTestBlock withMaxDepth: aMaxDepth ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self interruptedContext
		findContextSuchThat: aTestBlock 
		withMaxDepth: aMaxDepth
		ifFound: aFoundBlock 
		ifNone: aNoneBlock
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> findLimitedContextSuchThat: aTestBlock [ 
	^ self 
		findLimitedContextSuchThat: aTestBlock 
		ifFound: [ :aContext | aContext ] 
		ifNone: [ nil ]
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> findLimitedContextSuchThat: aTestBlock ifFound: aFoundBlock ifNone: aNoneBlock [
	^ self 
		findContextSuchThat: aTestBlock 
		withMaxDepth: self maxStackSearchDepth
		ifFound: aFoundBlock 
		ifNone: aNoneBlock
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> findLimitedFullActiveContextForMethod: aCompiledMethod  ifFound: aFoundBlock ifNone: aNoneBlock [
	self isInterruptedContextPostMortem ifTrue: [ ^ aNoneBlock value ].
	^ self 
		findLimitedContextSuchThat: [ :aContext |
			aContext compiledCode = aCompiledMethod ] 
		ifFound: aFoundBlock 
		ifNone: aNoneBlock
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
	session := self
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
			(self allDebuggerSpecifications collect: [ :aDebuggerSpecification |	
				aDebuggerSpecification -> (aDebuggerSpecification 
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
DebugSession >> hasLimitedFullActiveContextForMethod: aCompiledMethod [ 
	^ (self 
		findLimitedFullActiveContextForMethod: aCompiledMethod
		ifFound: [ :aContext | true ] 
		ifNone: [ false ]) 
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> isInterruptedContextPostMortem [
	
	^ self isContextPostMortem: self interruptedContext
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> maxStackSearchDepth [
	"A limit for how long to search the stack for most debugging operations"
	^ 100
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> restartInterruptedContext [
	self restart: self interruptedContext
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> stepOverUntil: aBlock [
	[ aBlock cull: interruptedContext ]
		whileFalse: [ self stepOver: interruptedContext ]
]

Extension { #name : #DebugSession }

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
DebugSession >> isInterruptedContextPostMortem [
	
	^ self isContextPostMortem: self interruptedContext
]

{ #category : #'*GToolkit-Debugger' }
DebugSession >> restartInterruptedContext [
	self restart: self interruptedContext
]

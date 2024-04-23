Extension { #name : #ToolRegistry }

{ #category : #'*GToolkit-Debugger' }
ToolRegistry >> debuggerDispatcherForDebugSession: aDebugSession matching: aBlock [
	| debuggers |
	debuggers := self debuggersWithRanksMatching: [ :aDebuggerClass | 
		(aDebuggerClass includesBehavior: GtDebuggerElement) and: [
			(aBlock value: aDebuggerClass) and: [ 
				aDebuggerClass handlesDebugSession: aDebugSession ] ] ].
	(debuggers size > 0) ifTrue: [ ^ (debuggers at: 1) key ].
	^ nil
]

{ #category : #'*GToolkit-Debugger' }
ToolRegistry >> debuggersForDebugSession: aDebugSession [

	^ self debuggersMatching: [ :aDebuggerClass | 
		(aDebuggerClass includesBehavior: GtDebuggerElement) and: [ 
			aDebuggerClass handlesDebugSession: aDebugSession ] ]
]

{ #category : #'*GToolkit-Debugger' }
ToolRegistry >> debuggersMatching: aBlock [

	^ (self debuggersWithRanksMatching: aBlock) 
			inject: OrderedCollection new
			into: [ :aCollection :aPair | aCollection add: aPair key; yourself ]
]

{ #category : #'*GToolkit-Debugger' }
ToolRegistry >> debuggersWithRanksMatching: aBlock [

	^ (self registeredDebuggersWithRanks
			select: [ :aPair | aBlock value: aPair key ])
			sort: [ :pair1 :pair2 | pair1 value < pair2 value ].
]

{ #category : #'*GToolkit-Debugger' }
ToolRegistry >> registerDebugger: anObject withRank: anInteger [
	|debuggers|
	
	debuggers  := tools at: #debuggers ifAbsent: [
		tools at: #debuggers put: OrderedCollection new ]. 
	(debuggers anySatisfy: [:each| each key == anObject] ) ifFalse: [ 
		debuggers add: anObject -> anInteger ].
	self announcer announce: (ToolRegistryToolRegistered tool: anObject name: #debuggers)
]

{ #category : #'*GToolkit-Debugger' }
ToolRegistry >> registeredDebuggersWithRanks [
	
	^ tools at: #debuggers ifAbsent: [
		tools at: #debuggers put: OrderedCollection new ]
]

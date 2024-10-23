Trait {
	#name : #TGtScripterDebuggerExamples,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'private - debugging' }
TGtScripterDebuggerExamples >> debuggerOn: aBlock stoppingAt: aTestBlock [
	<return: #DebugSession>
	| aDebugSession |
	aDebugSession := self debugSessionOn: aBlock stoppingAt: aTestBlock.
		
	^ (GtMoldableDebugger on: aDebugSession) beDetailedLevel
]

{ #category : #'private - debugging' }
TGtScripterDebuggerExamples >> debugSessionOn: aBlock [
	<return: #DebugSession>
	| aProcess aDebugSession |
	aProcess := aBlock newProcess.
	aDebugSession := DebugSession
			named: 'Scripted debugger'
			on: aProcess
			startedAt: aProcess suspendedContext.

	^ aDebugSession
]

{ #category : #'private - debugging' }
TGtScripterDebuggerExamples >> debugSessionOn: aBlock stoppingAt: aTestBlock [
	<return: #DebugSession>
	| aProcess aDebugSession |
	aProcess := aBlock newProcess.
	aDebugSession := self debugSessionOn: aBlock.
	
	[ aTestBlock value: aDebugSession interruptedContext ]
		whileFalse: [ aDebugSession stepInto ].
		
	^ aDebugSession
]

{ #category : #'private - debugging' }
TGtScripterDebuggerExamples >> debugSessionOn: aBlock withException: anExceptionClass [
	<return: #DebugSession>
	aBlock
		on: anExceptionClass
		do: [ :anException | 
			^ DebugSession forExceptionFromExampleFor: anException ].

	^ nil
]

{ #category : #'private - debugging' }
TGtScripterDebuggerExamples >> scripterWithDebuggerOn: aBlock stoppingAt: aTestBlock [
	<return: #DebugSession>
	| aDebugger aScripter |
	aDebugger := self debuggerOn: aBlock stoppingAt: aTestBlock.
	
	aScripter := BlScripter new.
	aScripter element: aDebugger.
	^ aScripter
]

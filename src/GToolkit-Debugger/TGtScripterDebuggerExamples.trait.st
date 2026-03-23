Trait {
	#name : #TGtScripterDebuggerExamples,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'private - debugging' }
TGtScripterDebuggerExamples >> debugSessionOn: aBlock [
	<return: #GtDebugSession>
	| aProcess aDebugSession |
	aProcess := aBlock newProcess.
	aDebugSession := GtDebugSession
			named: 'Scripted debugger'
			on: aProcess
			startedAt: aProcess suspendedContext.

	^ aDebugSession
]

{ #category : #'private - debugging' }
TGtScripterDebuggerExamples >> debugSessionOn: aBlock stoppingAt: aTestBlock [
	<return: #GtDebugSession>
	| aProcess aDebugSession |
	aProcess := aBlock newProcess.
	aDebugSession := self debugSessionOn: aBlock.
	
	[ aTestBlock value: aDebugSession interruptedContext ]
		whileFalse: [ aDebugSession stepInto ].
		
	^ aDebugSession
]

{ #category : #'private - debugging' }
TGtScripterDebuggerExamples >> debugSessionOn: aBlock withException: anExceptionClass [
	<return: #GtDebugSession>
	aBlock
		on: anExceptionClass
		do: [ :anException | 
			^ GtDebugSession forExceptionFromExampleFor: anException ].

	^ nil
]

{ #category : #'private - debugging' }
TGtScripterDebuggerExamples >> debuggerOn: aBlock stoppingAt: aTestBlock [
	<return: #GtDebugSession>
	| aDebugSession |
	aDebugSession := self debugSessionOn: aBlock stoppingAt: aTestBlock.
		
	^ (GtMoldableDebugger on: aDebugSession) beDetailedLevel
]

{ #category : #'private - debugging' }
TGtScripterDebuggerExamples >> scripterWithDebuggerOn: aBlock stoppingAt: aTestBlock [
	<return: #GtDebugSession>
	| aDebugger aScripter |
	aDebugger := self debuggerOn: aBlock stoppingAt: aTestBlock.
	
	aScripter := BlScripter new.
	aScripter element: aDebugger.
	^ aScripter
]

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

{ #category : #private }
TGtScripterDebuggerExamples >> debugSessionOn: aBlock withException: anExceptionClass [
	"Create a debug session by freezing the exception's context chain.
	The frozen contexts include the entire caller chain of the current
	process. Do not terminate or resume the returned session, as that
	would unwind copied contexts from the calling process (e.g. the CI
	test runner's ensure blocks). Use #forkedDebugSessionOn:withException:
	when the test needs to terminate or resume the debug session."
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

{ #category : #private }
TGtScripterDebuggerExamples >> forkedDebugSessionOn: aBlock withException: anExceptionClass [
	"Run aBlock in a forked process. On exception, suspend the process
	and create a debug session on the actual suspended process, as is
	done during the normal debugger opening.
	Use instead of #debugSessionOn:withException: when the test
	terminates or resumes the debug session. Without the fork,
	forExceptionFromExampleFor: copies the entire caller chain including
	the CI test runner's ensure blocks; terminating or resuming that
	debug session unwinds those copied contexts, firing tearDown on
	the shared report object and crashing the CI run.
	Forks at +1 priority so that signal and suspend execute without
	preemption from the waiting test process."
	<return: #GtDebugSession>
	| exception semaphore forkedProcess debugSession |
	
	semaphore := Semaphore new.
	forkedProcess := [
		| exceptionCaught |
		exceptionCaught := false.
		aBlock
			on: anExceptionClass
			do: [ :anException |
				exception := anException.
				exceptionCaught := true.
				semaphore signal.
				Processor activeProcess suspend ].
		exceptionCaught ifFalse: [ semaphore signal ]
	] forkAt: Processor activePriority + 1.
	
	semaphore wait.
	exception ifNil: [ ^ nil ].
	
	debugSession := forkedProcess
		newDebugSessionNamed: exception description
		startedAt: exception signalerContext.
	debugSession exception: exception.
	
	^ debugSession
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

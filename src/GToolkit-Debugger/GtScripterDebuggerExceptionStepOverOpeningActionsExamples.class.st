Class {
	#name : #GtScripterDebuggerExceptionStepOverOpeningActionsExamples,
	#superclass : #GtScripterDebuggerExceptionActionsExamples,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #testing }
GtScripterDebuggerExceptionStepOverOpeningActionsExamples class >> isAbstract [
	^ true
]

{ #category : #examples }
GtScripterDebuggerExceptionStepOverOpeningActionsExamples >> debuggerOnException [
	<gtExample>
	<return: #BlScripter>
	<noTest>
	| targetMethod debuggerElement scripter |
	targetMethod := self class lookupSelector: #targetMethod_signalError.
	debuggerElement := self
			debuggerOn: [ self class new targetMethod_signalError ]
			stoppingAt: [ :context | context selector = targetMethod selector ].
	
	scripter := BlScripter new.
	scripter element: debuggerElement.
	
	scripter debugger
		assertIsMainDebuggerElement;
		assertInSessionStackSize: 3;
		assertInSessionNoException;
		assertCommonNormalExecutionDebuggingActionsForNormalStepping;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #error:;
		assertInCodersListVisuallyHighlightedString: 'error: ''An exception happend!''' atTopIndex: 1;
		play.
	
	self clickOnStepOverThatTriggersExceptionInMethod: targetMethod for: scripter.
		
	^ scripter
]

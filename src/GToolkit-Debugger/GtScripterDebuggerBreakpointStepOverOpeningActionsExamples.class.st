Class {
	#name : #GtScripterDebuggerBreakpointStepOverOpeningActionsExamples,
	#superclass : #GtScripterDebuggerBreakpointActionsExamples,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #examples }
GtScripterDebuggerBreakpointStepOverOpeningActionsExamples >> debuggerOnBreakpoint [
	<gtExample>
	<after: #removeBreakpoint>
	<return: #BlScripter>
	| callerMethod debuggerElement scripter |
	self installBreakpointOnTargetMethod.
	callerMethod := self class lookupSelector: #targetMethodCallingBreakpointSend.
	debuggerElement := self
		debuggerOn: [ self class new targetMethodCallingBreakpointSend ]
		stoppingAt: [ :context | context selector = callerMethod selector ].

	scripter := BlScripter new.
	scripter element: debuggerElement.

	scripter debugger
		label: 'Assert initial state before step over';
		assertIsMainDebuggerElement;
		assertInSessionNoException;
		assertCommonNormalExecutionDebuggingActionsForNormalStepping;
		assertInCodersContextMethod: callerMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_withBreakpointSend;
		play.

	self assert: scripter element debugSession isAtBreakpointTrigger not.

	scripter debugger
		label: 'Step over triggers breakpoint';
		clickOnStepOverButton;
		assertInSessionExceptionOfType: Break;
		play.

	self assert: scripter element debugSession isAtBreakpointTrigger not.
	^ scripter
]

{ #category : #examples }
GtScripterDebuggerBreakpointStepOverOpeningActionsExamples >> stepOverActionAfterBreakpoint [
	<gtExample>
	<after: #removeBreakpoint>
	<return: #BlScripter>
	| scripter |
	scripter := self debuggerOnBreakpoint.

	scripter debugger
		label: 'First step over past the breakpoint';
		clickOnStepOverButton;
		assertInSessionNoException;
		play.

	scripter debugger
		label: 'Second step over past the breakpoint';
		clickOnStepOverButton;
		assertInSessionNoException;
		play.

	scripter debugger
		label: 'Step over completes past the breakpoint';
		clickOnStepOverButton;
		assertInSessionNoException;
		assertNextInstructionMessageSendSelector: #factorial;
		play.

	self assert: scripter element debugSession isAtBreakpointTrigger not.
	^ scripter
]

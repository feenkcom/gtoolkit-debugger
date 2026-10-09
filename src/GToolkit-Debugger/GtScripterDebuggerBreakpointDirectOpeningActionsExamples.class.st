Class {
	#name : #GtScripterDebuggerBreakpointDirectOpeningActionsExamples,
	#superclass : #GtScripterDebuggerBreakpointActionsExamples,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #examples }
GtScripterDebuggerBreakpointDirectOpeningActionsExamples >> debuggerOnBreakpoint [
	<gtExample>
	<after: #removeBreakpoint>
	<return: #BlScripter>
	| targetMethod debuggerSession debuggerElement aScripter |
	self installBreakpointOnTargetMethod.
	targetMethod := self class lookupSelector: #targetMethod_withBreakpointSend.
	debuggerSession := self
		debugSessionOn: [ self class new targetMethod_withBreakpointSend ]
		withException: Break.
	self assert: debuggerSession isAtBreakpointTrigger.
	debuggerElement := (GtMoldableDebugger on: debuggerSession) beDetailedLevel.
	self assert: debuggerElement debugSession isAtBreakpointTrigger not.

	aScripter := BlScripter new.
	aScripter element: debuggerElement.

	aScripter debugger
		label: 'Assert initial debugger state after breakpoint';
		assertIsMainDebuggerElement;
		assertCommonNormalExecutionDebuggingActionsForNormalStepping;
		assertInSessionNoException;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #factorial;
		play.

	^ aScripter
]

{ #category : #examples }
GtScripterDebuggerBreakpointDirectOpeningActionsExamples >> stepOverActionAfterBreakpoint [
	<gtExample>
	<after: #removeBreakpoint>
	<return: #BlScripter>
	| scripter |
	scripter := self debuggerOnBreakpoint.

	scripter debugger
		label: 'Step over the breakpointed send';
		clickOnStepOverButton;
		assertInSessionNoException;
		assertNextInstructionMatches: [ :instruction :is | is willStore ] 
			label: 'Next instruction is store after stepping over factorial';
		assertInCodersListVisuallyHighlightedString: 'x := 42 factorial' atTopIndex: 1;
		play.

	self assert: scripter element debugSession isAtBreakpointTrigger not.
	^ scripter
]

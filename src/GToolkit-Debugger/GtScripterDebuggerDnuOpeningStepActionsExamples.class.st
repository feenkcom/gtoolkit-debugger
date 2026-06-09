Class {
	#name : #GtScripterDebuggerDnuOpeningStepActionsExamples,
	#superclass : #GtScripterDebuggerDNUActionsExamples,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #testing }
GtScripterDebuggerDnuOpeningStepActionsExamples class >> isAbstract [
	^ true
]

{ #category : #'examples - setup' }
GtScripterDebuggerDnuOpeningStepActionsExamples >> debuggerOnDoesNotUnderstandMessage [
	<gtExample>
	<return: #BlScripter>
	| targetMethod debuggerElement scripter |
	targetMethod := self class lookupSelector: #targetMethod_callToNotImplementedMethod.
	debuggerElement := self
			debuggerOn: [ self class new targetMethod_callToNotImplementedMethod ]
			stoppingAt: [ :context | context selector = targetMethod selector ].
	
	scripter := BlScripter new.
	scripter element: debuggerElement.
	
	scripter debugger
		assertIsMainDebuggerElement;
		assertInSessionStackSize: 3;
		assertInSessionNoException;
		assertCommonNormalExecutionDebuggingActionsForNormalStepping;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #methodThatIsNotImplemented;
		assertInCodersListVisuallyHighlightedString: 'methodThatIsNotImplemented' atTopIndex: 1;
		play.
	
	self clickOnStepOverThatTriggersDnuInMethod: targetMethod for: scripter.
		
	scripter assert
		label: 'The context that triggered the DNU should return';
		satisfies: [ :anDebuggerElement | 
			| instructionStream |
			instructionStream := anDebuggerElement debugSession interruptedContext 
				sender sender instructionStream.
			instructionStream willReturn ];
		play.
		
	^ scripter
]

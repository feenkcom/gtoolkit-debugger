Class {
	#name : #GtScripterDebuggerDnuDirectOpeningActionsExamples,
	#superclass : #GtScripterDebuggerDNUActionsExamples,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'examples - setup' }
GtScripterDebuggerDnuDirectOpeningActionsExamples >> debuggerOnDoesNotUnderstandMessage [
	<gtExample>
	<return: #BlScripter>
	| targetMethod debuggerSession debuggerElement aScripter |
	targetMethod := self class lookupSelector: #targetMethod_callToNotImplementedMethod.
	debuggerSession := self
			debugSessionOn: [ self class new targetMethod_callToNotImplementedMethod ]
			withException: MessageNotUnderstood.
	debuggerElement := (GtMoldableDebugger on: debuggerSession) beDetailedLevel.
	
	aScripter := BlScripter new.
	aScripter element: debuggerElement.
	
	aScripter debugger
		label: 'Assert initial debugger state';
		assertIsMainDebuggerElement;
		assertCommonDNUExecutionDebuggingActions;
		assertInSessionExceptionOfType: MessageNotUnderstood;
		assertInSessionContextMethod: Object>>#doesNotUnderstand:  atTopIndex: 1;
		assertInSessionContextMethod: targetMethod  atTopIndex: 2;
		"Visually the DNU context is not visible initially in the list"
		assertInCodersListContextMethod: targetMethod atTopIndex: 1;
		assertInCodersListVisuallyHighlightedString: 'methodThatIsNotImplemented' atTopIndex: 1;
		play.
		
	aScripter assert
		label: 'The context that triggered the DNU should return';
		satisfies: [ :aDebuggerElement | 
			| instructionStream |
			instructionStream := aDebuggerElement debugSession interruptedContext sender instructionStream.
			instructionStream willReturn ];
		play.
		
	^ aScripter
]

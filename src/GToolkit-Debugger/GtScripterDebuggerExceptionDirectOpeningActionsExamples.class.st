Class {
	#name : #GtScripterDebuggerExceptionDirectOpeningActionsExamples,
	#superclass : #GtScripterDebuggerExceptionActionsExamples,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #examples }
GtScripterDebuggerExceptionDirectOpeningActionsExamples >> debuggerOnException [
	<gtExample>
	<return: #BlScripter>
	| targetMethod debuggerSession debuggerElement aScripter |
	targetMethod := self class lookupSelector: #targetMethod_signalError.
	debuggerSession := self
			debugSessionOn: [ self class new targetMethod_signalError ]
			withException: Error.
	debuggerElement := (GtMoldableDebugger on: debuggerSession) beDetailedLevel.
	
	aScripter := BlScripter new.
	aScripter element: debuggerElement.
	aScripter model: debuggerSession.
	
	aScripter debugger
		label: 'Assert initial debugger state';
		assertIsMainDebuggerElement;
		assertCommonNormalExecutionDebuggingActionsForForceStepping;
		assertInSessionExceptionOfType: Error;
		assertInSessionContextMethod: targetMethod atTopIndex: 2;
		assertInCodersListContextMethod: targetMethod atTopIndex: 2;
		assertInCodersListVisuallyHighlightedString: 'error: ''An exception happend!''' atTopIndex: 2;
		play.
		
	^ aScripter
]

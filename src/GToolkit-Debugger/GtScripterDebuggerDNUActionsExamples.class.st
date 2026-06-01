Class {
	#name : #GtScripterDebuggerDNUActionsExamples,
	#superclass : #Object,
	#traits : 'TGtScripterDebuggerExamples',
	#classTraits : 'TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #testing }
GtScripterDebuggerDNUActionsExamples class >> isAbstract [
	^ self name = #GtScripterDebuggerDNUActionsExamples
]

{ #category : #'utils - stepping' }
GtScripterDebuggerDNUActionsExamples >> clickOnStepOverThatTriggersConfirmationInMethod: aTargetMethod for: aScripter [
	aScripter debugger
		label: 'Attempt normal execution of step over action';
		clickOnStepOverButton;
		assertEnforceStepConfirmationForDebugActionWithId: #stepOver actionLabel: 'Step over';
		play.
	"TODO: check state is not changed"
]

{ #category : #'utils - stepping' }
GtScripterDebuggerDNUActionsExamples >> clickOnStepOverThatTriggersDnuInMethod: aTargetMethod for: aScripter [
	aScripter debugger
		label: 'Step over a DNU after a restart';
		clickOnStepOverButton;
		assertInSessionExceptionOfType: MessageNotUnderstood;
		assertInSessionContextMethod: Exception>>#signal  atTopIndex: 1;
		assertInSessionContextMethod: Object>>#doesNotUnderstand:  atTopIndex: 2;
		assertInSessionContextMethod: aTargetMethod  atTopIndex: 3;
		"Visually the DNU context is not visible initially in the list"
		assertInCodersListContextMethod: aTargetMethod atTopIndex: 1;
		assertInCodersListVisuallyHighlightedString: 'methodThatIsNotImplemented' atTopIndex: 1;
		play.
]

{ #category : #'examples - setup' }
GtScripterDebuggerDNUActionsExamples >> debuggerOnDoesNotUnderstandMessage [
	<gtExample>
	<return: #BlScripter>
	
	self subclassResponsibility
]

{ #category : #'utils - stepping' }
GtScripterDebuggerDNUActionsExamples >> enforceStepOverActionAfterDnuInMethod: aTargetMethod for: aScripter [
	aScripter debugger
		clickOnForceExecuteDebuggingAction;
		assertInSessionExceptionOfType: MessageNotUnderstood;
		assertInCodersContextMethod: aTargetMethod atTopIndex: 1;
		assertNextInstructionWillReturn;
		assertInCodersListVisuallyHighlightedString: '^ self methodThatIsNotImplemented' atTopIndex: 1;
		play.
]

{ #category : #'examples - stepping' }
GtScripterDebuggerDNUActionsExamples >> forceResumeActionAfterDNU [
	<gtExample>
	<return: #BlScripter>
	| targetMethod scripter |
	targetMethod := self class lookupSelector: #targetMethod_callToNotImplementedMethod.
	scripter := self debuggerOnDoesNotUnderstandMessage.
	
	scripter debugger
		label: 'Attempt normal execution of resume action';
		clickOnResumeButton;
		assertEnforceStepConfirmationForDebugActionWithId: #resume actionLabel: 'Proceed';
		play.
	"TODO: check state is not changed"
	
	scripter debugger
		label: 'Enforce resume action run';
		clickOnForceExecuteDebuggingAction;
		play.
		
	scripter assert
		label: 'Execution is terminated';
		satisfies: [ :aDebuggerElement | 
			aDebuggerElement debugSession isNil ];
		play.
		
	^ scripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerDNUActionsExamples >> forceStepIntoActionAfterDNU [
	<gtExample>
	<return: #BlScripter>
	| targetMethod scripter |
	targetMethod := self class lookupSelector: #targetMethod_callToNotImplementedMethod.
	scripter := self debuggerOnDoesNotUnderstandMessage.
	
	scripter debugger
		label: 'Attempt normal execution of step into action';
		clickOnStepIntoButton;
		assertEnforceStepConfirmationForDebugActionWithId: #stepInto actionLabel: 'Step into';
		play.
	"TODO: check state is not changed"
	
	scripter debugger
		label: 'Enforce step into action run';
		clickOnForceExecuteDebuggingAction;
		assertInSessionExceptionOfType: MessageNotUnderstood;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionWillReturn;
		assertInCodersListVisuallyHighlightedString: '^ self methodThatIsNotImplemented' atTopIndex: 1;
		play.
		
	^ scripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerDNUActionsExamples >> forceStepOverActionAfterDNU [
	<gtExample>
	<return: #BlScripter>
	| targetMethod scripter |
	targetMethod := self class lookupSelector: #targetMethod_callToNotImplementedMethod.
	scripter := self debuggerOnDoesNotUnderstandMessage.
	
	self clickOnStepOverThatTriggersConfirmationInMethod: targetMethod for: scripter.
	self enforceStepOverActionAfterDnuInMethod: targetMethod for: scripter.
		
	^ scripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerDNUActionsExamples >> forceStepThroughActionAfterDNU [
	<gtExample>
	<return: #BlScripter>
	| targetMethod scripter |
	targetMethod := self class lookupSelector: #targetMethod_callToNotImplementedMethod.
	scripter := self debuggerOnDoesNotUnderstandMessage.
	
	scripter debugger
		label: 'Attempt normal execution of step through action';
		clickOnStepThroughButton;
		play.
	"TODO: check state is not changed"
	
	scripter debugger
		label: 'Enforce step through action run';
		assertEnforceStepConfirmationForDebugActionWithId: #stepThrough actionLabel: 'Step through';
		clickOnForceExecuteDebuggingAction;
		assertInSessionExceptionOfType: MessageNotUnderstood;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionWillReturn;
		assertInCodersListVisuallyHighlightedString: '^ self methodThatIsNotImplemented' atTopIndex: 1;
		play.
		
	^ scripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerDNUActionsExamples >> restartActionAfterDNU [
	<gtExample>
	<return: #BlScripter>
	| targetMethod scripter |
	targetMethod := self class lookupSelector: #targetMethod_callToNotImplementedMethod.
	scripter := self debuggerOnDoesNotUnderstandMessage.
	
	scripter debugger
		label: 'Restart action after DNU';
		clickOnRestartButton;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #methodThatIsNotImplemented;
		assertInCodersListVisuallyHighlightedString: 'methodThatIsNotImplemented' atTopIndex: 1;
		play.
		
	^ scripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerDNUActionsExamples >> restartActionAfterDNU_forceStepOver [
	<gtExample>
	<return: #BlScripter>
	| targetMethod scripter |
	
	targetMethod := self class lookupSelector: #targetMethod_callToNotImplementedMethod.
	scripter := self restartActionAfterDNU.
	
	self clickOnStepOverThatTriggersDnuInMethod: targetMethod for: scripter.
	self clickOnStepOverThatTriggersConfirmationInMethod: targetMethod for: scripter.
	self enforceStepOverActionAfterDnuInMethod: targetMethod for: scripter.
		
	^ scripter
]

{ #category : #'methods - utils' }
GtScripterDebuggerDNUActionsExamples >> targetMethod_callToNotImplementedMethod [
	^ self methodThatIsNotImplemented
]

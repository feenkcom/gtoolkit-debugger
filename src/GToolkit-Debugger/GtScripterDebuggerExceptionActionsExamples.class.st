Class {
	#name : #GtScripterDebuggerExceptionActionsExamples,
	#superclass : #Object,
	#traits : 'TGtScripterDebuggerExamples',
	#classTraits : 'TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #testing }
GtScripterDebuggerExceptionActionsExamples class >> isAbstract [
	^ self name = #GtScripterDebuggerExceptionActionsExamples
]

{ #category : #'private - actions' }
GtScripterDebuggerExceptionActionsExamples >> clickOnStepOverThatTriggersExceptionInMethod: aTargetMethod for: aScripter [
	aScripter debugger
		label: 'Step over an exception after a restart';
		clickOnStepOverButton;
		assertInSessionExceptionOfType: Error;
		assertInSessionContextMethod: Exception>>#signal atTopIndex: 1;
		assertInSessionContextMethod: aTargetMethod atTopIndex: 4;
		assertInCodersListContextMethod: aTargetMethod atTopIndex: 4;
		assertInCodersListVisuallyHighlightedString: 'error: ''An exception happend!''' atTopIndex: 4;
		play.
]

{ #category : #examples }
GtScripterDebuggerExceptionActionsExamples >> debuggerOnException [
	<gtExample>
	<return: #BlScripter>
	
	self subclassResponsibility
]

{ #category : #examples }
GtScripterDebuggerExceptionActionsExamples >> forceStepIntoActionAfterException [
	<gtExample>
	<return: #BlScripter>
	
	| targetMethod scripter |
	targetMethod := self class lookupSelector: #targetMethod_signalError.
	scripter := self debuggerOnException.
	
	self selectContextForForceStepActionIn: scripter.
		
	scripter debugger
		label: 'Attempt normal execution of step into action';
		clickOnStepIntoButton;
		assertEnforceStepConfirmationForDebugActionWithId: #stepInto actionLabel: 'Step into';
		assertInSessionExceptionOfType: Error;
		play.
		
	scripter debugger
		label: 'Enforce step into action run';
		clickOnForceExecuteDebuggingAction;
		assertInSessionNoException;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionWillReturn;
		assertInCodersListVisuallyHighlightedString: '^ self error: ''An exception happend!''' atTopIndex: 1;
		play.
		
	^ scripter
]

{ #category : #examples }
GtScripterDebuggerExceptionActionsExamples >> forceStepOverActionAfterException [
	<gtExample>
	<return: #BlScripter>

	| targetMethod scripter |
	targetMethod := self class lookupSelector: #targetMethod_signalError.
	scripter := self debuggerOnException.
	
	self selectContextForForceStepActionIn: scripter.
	
	scripter debugger
		label: 'Attempt normal execution of step over action';
		clickOnStepOverButton;
		assertEnforceStepConfirmationForDebugActionWithId: #stepOver actionLabel: 'Step over';
		assertInSessionExceptionOfType: Error;
		play.
	
	scripter debugger
		label: 'Enforce step over action run';
		clickOnForceExecuteDebuggingAction;
		assertInSessionNoException;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionWillReturn;
		assertInCodersListVisuallyHighlightedString: '^ self error: ''An exception happend!''' atTopIndex: 1;
		play.
		
	^ scripter
]

{ #category : #examples }
GtScripterDebuggerExceptionActionsExamples >> forceStepThroughActionAfterException [
	<gtExample>
	<return: #BlScripter>
	
	| targetMethod scripter |
	targetMethod := self class lookupSelector: #targetMethod_signalError.
	scripter := self debuggerOnException.
	
	self selectContextForForceStepActionIn: scripter.
	
	scripter debugger
		label: 'Attempt normal execution of step through action';
		clickOnStepThroughButton;
		assertEnforceStepConfirmationForDebugActionWithId: #stepThrough actionLabel: 'Step through';
		assertInSessionExceptionOfType: Error;
		play.
	
	scripter debugger
		label: 'Enforce step through action run';
		clickOnForceExecuteDebuggingAction;
		assertInSessionNoException;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionWillReturn;
		assertInCodersListVisuallyHighlightedString: '^ self error: ''An exception happend!''' atTopIndex: 1;
		play.
		
	^ scripter
]

{ #category : #examples }
GtScripterDebuggerExceptionActionsExamples >> restartActionAfterException [
	<gtExample>
	<return: #BlScripter>

	| targetMethod scripter |
	targetMethod := self class lookupSelector: #targetMethod_signalError.
	scripter := self debuggerOnException.
	
	self selectContextForForceStepActionIn: scripter.
	
	scripter debugger
		label: 'Restart action after exception';
		clickOnRestartButton;
		assertInSessionNoException;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #error:;
		assertInCodersListVisuallyHighlightedString: 'error: ''An exception happend!''' atTopIndex: 1;
		play.
		
	^ scripter
]

{ #category : #examples }
GtScripterDebuggerExceptionActionsExamples >> restartActionAfterException_forceStepOver [
	<gtExample>
	<return: #BlScripter>

	| targetMethod scripter |
	
	targetMethod := self class lookupSelector: #targetMethod_signalError.
	scripter := self restartActionAfterException.
	
	self clickOnStepOverThatTriggersExceptionInMethod: targetMethod for: scripter.
	
	scripter debugger
		label: 'Attempt normal execution of step over action';
		clickOnStepOverButton;
		assertEnforceStepConfirmationForDebugActionWithId: #stepOver actionLabel: 'Step over';
		assertInSessionExceptionOfType: Error;
		play.
	
	scripter debugger
		label: 'Enforce step over action run';
		clickOnForceExecuteDebuggingAction;
		assertInSessionNoException;
		assertInCodersContextMethod: (Error lookupSelector: #signal:) atTopIndex: 1;
		assertInCodersContextMethod: targetMethod atTopIndex: 3;
		assertNextInstructionWillReturn;
		assertInCodersListVisuallyHighlightedString: 'error: ''An exception happend!''' atTopIndex: 3;
		play.
		
	^ scripter
]

{ #category : #'as yet unclassified' }
GtScripterDebuggerExceptionActionsExamples >> selectContextForForceStepActionIn: aScripter [
	aScripter click
		label: 'Give focus to the right context';
		// GtSourceCoderEditorId;
		@ [ :aCoderElement | 
			aCoderElement textualCoderViewModel context selector = #targetMethod_signalError];
		// GtSourceCoderEditorInnerId;
		play.
]

{ #category : #'examples - target' }
GtScripterDebuggerExceptionActionsExamples >> targetMethod_signalError [
	^ self error: 'An exception happend!'
]

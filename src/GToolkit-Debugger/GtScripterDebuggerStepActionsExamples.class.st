Class {
	#name : #GtScripterDebuggerStepActionsExamples,
	#superclass : #Object,
	#traits : 'TGtScripterDebuggerExamples',
	#classTraits : 'TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> restartActionsBeforeMethodWillRetun [
	<gtExample>
	<return: #BlScripter>
	| targetMethod aScripter |
	targetMethod := GtScripterDebuggerStepActionsExamples>>#targetMethod_mainForStepActions.
	aScripter := self stepOverActionsInSingleMethod.
	
	aScripter debugger
		clickOnRestartButton;
		assertIsMainDebuggerElement;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_firstForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_firstForStepActions' atTopIndex: 1;
		play.
		
	^ aScripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepIntoActionIntoFirstMethodCall [
	<gtExample>
	<return: #BlScripter>
	| targetMethod stepIntoMethod debuggerElement aScripter |
	targetMethod := GtScripterDebuggerStepActionsExamples>>#targetMethod_mainForStepActions.
	stepIntoMethod := GtScripterDebuggerStepActionsExamples>>#targetMethod_firstForStepActions. 
	debuggerElement := self
			debuggerOn: [ self class new targetMethod_mainForStepActions ]
			stoppingAt: [ :context | context selector = targetMethod selector ].
	
	aScripter := BlScripter new.
	aScripter element: debuggerElement.
	
	aScripter debugger
		assertIsMainDebuggerElement;
		assertInSessionNoException;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_firstForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_firstForStepActions' atTopIndex: 1;
		play.
	
	aScripter debugger
		clickOnStepIntoButton;
		assertInSessionStackSize: 4;
		assertInCodersContextMethod: stepIntoMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #+;
		assertInCodersListVisuallyHighlightedString: '+ 1' atTopIndex: 1;
		play.
		
	^ aScripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepIntoActionIntoSecondMethodCallWithQuickMethod [
	<gtExample>
	<return: #BlScripter>
	| targetMethod stepIntoMethod debuggerElement aScripter |
	targetMethod := self class >>#targetMethod_mainForStepActions.
	stepIntoMethod := self class >>#targetMethod_secondForStepActions. 
	debuggerElement := self
			debuggerOn: [ self class new targetMethod_mainForStepActions ]
			stoppingAt: [ :context | context selector = targetMethod selector ].
	
	aScripter := BlScripter new.
	aScripter element: debuggerElement.
	
	aScripter debugger
		assertIsMainDebuggerElement;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_firstForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_firstForStepActions' atTopIndex: 1;
		play.
	
	aScripter debugger
		clickOnStepOverButton;
		clickOnStepIntoButton;
		assertInSessionStackSize: 4;
		assertInCodersContextMethod: stepIntoMethod atTopIndex: 1;
		assertNextInstructionWillReturn;
		assertInCodersListVisuallyHighlightedString: '^ 42' atTopIndex: 1;
		play.
		
	^ aScripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepOutOfQuickMethodReturnUsingStepInto [
	<gtExample>
	<return: #BlScripter>
	| targetMethod scripter |
	targetMethod := self class >>#targetMethod_mainForStepActions.
	scripter := self stepIntoActionIntoSecondMethodCallWithQuickMethod.
		
	scripter debugger
		clickOnStepIntoButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_thirdForStepActions' atTopIndex: 1;
		play.
		
	^ scripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepOutOfQuickMethodReturnUsingStepOver [
	<gtExample>
	<return: #BlScripter>
	| targetMethod scripter |
	targetMethod := self class >>#targetMethod_mainForStepActions.
	scripter := self stepIntoActionIntoSecondMethodCallWithQuickMethod.
		
	scripter debugger
		clickOnStepOverButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		"assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_thirdForStepActions' atTopIndex: 1;"
		play.
		
	^ scripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepOutOfQuickMethodReturnUsingStepThrough [
	<gtExample>
	<return: #BlScripter>
	| targetMethod scripter |
	targetMethod := self class >>#targetMethod_mainForStepActions.
	scripter := self stepIntoActionIntoSecondMethodCallWithQuickMethod.
		
	scripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_thirdForStepActions' atTopIndex: 1;
		play.
		
	^ scripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepOverActionsInSingleMethod [
	<gtExample>
	<return: #BlScripter>
	| targetMethod debuggerElement aScripter |
	targetMethod := self class >>#targetMethod_mainForStepActions.
	debuggerElement := self
			debuggerOn: [ self class new targetMethod_mainForStepActions ]
			stoppingAt: [ :context | context selector = targetMethod selector ].
	
	aScripter := BlScripter new.
	aScripter element: debuggerElement.
	
	aScripter debugger
		assertIsMainDebuggerElement;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_firstForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_firstForStepActions' atTopIndex: 1;
		play.
	
	aScripter debugger
		clickOnStepOverButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_secondForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_secondForStepActions' atTopIndex: 1;
		play.
		
	aScripter debugger
		clickOnStepOverButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_thirdForStepActions' atTopIndex: 1;
		play.
		
	aScripter debugger
		clickOnStepOverButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMatches: [ :nextInstruction :anInstructionStream |
				anInstructionStream willReturn ]
			label: 'Assert next instruction will return';
		assertInCodersListVisuallyHighlightedString: targetMethod sourceCode atTopIndex: 1;
		play.
		
	^ aScripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepThroughActionsInSingleMethod [
	<gtExample>
	<return: #BlScripter>
	| targetMethod debuggerElement aScripter |
	targetMethod := self class >>#targetMethod_mainForStepActions.
	debuggerElement := self
			debuggerOn: [ self class new targetMethod_mainForStepActions ]
			stoppingAt: [ :context | context selector = targetMethod selector ].
	
	aScripter := BlScripter new.
	aScripter element: debuggerElement.
	
	aScripter debugger
		assertIsMainDebuggerElement;
		assertInSessionNoException;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_firstForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_firstForStepActions' atTopIndex: 1;
		play.
	
	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_secondForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_secondForStepActions' atTopIndex: 1;
		play.
		
	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		assertInCodersListVisuallyHighlightedString: 'targetMethod_thirdForStepActions' atTopIndex: 1;
		play.
		
	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMatches: [ :nextInstruction :anInstructionStream |
				anInstructionStream willReturn ]
			label: 'Assert next instruction will return';
		assertInCodersListVisuallyHighlightedString: targetMethod sourceCode atTopIndex: 1;
		play.
		
	^ aScripter
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_firstForStepActions [
	^ 1 + 1
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_mainForStepActions [
	self targetMethod_firstForStepActions.
	self targetMethod_secondForStepActions.
	self targetMethod_thirdForStepActions.
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_secondForStepActions [
	^ 42
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_thirdForStepActions [
	^ 2 factorial
]

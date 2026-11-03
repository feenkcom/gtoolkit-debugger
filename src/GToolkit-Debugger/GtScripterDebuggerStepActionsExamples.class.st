Class {
	#name : #GtScripterDebuggerStepActionsExamples,
	#superclass : #Object,
	#traits : 'TGtScripterDebuggerExamples',
	#classTraits : 'TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'private - debugging' }
GtScripterDebuggerStepActionsExamples >> assertIn: aScripter topContextTempNamed: aName equals: anObject [
	aScripter assert
		label: 'Assert temporary ' , aName printString , ' of the top context is '
				, anObject printString;
		value: [ :aDebugger | aDebugger debugSession interruptedContext tempNamed: aName ]
			equals: anObject;
		play
]

{ #category : #'private - debugging' }
GtScripterDebuggerStepActionsExamples >> compiledBlockIn: aSelector withSource: aString [
	"Answer the compiled block of the method aSelector whose source is aString"

	<return: #CompiledBlock>
	^ (self class >> aSelector) allBlocks
		detect: [ :each | each sourceNode sourceCode = aString ]
]

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

{ #category : #'private - debugging' }
GtScripterDebuggerStepActionsExamples >> scripterWithDebuggerOnTargetMethod: aSelector [
	"Open a debugger on a new instance executing aSelector, stopped at the beginning of that method"

	<return: #BlScripter>
	| targetMethod aScripter |
	targetMethod := self class >> aSelector.
	aScripter := self
			scripterWithDebuggerOn: [ self class new perform: aSelector ]
			stoppingAt: [ :context | context selector = aSelector ].

	aScripter debugger
		assertIsMainDebuggerElement;
		assertInSessionNoException;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
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

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepThroughIntoBlockEvaluatedByDo [
	"Step through a #do: send enters the block. #do: stays between the block and the method,
	and stepping through the end of the block continues with the next element."

	<gtExample>
	<return: #BlScripter>
	| targetMethod blockMethod doMethod aScripter |
	targetMethod := self class >> #targetMethod_doLoopForStepThrough.
	blockMethod := self
			compiledBlockIn: #targetMethod_doLoopForStepThrough
			withSource: '[ :each | each + 1 ]'.
	doMethod := Array lookupSelector: #do:.
	aScripter := self
			scripterWithDebuggerOnTargetMethod: #targetMethod_doLoopForStepThrough.

	aScripter debugger
		assertNextInstructionMessageSendSelector: #with:with:;
		clickOnStepOverButton;
		clickOnStepOverButton;
		assertNextInstructionMessageSendSelector: #do:;
		play.	
		
	"First element"
	aScripter debugger 
		clickOnStepThroughButton;
		assertInSessionStackSize: 5;
		assertInSessionContextMethod: blockMethod atTopIndex: 1;
		assertInSessionContextMethod: doMethod atTopIndex: 2;
		assertInSessionContextMethod: targetMethod atTopIndex: 3;
		assertNextInstructionMessageSendSelector: #+;
		play.
		
	self
		assertIn: aScripter
		topContextTempNamed: #each
		equals: 10.	
		
	"Second element"
	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 5;
		assertNextInstructionWillReturn;
		clickOnStepThroughButton;
		assertInSessionStackSize: 5;
		assertInSessionContextMethod: blockMethod atTopIndex: 1;
		assertInSessionContextMethod: doMethod atTopIndex: 2;
		assertNextInstructionMessageSendSelector: #+;
		play.
	self
		assertIn: aScripter
		topContextTempNamed: #each
		equals: 20.	
		
	"Back in the method after the loop"
	aScripter debugger
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		play.

	^ aScripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepThroughIntoBlockEvaluatedInSameMethod [
	"Step through a #value send to a block stored in a temporary enters the block.
	The method stays below the block, and execution continues in the method after the block returns."

	<gtExample>
	<return: #BlScripter>
	| targetMethod blockMethod aScripter |
	targetMethod := self class >> #targetMethod_blockValueForStepThrough.
	blockMethod := self
			compiledBlockIn: #targetMethod_blockValueForStepThrough
			withSource: '[ self targetMethod_firstForStepActions ]'.
	aScripter := self
			scripterWithDebuggerOnTargetMethod: #targetMethod_blockValueForStepThrough.

	aScripter debugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		assertNextInstructionMessageSendSelector: #value;
		play.

	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 4;
		assertInSessionContextMethod: blockMethod atTopIndex: 1;
		assertInSessionContextMethod: targetMethod atTopIndex: 2;
		assertNextInstructionMessageSendSelector: #targetMethod_firstForStepActions;
		play.

	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 4;
		assertNextInstructionWillReturn;
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		play.

	^ aScripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepThroughIntoBlockWithArguments [
	"Step through a #value:value: send enters the block with the right argument values."

	<gtExample>
	<return: #BlScripter>
	| targetMethod blockMethod aScripter |
	targetMethod := self class >> #targetMethod_blockWithArgumentsForStepThrough.
	blockMethod := self
			compiledBlockIn: #targetMethod_blockWithArgumentsForStepThrough
			withSource: '[ :first :second | first + second ]'.
	aScripter := self
			scripterWithDebuggerOnTargetMethod: #targetMethod_blockWithArgumentsForStepThrough.

	aScripter debugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		assertNextInstructionMessageSendSelector: #value:value:;
		play.

	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 4;
		assertInSessionContextMethod: blockMethod atTopIndex: 1;
		assertInSessionContextMethod: targetMethod atTopIndex: 2;
		assertNextInstructionMessageSendSelector: #+;
		play.
	self
		assertIn: aScripter
		topContextTempNamed: #first
		equals: 3.
	self
		assertIn: aScripter
		topContextTempNamed: #second
		equals: 4.

	aScripter debugger
		clickOnStepThroughButton;
		assertNextInstructionWillReturn;
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		play.

	^ aScripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepThroughIntoEnsureBlocks [
	"Step through an #ensure: send enters the receiver block with #ensure: below it,
	and continues into the ensure block once the receiver block returns."

	<gtExample>
	<return: #BlScripter>
	| targetMethod receiverBlockMethod ensureBlockMethod ensureMethod aScripter |
	targetMethod := self class >> #targetMethod_ensureForStepThrough.
	receiverBlockMethod := self
			compiledBlockIn: #targetMethod_ensureForStepThrough
			withSource: '[ self targetMethod_firstForStepActions ]'.
	ensureBlockMethod := self
			compiledBlockIn: #targetMethod_ensureForStepThrough
			withSource: '[ self targetMethod_secondForStepActions ]'.
	ensureMethod := BlockClosure >> #ensure:.
	aScripter := self
			scripterWithDebuggerOnTargetMethod: #targetMethod_ensureForStepThrough.

	aScripter debugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		assertNextInstructionMessageSendSelector: #ensure:;
		play.	
		
	"The receiver block"
	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 5;
		assertInSessionContextMethod: receiverBlockMethod atTopIndex: 1;
		assertInSessionContextMethod: ensureMethod atTopIndex: 2;
		assertInSessionContextMethod: targetMethod atTopIndex: 3;
		assertNextInstructionMessageSendSelector: #targetMethod_firstForStepActions;
		play.	
		
	"The ensure block"
	aScripter debugger
		clickOnStepThroughButton;
		assertNextInstructionWillReturn;
		clickOnStepThroughButton;
		assertInSessionStackSize: 5;
		assertInSessionContextMethod: ensureBlockMethod atTopIndex: 1;
		assertInSessionContextMethod: ensureMethod atTopIndex: 2;
		assertNextInstructionMessageSendSelector: #targetMethod_secondForStepActions;
		play.

	aScripter debugger
		clickOnStepThroughButton;
		assertNextInstructionWillReturn;
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		play.

	^ aScripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepThroughIntoNestedBlock [
	"Step through from inside a block enters a nested block."

	<gtExample>
	<return: #BlScripter>
	| targetMethod outerBlockMethod innerBlockMethod doMethod aScripter |
	targetMethod := self class >> #targetMethod_nestedBlocksForStepThrough.
	outerBlockMethod := self
			compiledBlockIn: #targetMethod_nestedBlocksForStepThrough
			withSource: '[ :each | (Array with: each) do: [ :item | item + 1 ] ]'.
	innerBlockMethod := self
			compiledBlockIn: #targetMethod_nestedBlocksForStepThrough
			withSource: '[ :item | item + 1 ]'.
	doMethod := Array lookupSelector: #do:.
	aScripter := self
			scripterWithDebuggerOnTargetMethod: #targetMethod_nestedBlocksForStepThrough.

	aScripter debugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		assertNextInstructionMessageSendSelector: #do:;
		play.	
		
	"The outer block"
	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 5;
		assertInSessionContextMethod: outerBlockMethod atTopIndex: 1;
		assertInSessionContextMethod: doMethod atTopIndex: 2;
		assertNextInstructionMessageSendSelector: #with:;
		clickOnStepThroughButton;
		clickOnStepThroughButton;
		assertNextInstructionMessageSendSelector: #do:;
		play.	
		
	"The inner block"
	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 7;
		assertInSessionContextMethod: innerBlockMethod atTopIndex: 1;
		assertInSessionContextMethod: doMethod atTopIndex: 2;
		assertInSessionContextMethod: outerBlockMethod atTopIndex: 3;
		assertInSessionContextMethod: doMethod atTopIndex: 4;
		assertInSessionContextMethod: targetMethod atTopIndex: 5;
		assertNextInstructionMessageSendSelector: #+;
		play.
	self
		assertIn: aScripter
		topContextTempNamed: #item
		equals: 1.	
		
	"Back in the outer block, then in the method"
	aScripter debugger
		clickOnStepThroughButton;
		assertNextInstructionWillReturn;
		clickOnStepThroughButton;
		assertInSessionStackSize: 5;
		assertInSessionContextMethod: outerBlockMethod atTopIndex: 1;
		assertNextInstructionWillReturn;
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		play.

	^ aScripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepThroughIntoOnDoProtectedBlock [
	"Step through an #on:do: send enters the protected block with #on:do: below it."

	<gtExample>
	<return: #BlScripter>
	| targetMethod blockMethod onDoMethod aScripter |
	targetMethod := self class >> #targetMethod_onDoForStepThrough.
	blockMethod := self
			compiledBlockIn: #targetMethod_onDoForStepThrough
			withSource: '[ self targetMethod_firstForStepActions ]'.
	onDoMethod := BlockClosure >> #on:do:.
	aScripter := self
			scripterWithDebuggerOnTargetMethod: #targetMethod_onDoForStepThrough.

	aScripter debugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		assertNextInstructionMessageSendSelector: #on:do:;
		play.

	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 5;
		assertInSessionContextMethod: blockMethod atTopIndex: 1;
		assertInSessionContextMethod: onDoMethod atTopIndex: 2;
		assertInSessionContextMethod: targetMethod atTopIndex: 3;
		assertNextInstructionMessageSendSelector: #targetMethod_firstForStepActions;
		play.

	aScripter debugger
		clickOnStepThroughButton;
		assertNextInstructionWillReturn;
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		play.

	^ aScripter
]

{ #category : #'examples - stepping' }
GtScripterDebuggerStepActionsExamples >> stepThroughSameBlockTwice [
	"Step through two #value sends to the same block enters the block both times
	with the same stack."

	<gtExample>
	<return: #BlScripter>
	| targetMethod blockMethod aScripter |
	targetMethod := self class >> #targetMethod_sameBlockTwiceForStepThrough.
	blockMethod := self
			compiledBlockIn: #targetMethod_sameBlockTwiceForStepThrough
			withSource: '[ self targetMethod_firstForStepActions ]'.
	aScripter := self
			scripterWithDebuggerOnTargetMethod: #targetMethod_sameBlockTwiceForStepThrough.

	aScripter debugger
		clickOnStepOverButton;
		clickOnStepOverButton;
		assertNextInstructionMessageSendSelector: #value;
		play.	
		
	"First evaluation"
	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 4;
		assertInSessionContextMethod: blockMethod atTopIndex: 1;
		assertInSessionContextMethod: targetMethod atTopIndex: 2;
		clickOnStepThroughButton;
		assertNextInstructionWillReturn;
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #value;
		play.	
		
	"Second evaluation"
	aScripter debugger
		clickOnStepThroughButton;
		assertInSessionStackSize: 4;
		assertInSessionContextMethod: blockMethod atTopIndex: 1;
		assertInSessionContextMethod: targetMethod atTopIndex: 2;
		assertNextInstructionMessageSendSelector: #targetMethod_firstForStepActions;
		clickOnStepThroughButton;
		assertNextInstructionWillReturn;
		clickOnStepThroughButton;
		assertInSessionStackSize: 3;
		assertInCodersContextMethod: targetMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: #targetMethod_thirdForStepActions;
		play.

	^ aScripter
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_blockValueForStepThrough [
	| aBlock |
	aBlock := [ self targetMethod_firstForStepActions ].
	aBlock value.
	self targetMethod_thirdForStepActions
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_blockWithArgumentsForStepThrough [
	| aBlock |
	aBlock := [ :first :second | first + second ].
	aBlock value: 3 value: 4.
	self targetMethod_thirdForStepActions
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_doLoopForStepThrough [
	(Array with: 10 with: 20) do: [ :each | each + 1 ].
	self targetMethod_thirdForStepActions
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_ensureForStepThrough [
	[ self targetMethod_firstForStepActions ]
		ensure: [ self targetMethod_secondForStepActions ].
	self targetMethod_thirdForStepActions
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
GtScripterDebuggerStepActionsExamples >> targetMethod_nestedBlocksForStepThrough [
	(Array with: 1) do: [ :each | (Array with: each) do: [ :item | item + 1 ] ].
	self targetMethod_thirdForStepActions
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_onDoForStepThrough [
	[ self targetMethod_firstForStepActions ]
		on: ZeroDivide
		do: [ :anError | anError return: 0 ].
	self targetMethod_thirdForStepActions
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_sameBlockTwiceForStepThrough [
	| aBlock |
	aBlock := [ self targetMethod_firstForStepActions ].
	aBlock value.
	aBlock value.
	self targetMethod_thirdForStepActions
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_secondForStepActions [
	^ 42
]

{ #category : #'methods - utils' }
GtScripterDebuggerStepActionsExamples >> targetMethod_thirdForStepActions [
	^ 2 factorial
]

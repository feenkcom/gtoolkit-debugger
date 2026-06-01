Class {
	#name : #GtDebuggerDevScripterCheckStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertCommonDNUExecutionDebuggingActions [
	self 
		substeps2: 'Assert common debugging actions after a DNU'
		do: [ :aSubStep |
			aSubStep debugger
				assertExistsDebugActionWithId: #doesNotUnderstand;
				assertNormalExecutionStateForDebugActionWithId: #doesNotUnderstand;
				assertNormalExecutionStateForDebugActionWithId: #restart;
				assertNormalExecutionStateForDebugActionWithId: #copyToClipboard;
				assertEnforceStepStateForDebugActionWithId: #stepOver;
				assertEnforceStepStateForDebugActionWithId: #stepInto;
				assertEnforceStepStateForDebugActionWithId: #stepThrough;
				assertEnforceStepStateForDebugActionWithId: #runToHere;
				assertEnforceStepStateForDebugActionWithId: #resume ]
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertCommonNormalExecutionDebuggingActions [
	self 
		substeps2: 'Assert common debugging actions '
		do: [ :aSubStep |
			aSubStep debugger
				assertNormalExecutionStateForDebugActionWithId: #restart;
				assertNormalExecutionStateForDebugActionWithId: #copyToClipboard ;
				assertNormalExecutionStateForDebugActionWithId: #stepOver;
				assertNormalExecutionStateForDebugActionWithId: #stepInto;
				assertNormalExecutionStateForDebugActionWithId: #stepThrough;
				assertNormalExecutionStateForDebugActionWithId: #runToHere;
				assertNormalExecutionStateForDebugActionWithId: #resume ]
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertDebuggerSwitchButtonsWithLabels: aCollectionOfLabels [
	self assert
		label: 'Assert switch debugger buttons container exists';
		exists;
		// GtMoldableDebuggerSwitchButtonsContainerElementId.
		
	self assert
		label: 'Assert number of switch debugger elements';
		childrenCount: aCollectionOfLabels size;
		// GtMoldableDebuggerSwitchButtonsContainerElementId.
		
	self assert
		label: 'Assert number of switch debugger tabs';
		value: [ :aTabsGroup | aTabsGroup tabs size ] equals: aCollectionOfLabels size ;
		// GtMoldableDebuggerSwitchButtonsContainerElementId.
		
	self assert
		label: 'Assertswitch debugger tab labels';
		value: [ :aTabsGroup | 
			(aTabsGroup viewModel tabs 
				collect: [ :aTab | aTab tabLabel text asString ]) asArray ] equals: aCollectionOfLabels;
		// GtMoldableDebuggerSwitchButtonsContainerElementId.
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertEnforceStepConfirmationForDebugActionWithId: aButtonId actionLabel: anActionLabel [
	| step |
	
	step := self 
		substeps2: 'Assert enforce run confirmation for debug action with id ', aButtonId printString
		do: [ :aSubStep |
		
			aSubStep assert
				onParentStepTarget: aSubStep;
				label: 'Assert handle button is present';
				exists;
				// (#forced, (aButtonId asString capitalized)) asSymbol.
			aSubStep assert
				onParentStepTarget: aSubStep;
				label: 'Assert confirmation dropdown is present';
				exists;
				// GtDebuggerDebuggingActionConfirmationElementId.
			aSubStep assert
				onParentStepTarget: aSubStep;
				label: 'Assert force execute button is present';
				exists;
				// GtDebuggerDebuggingActionConfirmationButtonId.
				
			aSubStep assert
				onParentStepTarget: aSubStep;
				label: 'Assert force execute button is present';
				value: [ :aLabel | aLabel text asString ] 
					equals: ('Cannot directly {1}. Force action.' format: {anActionLabel asLowercase});
				// GtDebuggerDebuggingActionConfirmationElementId;
				// BrLabel  ].
	
	step
		referenceSender;
		onPopover.
	
	^ step
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertEnforceStepStateForDebugActionWithId: aButtonId [
	| step |
	
	step := self 
		substeps2: 'Assert force state for debug action with id ', aButtonId printString
		do: [ :aSubStep |
		
			aSubStep assert
				onParentStepTarget: aSubStep;
				label: 'Assert debugging action state';
				satisfies: [ :aButton | 
					aButton debuggingAction canBeDirectlyRun not and: [
						aButton debuggingAction isAllowedToEnforceExecution and: [
							aButton debuggingAction isRunnableDirectlyOrForced] ] ].
		
			aSubStep assert
				onParentStepTarget: aSubStep;
				label: 'Assert button is enabled';
				satisfies: [ :aButton | 
					aButton isEnabled ].
					
			aSubStep assert
				onParentStepTarget: aSubStep;
				label: 'Assert button background color';
				satisfies: [ :aButton | 
					| obtainedColor |
					obtainedColor := (aButton background paint color class = BlThemeableColor) 
						ifTrue: [aButton background paint color rawColor ]
						ifFalse: [aButton background paint color].
					 obtainedColor = aButton theme button disabledBackgroundColor ].
					 
			aSubStep menuStep
				onParentStepTarget: aSubStep;
				displayTooltip.
			aSubStep do
				onParentStepTarget: aSubStep;
				block: [ :aButton | 
					| expectedValue tooltipQuery |
					expectedValue := 'Force ', aButton debuggingAction label asLowercase.
					tooltipQuery := (aButton space root query 
						// BrMenuSteppedElement
						// BrMenuTextLabelElement ) . 
					self assert: tooltipQuery result size equals: 1.
					
					self assert: tooltipQuery result first labelText asString equals: expectedValue ] ].
	
	step
		referenceSender;
		// GtMoldableDebuggerToolbarElementId;
		// aButtonId.
	
	^ step
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertExistsDebugActionWithId: aButtonId [
	self assert
		label: 'Assert debug acction with id ', aButtonId printString , ' exists.';
		exists;
		// GtMoldableDebuggerToolbarElementId;
		// aButtonId
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertInCodersContextMethod: aMethod atTopIndex: anIndex [
	self assertInSessionContextMethod: aMethod atTopIndex: anIndex.
	self assertInCodersListContextMethod: aMethod atTopIndex: anIndex
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertInCodersListContextMethod: aMethod atTopIndex: anIndex [
	self assert
		label: 'Assert context in coders list at index ', anIndex asString ,' has method ', aMethod printString;
		value: [ :aCoderElement | 
				aCoderElement textualCoderViewModel coderModel compiledMethod   ] 
			equals: aMethod;
		// GtSourceCoderExpandedContentElement;
		@ anIndex
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertInCodersListVisuallyHighlightedString: aString atTopIndex: anIndex [
	self assert
		label: 'Assert context in coders list at index ', anIndex asString;
		value: [ :aCoderElement | 
				| attributes |
				attributes := Dictionary new.
				aCoderElement textualCoderViewModel styledText
					attributeRunsDo: [ :from :to :attrs | 
						attrs
							do: [ :each | 
								| locations |
								locations := attributes at: each ifAbsentPut: [ OrderedCollection new ].
								(locations notEmpty and: [ locations last last + 1 = from ])
									ifTrue: [ locations at: locations size put: (locations last first to: to) ]
									ifFalse: [ locations add: (from to: to) ] ] ].
				
				attributes keys 
					detect: [ :eachAttribute |
					(eachAttribute isKindOf: BlTextHighlightAttribute) and: [ 
						eachAttribute paint = BrGlamorousColors debuggerTextHighlightColor ] ]
					ifFound: [:anAttribute | 
						 (aCoderElement textualCoderViewModel styledText 
						 	copyFrom: (attributes at: anAttribute) first first 
						 	to: (attributes at: anAttribute) first last )
						 		asString ] 
					ifNone: [ Error signal: 'no highlight found' ] ] 
			equals: aString;
		// GtSourceCoderExpandedContentElement;
		@ anIndex
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertInSessionContextMethod: aMethod atTopIndex: anIndex [
	self assert
		label: 'Assert context in session at index ', anIndex asString ,' has method ', aMethod printString;
		value: [ :anDebuggerElement | 
				(anDebuggerElement debugSession interruptedContext stack at: anIndex) method  ] 
			equals: aMethod
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertInSessionExceptionOfType: anExceptionClass [
	self assert
		label: 'Assert debug session has exception of type ', anExceptionClass name;
		satisfies: [ :anDebuggerElement | 
			anDebuggerElement debugSession exception isKindOf: anExceptionClass  ]
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertInSessionNoException [
	self assert
		label: 'Assert debug session has no exception ';
		satisfies: [ :anDebuggerElement | 
			anDebuggerElement debugSession exception isNil  ]
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertInSessionStackSize: anInteger [
	self assert
		label: 'Assert stack size in the debug session is ', anInteger asString;
		value: [ :anDebuggerElement | 
			anDebuggerElement debugSession interruptedContext stack size  ] equals: anInteger
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertIsMainDebuggerElement [
	self assert
		label: 'Assert main debugger element id';
		value: [ :anElement | anElement id ] equals: GtMoldableDebuggerMainElementId new
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertNextInstructionMatches: aBlock label: aLabel [
	self assert
		label: aLabel;
		satisfies: [ :anDebuggerElement | 
			| instructionStream |
			instructionStream := anDebuggerElement debugSession interruptedContext instructionStream.
			aBlock cull: instructionStream peekInstruction cull: instructionStream ] 
			
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertNextInstructionMessageSendSelector: aSelector [
	self 
		assertNextInstructionMatches: [ :nextInstruction :anInstructionStream |
			anInstructionStream willSend and: [
				nextInstruction arguments first = aSelector ] ]
		label: 'Assert next instruction will send ', aSelector
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertNextInstructionWillReturn [
	self 
		assertNextInstructionMatches: [ :nextInstruction :anInstructionStream |
			anInstructionStream willReturn ]
		label: 'Assert next instruction will return'
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertNormalExecutionStateForDebugActionWithId: aButtonId [
	| step |
	
	step := self 
		substeps2: 'Assert normal execution state for debug action with id ', aButtonId printString
		do: [ :aSubStep |
		
			aSubStep assert
				onParentStepTarget: aSubStep;
				label: 'Assert debugging action state';
				satisfies: [ :aButton | 
					aButton debuggingAction canBeDirectlyRun and: [
						aButton debuggingAction isRunnableDirectlyOrForced  ] ].
		
			aSubStep assert
				onParentStepTarget: aSubStep;
				label: 'Assert button is enabled';
				satisfies: [ :aButton | 
					aButton isEnabled ].
					
			aSubStep assert
				onParentStepTarget: aSubStep;
				label: 'Assert button background color';
				satisfies: [ :aButton | 
					| obtainedColor |
					obtainedColor := (aButton background paint color class = BlThemeableColor) 
						ifTrue: [aButton background paint color rawColor ]
						ifFalse: [aButton background paint color].
					 obtainedColor = Color white ].
					 
			aSubStep menuStep
				onParentStepTarget: aSubStep;
				displayTooltip.
			
			aSubStep do
				onParentStepTarget: aSubStep;
				block: [ :aButton | 
					| expectedValue tooltipQuery |
					expectedValue := aButton debuggingAction label .
					tooltipQuery := (aButton space root query 
						// BrMenuSteppedElement
						// BrMenuTextLabelElement ) . 
					self assert: tooltipQuery result size equals: 1.
					
					self assert: tooltipQuery result first labelText asString equals: expectedValue ] ].
	
	step
		referenceSender;
		// GtMoldableDebuggerToolbarElementId;
		// aButtonId.
	
	^ step
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertPlaygroundExpanderCollapsed [
	^self assert
		label: 'assert playground is collapsed';
		satisfies: [ :anElement | anElement isCollapsed ];
		// GtDebuggerPlaygroundElement
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertPlaygroundExpanderVisible [
	^self assert
		label: 'assert playground is visible';
		satisfies: [ :anElement | anElement isCollapsed not ];
		// GtDebuggerPlaygroundElement
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertSelectedDebuggerOfType: aDebuggerClass [ 

	self assert
		label: 'Assert switch debugger buttons container exists';
		value: [ :aTabsGroup |
			(aTabsGroup tabs detect: [ :aTab | aTab isSelected ]) tabLabel text asString ] equals: aDebuggerClass defaultTitle;
		// GtMoldableDebuggerSwitchButtonsContainerElementId.
		
	self assert
		label: 'Assert debugger of type ', aDebuggerClass name;
		exists;
		// aDebuggerClass.
]

{ #category : #'debugger step actions' }
GtDebuggerDevScripterCheckStep >> clickOnForceExecuteDebuggingAction [
	^self
		substeps2: 'Click force execute debugging action button'
		do: [ :aStep | 
			aStep click
				label: 'Click run button';
				referenceSender;
				onPopover;
				// GtDebuggerDebuggingActionConfirmationButtonId ]
]

{ #category : #'debugger step actions' }
GtDebuggerDevScripterCheckStep >> clickOnRestartButton [
	^self
		substeps2: 'Click restart button'
		do: [ :aStep | 
			aStep click
				label: 'Restart';
				// #restart ]
]

{ #category : #'debugger step actions' }
GtDebuggerDevScripterCheckStep >> clickOnResumeButton [
	^self
		substeps2: 'Click resume button'
		do: [ :aStep | 
			aStep click
				label: 'Resume';
				// #resume ]
]

{ #category : #'debugger step actions' }
GtDebuggerDevScripterCheckStep >> clickOnStepIntoButton [
	^self
		substeps2: 'Click step into button'
		do: [ :aStep | 
			aStep click
				label: 'Step into';
				// #stepInto ]
]

{ #category : #'debugger step actions' }
GtDebuggerDevScripterCheckStep >> clickOnStepOverButton [
	^self
		substeps2: 'Click step over button'
		do: [ :aStep | 
			aStep click
				label: 'Step over';
				// #stepOver ]
]

{ #category : #'debugger step actions' }
GtDebuggerDevScripterCheckStep >> clickOnStepThroughButton [
	^self
		substeps2: 'Click step through button'
		do: [ :aStep | 
			aStep click
				label: 'Step through';
				// #stepThrough ]
]

{ #category : #'accessing - query' }
GtDebuggerDevScripterCheckStep >> debuggerQuery [
	^ self scripter element query debuggerQuery
]

{ #category : #actions }
GtDebuggerDevScripterCheckStep >> doubleClickOnPlaygroudExpander [
	self
		substeps2: 'Click Step Over button'
		do: [ :aStep | 
			aStep doubleClick
				debuggerTarget onPlaygroundResizer ]
]

{ #category : #actions }
GtDebuggerDevScripterCheckStep >> switchToDebuggerLabeled: aDebuggerLabel [
	^ self
		substeps2: 'Click switch debugger button ', aDebuggerLabel
		do: [ :aStep | 
			aStep click
				// GtMoldableDebuggerSwitchButtonsContainerElementId;
				// #tabbar;
				onChildFromBlock: [ :aTabGroup |
					aTabGroup children detect: [ :anElement | 
						anElement label asString = aDebuggerLabel ] ] ]
				
]

{ #category : #actions }
GtDebuggerDevScripterCheckStep >> switchToDebuggerOfType: aDebuggerClass [
	self switchToDebuggerLabeled: aDebuggerClass defaultTitle.
	self assertSelectedDebuggerOfType: aDebuggerClass.
]

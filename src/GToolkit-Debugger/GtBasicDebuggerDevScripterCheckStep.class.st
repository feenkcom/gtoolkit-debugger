Class {
	#name : #GtBasicDebuggerDevScripterCheckStep,
	#superclass : #BlDevScripterToolActionStep,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'steps - checks' }
GtBasicDebuggerDevScripterCheckStep >> assertContextMenuHasItemWithLabel: aLabel [
	"Assert that the opened debugger context menu has an item, see #openContextMenu"

	^ self menuStep
		label: 'Assert debugger context menu has item ' , aLabel printString;
		assertMenuItemWithLabelExists: aLabel;
		onMenuContainer;
		yourself
]

{ #category : #'steps - checks' }
GtBasicDebuggerDevScripterCheckStep >> assertContextMenuHasNoItemWithLabel: aLabel [
	"Assert that the opened debugger context menu has no such item, see #openContextMenu"

	| aMenuStep |
	aMenuStep := self menuStep
			label: 'Assert debugger context menu has no item ' , aLabel printString;
			onMenuContainer;
			yourself.
	aMenuStep assert
		label: ('Assert menu item with label {1} does not exist' format: {aLabel});
		notExists;
		onParentStepTarget: aMenuStep;
		// #'menu--list';
		// #'menu--label';
		@ [ :each | each text asString = aLabel ].
	^ aMenuStep
]

{ #category : #'steps - checks' }
GtBasicDebuggerDevScripterCheckStep >> assertDebuggerSwitchButtonsWithLabels: aCollectionOfLabels [
	self assert
		onParentStepTarget: self;
		label: 'Assert switch debugger buttons container exists';
		exists;
		// GtMoldableDebuggerSwitchButtonsContainerElementId.

	self assert
		onParentStepTarget: self;
		label: 'Assert number of switch debugger elements';
		childrenCount: aCollectionOfLabels size;
		// GtMoldableDebuggerSwitchButtonsContainerElementId.

	self assert
		onParentStepTarget: self;
		label: 'Assert number of switch debugger tabs';
		value: [ :aTabsGroup | aTabsGroup tabs size ]
			equals: aCollectionOfLabels size;
		// GtMoldableDebuggerSwitchButtonsContainerElementId.

	self assert
		onParentStepTarget: self;
		label: 'Assertswitch debugger tab labels';
		value: [ :aTabsGroup | 
				(aTabsGroup viewModel tabs collect: [ :aTab | aTab tabLabel text asString ])
					asArray ]
			equals: aCollectionOfLabels;
		// GtMoldableDebuggerSwitchButtonsContainerElementId
]

{ #category : #'steps - checks' }
GtBasicDebuggerDevScripterCheckStep >> assertExistsDebugActionWithId: aButtonId [
	self assert
		onParentStepTarget: self;
		label: 'Assert debug acction with id ' , aButtonId printString , ' exists.';
		exists;
		// self debggerToolbarId;
		// aButtonId
]

{ #category : #'steps - checks' }
GtBasicDebuggerDevScripterCheckStep >> assertInCodersListVisuallyHighlightedString: aString atTopIndex: anIndex [
	self assert
		onParentStepTarget: self;
		label: 'Assert context in coders list at index ' , anIndex asString;
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
						(eachAttribute isKindOf: BlTextHighlightAttribute)
							and: [ eachAttribute id = GtSourceCoderViewModel debuggerTextHighlightId ] ]
					ifFound: [ :anAttribute | 
						(aCoderElement textualCoderViewModel styledText
							copyFrom: (attributes at: anAttribute) first first
							to: (attributes at: anAttribute) first last) asString trimBoth ]
					ifNone: [ AssertionFailure signal: 'no highlight found' ] ]
			equals: aString trimBoth;
		// (GtExpandableContextMethodCoderId indexed: anIndex)
]

{ #category : #'steps - interactions' }
GtBasicDebuggerDevScripterCheckStep >> clickContextMenuItemWithLabel: aLabel [
	"Click an item of the opened debugger context menu, see #openContextMenu"

	^ self menuStep
		label: 'Click debugger context menu item ' , aLabel printString;
		clickMenuItemWithLabel: aLabel;
		onMenuContainer;
		yourself
]

{ #category : #actions }
GtBasicDebuggerDevScripterCheckStep >> clickOnDebugActionWithId: aButtonId [
	^ self
		substeps2: 'Click debug action with id ' , aButtonId printString
		do: [ :aStep |
			aStep click
				label: 'Click ' , aButtonId printString , ' button';
				// self debggerToolbarId;
				// aButtonId ]
]

{ #category : #'steps - interactions' }
GtBasicDebuggerDevScripterCheckStep >> clickOnRestartButton [
	^self
		substeps2: 'Click restart button'
		do: [ :aStep | 
			aStep click
				label: 'Restart';
				// #restart ]
]

{ #category : #'steps - interactions' }
GtBasicDebuggerDevScripterCheckStep >> clickOnResumeButton [
	^self
		substeps2: 'Click resume button'
		do: [ :aStep | 
			aStep click
				label: 'Resume';
				// #resume ]
]

{ #category : #'steps - toolbar' }
GtBasicDebuggerDevScripterCheckStep >> clickOnRunToCursorButton [
	^ self
		substeps2: 'Click run to cursor button'
		do: [ :aStep |
			aStep click
				label: 'Run to Cursor';
				// #runToCursor ]
]

{ #category : #'steps - interactions' }
GtBasicDebuggerDevScripterCheckStep >> clickOnStepIntoButton [
	^self
		substeps2: 'Click step into button'
		do: [ :aStep | 
			aStep click
				label: 'Step into';
				// #stepInto ]
]

{ #category : #'steps - interactions' }
GtBasicDebuggerDevScripterCheckStep >> clickOnStepOverButton [
	^self
		substeps2: 'Click step over button'
		do: [ :aStep | 
			aStep click
				label: 'Step over';
				// #stepOver ]
]

{ #category : #'steps - interactions' }
GtBasicDebuggerDevScripterCheckStep >> clickOnStepThroughButton [
	^self
		substeps2: 'Click step through button'
		do: [ :aStep | 
			aStep click
				label: 'Step through';
				// #stepThrough ]
]

{ #category : #accessing }
GtBasicDebuggerDevScripterCheckStep >> debggerToolbarId [
	^ self subclassResponsibility
]

{ #category : #'steps - interactions' }
GtBasicDebuggerDevScripterCheckStep >> openContextMenu [
	"Open the dropdown with the actions targeting GtDebuggerContextMenuTarget"

	^ self menuStep
		label: 'Open debugger context menu';
		openDropdownWithId: GtDebuggerContextMenuButtonId
]

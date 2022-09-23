Class {
	#name : #GtPharoStackElement,
	#superclass : #GtAbstractExpandableStackElement,
	#instVars : [
		'stackIndex',
		'treeIndex'
	],
	#category : #'GToolkit-Debugger-GToolkit-Debugger'
}

{ #category : #accessing }
GtPharoStackElement >> actOnCoderInFocusFor: aContextCoderUIModel [
	| context |
	super actOnCoderInFocusFor: aContextCoderUIModel.
	context := aContextCoderUIModel context.
	self updateStackIndexListTo: context.
	self updateTreeIndexTo: context
]

{ #category : #accessing }
GtPharoStackElement >> buildStackIndex [
	| indexList labelBlock |
	indexList := BrColumnedList new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude new beRight;
			background: BrGlamorousColors neutralBackgroundColor;
			rowStencil: BrGlamorousColumnedListSelectableRowElementStencilBuilder new;
			matchParent.
	labelBlock := [ BrLabel new
			margin: (BlInsets right: 10);
			aptitude: BrGlamorousLabelAptitude;
			beSmallSize;
			hMatchParent;
			vFitContent ].
	indexList column
		title: 'Class';
		matchParent;
		cellStencil: labelBlock;
		dataBinder: [ :element :context | element text: (self contextClassText: context) ].
	indexList column
		title: 'Method';
		matchParent;
		cellStencil: labelBlock;
		dataBinder: [ :element :context | element text: (self contextMethodText: context) ].
	indexList column
		title: 'Package';
		cellStencil: labelBlock;
		width: 100;
		dataBinder: [ :element :context | 
			element
				text: (context method package ifNotNil: [ :pkg | pkg name ] ifNil: [ '' ]) ].
	indexList
		addAptitude: (BrColumnedListHeaderAptitude new
				labelStencil: [ :column | 
					| label |
					label := BrLabel new
							aptitude: BrLabelAptitude;
							margin: (BlInsets right: 8);
							text: (column title asRopedText
									glamorousRegularFont;
									fontSize: 12;
									foreground: Color gray).
					column width applyOn: label.
					label ]).
	indexList
		when: BrSelectionChanged
		do: [ :anEvent | self onStackIndexSelectionChanged ].
	^ indexList
]

{ #category : #accessing }
GtPharoStackElement >> buildTreeIndex [
	| indexTree stencil |
	stencil := [ BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			margin: (BlInsets right: 10);
			beSmallSize;
			hMatchParent;
			vFitContent ].

	indexTree := BrColumnedTree new
			rowStencil: BrGlamorousColumnedTreeSelectableRowElementStencilBuilder new.
	indexTree column
		title: 'Receiver';
		cellStencil: stencil;
		weight: 5;
		dataBinder: [ :element :each | 
			element
				text: (each isAssociation
						ifTrue: [ self receiverTextFor: each value first receiver ]
						ifFalse: [ self contextMethodText: each ]) ].
	indexTree column
		title: 'Class';
		cellStencil: stencil;
		weight: 3;
		dataBinder: [ :element :each | 
			element
				text: (each isAssociation
						ifTrue: [ '' ]
						ifFalse: [ each value methodClass printString ]) ].
	indexTree column
		title: 'Package';
		cellStencil: stencil;
		weight: 1;
		dataBinder: [ :element :each | 
			element
				text: (each isAssociation
						ifTrue: [ '' ]
						ifFalse: [ each method package ifNotNil: [ :pkg | pkg name ] ifNil: [ '' ] ]) ].
	indexTree
		when: BrSelectionChanged
		do: [ :anEvent | self onStackTreeSelectionChanged ].
	^ indexTree
]

{ #category : #accessing }
GtPharoStackElement >> computeStackTree: aContextList [
	| result |
	result := OrderedIdentityDictionary new.
	aContextList
		do: [ :each | 
			| receiver |
			receiver := each isBlockContext
					ifTrue: [ each outerContext receiver ]
					ifFalse: [ each receiver ].
			(result at: receiver ifAbsentPut: [ OrderedCollection new ]) add: each ].
	^ result associations
]

{ #category : #accessing }
GtPharoStackElement >> contextClassText: aContext [
	| result |
	result := aContext receiver class printString.
	aContext receiver class == aContext methodClass
		ifFalse: [ result := result , '(' , aContext methodClass printString , ')' ].
	^ result 
]

{ #category : #accessing }
GtPharoStackElement >> contextMethodText: aContext [
	^ aContext isBlockContext
		ifTrue: [ '[] in ' , aContext outerContext method selector ]
		ifFalse: [ aContext method selector ]
]

{ #category : #accessing }
GtPharoStackElement >> initialize [
	super initialize.
	self layout: BlLinearLayout horizontal.
]

{ #category : #accessing }
GtPharoStackElement >> initializeStackList [
	| stackFramesList sidebarElement tabGroup |
	sidebarElement := GtPhlowHorizontalSidebarElement new beLeft.
	self
		addAptitude: (GtPhlowToolDetailAptitude new
				normal: [ :theInstance | sidebarElement hide ];
				detailed: [ :theInstance | sidebarElement show ]).
	stackIndex := self buildStackIndex.
	treeIndex := self buildTreeIndex.

	tabGroup := BrTabGroup new aptitude: BrGlamorousTabGroupAptitude new.
	tabGroup
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: 'Stack';
				stencil: [ stackIndex ]);
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: 'Receivers';
				stencil: [ treeIndex ]).

	sidebarElement addChild: tabGroup.
	stackFramesList := self buildStackFramesList.
	self addChild: sidebarElement.
	self addChild: stackFramesList as: #expandableFrames
]

{ #category : #accessing }
GtPharoStackElement >> onStackChanged [
	| tree |
	self
		inUIProcessDo: [ tree := self computeStackTree: stackModel contextStream toArray wait.
			treeIndex
				items: tree
				immediate: [ :assoc | assoc isAssociation ifTrue: [ assoc value ] ifFalse: [ #() ] ].
			treeIndex expandAll.
			self stackIndexList stream: stackModel contextStream.
			self stackIndexList scrollToIndex: 1.
			self stackFramesList stream: stackModel coderViewModelStream.
			self stackFramesList scrollToIndex: 1 ]
]

{ #category : #accessing }
GtPharoStackElement >> onStackIndexSelectionChanged [
	self
		inUIProcessDo: [ self stackIndexList
				selectedItemDo: [ :context :index | self selectContext: context ] ]
]

{ #category : #accessing }
GtPharoStackElement >> onStackTreeSelectionChanged [
	treeIndex
		selectedNodeDo: [ :node | node value isAssociation ifFalse: [ self selectContext: node value ] ]
]

{ #category : #accessing }
GtPharoStackElement >> receiverClassStringFor: recClass [
	^ (recClass name first isVowel ifTrue: [ 'an ' ] ifFalse: [ 'a ' ])
		, recClass name
]

{ #category : #accessing }
GtPharoStackElement >> receiverTextFor: receiver [
	| classString objectString |
	classString := self receiverClassStringFor: receiver class.
	objectString := self safePrintStringFor: receiver.
	^ classString = objectString
		ifTrue: [ classString asRopedText ]
		ifFalse: [ classString asRopedText
				, ((' (' , objectString , ')') asRopedText foreground: Color gray) ]
]

{ #category : #accessing }
GtPharoStackElement >> safePrintStringFor: anObject [
	^ [anObject printString] onErrorDo: [:ex | 'Error computing printString!' ]
]

{ #category : #accessing }
GtPharoStackElement >> selectContext: aContext [
	super selectContext: aContext.
	self updateStackIndexListTo: aContext.
	self updateTreeIndexTo: aContext
]

{ #category : #accessing }
GtPharoStackElement >> stackFramesList [
	^ self childNamed: #expandableFrames
]

{ #category : #accessing }
GtPharoStackElement >> stackIndexList [
	^ stackIndex
]

{ #category : #accessing }
GtPharoStackElement >> updateStackIndexListTo: aContext [
	| selected |
	self stackIndexList selectedItemDo: [ :context | selected := context ].
	selected ~~ aContext
		ifTrue: [ self stackIndexList scrollToItemSuchThat: [ :each | each == selected ] ]
]

{ #category : #accessing }
GtPharoStackElement >> updateTreeIndexTo: aContext [
	| selected |
	treeIndex
		inUIProcessDo: [ treeIndex selectedNodeDo: [ :each | selected := each value ].
			selected ~~ aContext ifTrue: [ treeIndex selectAndScrollTo: aContext ] ]
]

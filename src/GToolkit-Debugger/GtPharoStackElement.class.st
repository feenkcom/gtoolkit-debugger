Class {
	#name : #GtPharoStackElement,
	#superclass : #GtAbstractExpandableStackElement,
	#category : #'GToolkit-Debugger-GToolkit-Debugger'
}

{ #category : #accessing }
GtPharoStackElement >> actOnCoderInFocusFor: aContextCoderUIModel [
	| aContext |
	super actOnCoderInFocusFor: aContextCoderUIModel.
	self stackIndexList selectedItemDo: [ :context | aContext := context ].
	aContext ~~ aContextCoderUIModel context
		ifTrue: [ self stackIndexList
				selectOne: (self stackIndexList items indexOf: aContextCoderUIModel context) ]
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
	^ indexList
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
	| stackFramesList sidebarElement |
	sidebarElement := GtPhlowHorizontalSidebarElement new beLeft.
	self
		addAptitude: (GtPhlowToolDetailAptitude new
				normal: [ :theInstance | sidebarElement hide ];
				detailed: [ :theInstance | sidebarElement show ]).
	stackFramesList := self buildStackFramesList.
	stackFramesList items: OrderedCollection new.
	self addChild: sidebarElement.
	sidebarElement addChild: self buildStackIndex as: #frameIndex.
	self addChild: stackFramesList as: #expandableFrames.

	self stackIndexList
		when: BrSelectionChanged
		do: [ :anEvent | self onStackIndexSelectionChanged ]
]

{ #category : #accessing }
GtPharoStackElement >> onStackChanged [
	self
		inUIProcessDo: [ self stackIndexList stream: stackModel contextStream.
			self stackIndexList scrollToIndex: 1.
			self stackFramesList stream: stackModel coderViewModelStream.
			self stackFramesList scrollToIndex: 1 ]
]

{ #category : #accessing }
GtPharoStackElement >> onStackIndexSelectionChanged [
	self
		inUIProcessDo: [ self stackIndexList
				selectedItemDo: [ :context :index | 
					self selectContext: context.
					self stackFramesList scrollToIndex: index ] ]
]

{ #category : #accessing }
GtPharoStackElement >> selectContext: aContext [
	super selectContext: aContext.
	self stackIndexList
		selectedItemDo: [ :context |
			context ~~ aContext
				ifTrue: [ self stackIndexList selectOne: (self stackIndexList items indexOf: aContext) ] ]
]

{ #category : #accessing }
GtPharoStackElement >> stackFramesList [
	^ self childNamed: #expandableFrames
]

{ #category : #accessing }
GtPharoStackElement >> stackIndexList [
	^ self childNamed: #frameIndex
]

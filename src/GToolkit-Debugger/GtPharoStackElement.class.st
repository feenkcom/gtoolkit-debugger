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
	| indexList |
	indexList := BrSimpleList new
			addAptitude: BrGlamorousWithHorizontalResizerAptitude new beRight;
			background: BrGlamorousColors neutralBackgroundColor;
			matchParent;
			itemStencil: [ BrLabel new hMatchParent beSmallSize
					aptitude: BrGlamorousLabelAptitude
							+ (BrStyleCommonAptitude new
									default: [ :aStyle | aStyle background: self theme item deselectedColor ];
									hovered: [ :aStyle | aStyle background: self theme item hoveredColor ];
									selected: [ :aStyle | aStyle background: self theme item selectedColor ];
									pressed: [ :aStyle | aStyle background: self theme item pressedColor ];
									focused: [ :aStyle | aStyle border: (BlBorder paint: self theme item focusedBorderColor width: 1) ]) ];
			itemDataBinder: [ :elem :item | 
				| str |
				str := item isBlockContext
						ifTrue: [ '[] in ' , item outerContext method printString ]
						ifFalse: [ item method printString ].
				elem text: str ].
	^ indexList
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
		do: [ :anEvent | self onStackIndexSelectionChanged ].
]

{ #category : #accessing }
GtPharoStackElement >> onStackChanged [
	self
		enqueueTask: [ self stackIndexList stream: stackModel contextStream.
			self stackIndexList scrollToIndex: 1.
			self stackFramesList stream: stackModel coderViewModelStream.
			self stackFramesList scrollToIndex: 1 ] asBlTask
]

{ #category : #accessing }
GtPharoStackElement >> onStackIndexSelectionChanged [
	self
		enqueueTask: [ self stackIndexList
				selectedItemDo: [ :context :index | 
					self selectContext: context.
					self stackFramesList scrollToIndex: index ] ] asBlTask
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

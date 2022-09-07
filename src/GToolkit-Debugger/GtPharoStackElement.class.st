Class {
	#name : #GtPharoStackElement,
	#superclass : #BrHorizontalPane,
	#category : #'GToolkit-Debugger-GToolkit-Debugger'
}

{ #category : #accessing }
GtPharoStackElement >> actOnCoderInFocusFor: anObject [ 
]

{ #category : #accessing }
GtPharoStackElement >> buildStackFramesList [
	| stackFramesList |
	stackFramesList := BrSimpleList new
		matchParent;
		padding: (BlInsets all: 10);
		itemType: [ :itemTypeFactory :eachCoderUIModel | eachCoderUIModel coder elementClass ];
		itemId: [ :eachCoderUIModel | eachCoderUIModel coder id ];
		itemStencil: [ :anElementClass | 
			| coderElement |
			coderElement := anElementClass new.
			coderElement when: BlFocusInEvent do: [ :anEvent | 
				anEvent currentTarget coderViewModel ifNotNil: [
					self actOnCoderInFocusFor: anEvent currentTarget coderViewModel ] ].
			coderElement ];
		itemDataBinder: [ :eachCoderElement :eachCoderUIModel | eachCoderElement coderViewModel: eachCoderUIModel ].

	^ stackFramesList
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
GtPharoStackElement >> coderUIModelsToDisplayFrom: aDebuggingSession preservingContexts: anObject [ 
	| model |
	model := GtPharoStackModel onSession: aDebuggingSession.
	^model coderViewModelStream toArray wait
]

{ #category : #accessing }
GtPharoStackElement >> initialize [
	| stackFramesList |
	super initialize.
	self matchParent.
	stackFramesList := self buildStackFramesList.
	stackFramesList items: OrderedCollection new.
	self addChild: self buildStackIndex as: #frameIndex.
	self addChild: stackFramesList as: #expandableFrames
]

{ #category : #accessing }
GtPharoStackElement >> stackFramesList [
	^ self childNamed: #expandableFrames
]

{ #category : #accessing }
GtPharoStackElement >> stackIndexList [
	^ self childNamed: #frameIndex
]

{ #category : #accessing }
GtPharoStackElement >> updateForSession: aDebuggingSession [
	self stackIndexList
		stream: (GtPharoStackStream onContext: aDebuggingSession context).

	self stackFramesList
		items: (self
				coderUIModelsToDisplayFrom: aDebuggingSession
				preservingContexts: self stackFramesList items asOrderedCollection).

	"self stackFramesList items
		ifNotEmpty: [ :methodCoderUIModels | 
			self selectCoderUIModel: methodCoderUIModels first.
			self stackFramesList scrollToItem: methodCoderUIModels first ]"
]

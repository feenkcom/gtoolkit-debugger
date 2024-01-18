Class {
	#name : #GtPharoStackElement,
	#superclass : #GtAbstractExpandableStackElement,
	#instVars : [
		'stackIndex',
		'stackTab',
		'receiversTab',
		'receiversIndex'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #accessing }
GtPharoStackElement class >> contextMethodText: aContext [
	^ aContext isBlockContext
		ifTrue: [ '[] in ' , aContext outerContext method selector ]
		ifFalse: [ aContext method selector ]
]

{ #category : #updating }
GtPharoStackElement class >> receiversStreamFor: aStackModel [
	"Hack to work around Pharo block's including 'self' and causing a memory leak"

	^ (aStackModel contextStream
		collect: [ :each | 
			each isBlockContext
				ifTrue: [ each outerContext receiver ]
				ifFalse: [ each receiver ] ]) withoutDuplicates useIdentityComparison
		collect: [ :receiver | 
			BrGroup new
				stream: (aStackModel contextStream
						select: [ :context | 
							(context isBlockContext
								ifTrue: [ context outerContext receiver ]
								ifFalse: [ context receiver ]) = receiver ]);
				domainObject: receiver;
				itemStencil: [ BrHorizontalPane new
						margin: (BlInsets left: 10);
						hMatchParent;
						vFitContent ];
				itemDataBinder: [ :pane :each | 
					pane
						addAptitude: BrGlamorousListItemAptitude;
						removeChildren;
						addChild: (BrLabel new
								beSmallSize;
								margin: (BlInsets left: 2 right: 2);
								hMatchParent;
								aptitude: BrGlamorousLabelAptitude;
								text: (self contextMethodText: each);
								yourself);
						addChild: (BrLabel new
								beSmallSize;
								margin: (BlInsets left: 2 right: 2);
								hMatchParent;
								aptitude: BrGlamorousLabelAptitude;
								text: each methodClass printString;
								yourself);
						addChild: (BrLabel new
								beSmallSize;
								margin: (BlInsets left: 2 right: 2);
								hMatchParent;
								aptitude: BrGlamorousLabelAptitude;
								text: (each method package ifNotNil: [ :pkg | pkg name ] ifNil: [ '' ]);
								yourself) ] ]
]

{ #category : #accessing }
GtPharoStackElement >> actOnCoderInFocusFor: aContextCoderUIModel [
	| context |
	super actOnCoderInFocusFor: aContextCoderUIModel.
	context := aContextCoderUIModel context.
	self updateStackIndexListTo: context.
	self updateReceiversIndexTo: context
]

{ #category : #initialization }
GtPharoStackElement >> buildFiltersFrom: filtersElement [
	| filters |
	filters := OrderedCollection new.
	filtersElement
		filtersDo: [ :descriptor :value | filters add: (descriptor newFilterWithValue: value) ].
	^ filters
]

{ #category : #accessing }
GtPharoStackElement >> buildReceiversIndex [
	| list |
	list := BrGroupedList new.
	list
		headerElementStencil: [ BrLabel new
				margin: (BlInsets top: 10);
				beSmallSize;
				aptitude: (BrGlamorousLabelAptitude new foreground: Color gray) ];
		headerDataBinder: [ :label :each | label text: (self receiverTextFor: each domainObject) ].
	list
		when: BrSelectionChanged
		do: [ :anEvent | self onReceiverIndexSelectionChanged ].
	^ list
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
		dataBinder: [ :element :context | element text: (self class contextMethodText: context) ].
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
					column columnWidth applyOn: label.
					label ]).
	indexList
		when: BrSelectionChanged
		do: [ :anEvent | self onStackIndexSelectionChanged ].
	^ indexList
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
GtPharoStackElement >> contextFilters [
	^ stackModel filters
]

{ #category : #accessing }
GtPharoStackElement >> contextFilters: aCollection [
	| filters |
	filters := (aCollection includes: GtSearchImageMethodsFilter forAllMethods)
			ifTrue: [ #() ]
			ifFalse: [ aCollection ].
	stackModel filters: filters.
	self debuggerElement session filters: filters
]

{ #category : #initialization }
GtPharoStackElement >> initialize [
	super initialize.
	self layout: BlLinearLayout horizontal.
]

{ #category : #initialization }
GtPharoStackElement >> initializeStackList [
	| stackFramesList stackPane filtersElement sidebarElement tabGroup |
	sidebarElement := GtPhlowHorizontalSidebarElement new beLeft.
	self
		addAptitude: (GtPhlowToolDetailAptitude new
				normal: [ :aStyle | aStyle do: [ sidebarElement hide ] ];
				detailed: [ :aStyle | aStyle do: [ sidebarElement show ] ]).
	stackIndex := self buildStackIndex.
	receiversIndex := self buildReceiversIndex.
	tabGroup := BrTabGroup new aptitude: BrGlamorousTabGroupAptitude new.
	stackTab := BrTab new
			aptitude: BrGlamorousTabAptitude new;
			label: 'Stack';
			stencil: [ stackIndex ].
	receiversTab := BrTab new
			aptitude: BrGlamorousTabAptitude new;
			label: 'Receivers';
			stencil: [ receiversIndex ].
	tabGroup addTab: stackTab.
	tabGroup addTab: receiversTab.
	sidebarElement addChild: tabGroup.
	self addChild: sidebarElement.
	stackPane := BrVerticalPane new.
	stackPane matchParent.
	stackPane padding: (BlInsets all: 10).
	filtersElement := GtFiltersElement new.
	filtersElement padding: (BlInsets all: 2).
	filtersElement descriptors: GtSearchFilter globalFilterDescriptors.
	filtersElement
		when: GtFiltersChangedEvent
		do: [ :event | self contextFilters: (self buildFiltersFrom: filtersElement) ].
	stackPane addChild: filtersElement as: #filters.
	stackFramesList := self buildStackFramesList.
	stackFramesList items: OrderedCollection new.
	stackPane addChild: stackFramesList as: #expandableFrames.
	self addChild: stackPane
]

{ #category : #accessing }
GtPharoStackElement >> onReceiverIndexSelectionChanged [
	receiversIndex
		selectedEntityDo: [ :value :index | self selectContext: value object ]
]

{ #category : #accessing }
GtPharoStackElement >> onStackChanged [
	super onStackChanged.
	self updateIndexes
]

{ #category : #accessing }
GtPharoStackElement >> onStackIndexSelectionChanged [
	self
		inUIProcessDo: [ self stackIndexList
				selectedItemDo: [ :context :index | self selectContext: context ] ]
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
	self updateReceiversIndexTo: aContext
]

{ #category : #accessing }
GtPharoStackElement >> stackIndexList [
	^ stackIndex
]

{ #category : #updating }
GtPharoStackElement >> updateIndexes [
	self updateReceiversIndex.
	self updateStackIndex
]

{ #category : #updating }
GtPharoStackElement >> updateIndexesSelection [
	| context |
	selectedCoderUIModel isNil ifTrue: [ ^ self ].
	context := selectedCoderUIModel coder context.
	self
		inUIProcessDo: [ self updateStackIndexListTo: context.
			self updateReceiversIndexTo: context ]
]

{ #category : #updating }
GtPharoStackElement >> updateReceiversIndex [
	self
		inUIProcessDo: [ receiversIndex stream: (self class receiversStreamFor: stackModel) ]
]

{ #category : #updating }
GtPharoStackElement >> updateReceiversIndexTo: aContext [
	| selected |
	receiversIndex
		inUIProcessDo: [ receiversIndex selectedEntityDo: [ :each | selected := each object ].
			selected ~~ aContext
				ifTrue: [ 1
						to: receiversIndex viewModel entityCount
						do: [ :i | 
							(receiversIndex viewModel entityAt: i)
								ifNotNil: [ :each | 
									(each isItem and: [ each object == aContext ])
										ifTrue: [ receiversIndex selectOne: i ] ] ] ] ]
]

{ #category : #updating }
GtPharoStackElement >> updateStackIndex [
	self
		inUIProcessDo: [ self stackIndexList stream: stackModel contextStream.
			self stackIndexList scrollToIndex: 1 ]
]

{ #category : #updating }
GtPharoStackElement >> updateStackIndexListTo: aContext [
	| selected |
	self stackIndexList selectedItemDo: [ :context | selected := context ].
	selected ~~ aContext
		ifTrue: [ (self stackIndexList scrollToItemSuchThat: [ :each | each == aContext ])
				then: [ :v | 
					self stackIndexList
						inUIProcessDo: [ | index |
							index := self stackIndexList items indexOf: aContext.
							index > 0 ifTrue: [ self stackIndexList selectOne: index ] ] ] ]
]

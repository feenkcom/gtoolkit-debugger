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
	^ GtPharoStackIndexStencil contextMethodText: aContext
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
GtPharoStackElement >> actOnCoderInFocusFor: aContextCoderViewModel [
	"Is sent when a coder view model receives focus.
	It is an entrance point for updating all UI elements except the context coders list itself"
	| aFocusedContext |
	super actOnCoderInFocusFor: aContextCoderViewModel.
	aFocusedContext := aContextCoderViewModel context.
	self updateStackIndexListTo: aFocusedContext.
	self updateReceiversIndexTo: aFocusedContext
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
	| indexList |
	indexList := GtPharoStackIndexStencil new asElement.
	indexList
		addAptitude: BrGlamorousWithHorizontalResizerAptitude new beRight;
		background: self theme default navigationBackground;
		matchParent.
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
	
	self debuggerElementDo: [ :aDebuggerElement | aDebuggerElement session filters: filters ]
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
	stackPane addChild: stackFramesList as: #expandableFrames.
	self addChild: stackPane
]

{ #category : #accessing }
GtPharoStackElement >> onReceiverIndexSelectionChanged [
	"Is executed in a UI process when selection in the receiver list changes.
	When that happens we should update the selected context in the coders list"
	
	receiversIndex
		selectedEntityDo: [ :value :index | self selectCoderForContext: value object ]
]

{ #category : #accessing }
GtPharoStackElement >> onStackChanged [
	super onStackChanged.
	
	self updateIndexes
]

{ #category : #accessing }
GtPharoStackElement >> onStackIndexSelectionChanged [
	"Is executed in a UI process when selection in the index list changes.
	When that happens we should update the selected context in the coders list"
	
	self stackIndexList
		selectedItemDo: [ :context :index | self selectCoderForContext: context ]
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

{ #category : #updating }
GtPharoStackElement >> shouldJumpOverCoverViewModel: eachCoder [
	^ eachCoder coder context method hasPragmaNamed: #debuggerCompleteToSender
]

{ #category : #accessing }
GtPharoStackElement >> stackIndexList [
	^ stackIndex
]

{ #category : #updating }
GtPharoStackElement >> updateForSession: aDebuggingSession [
	super updateForSession: aDebuggingSession.
	
	self updateIndexes
]

{ #category : #updating }
GtPharoStackElement >> updateIndexes [
	self updateReceiversIndex.
	self updateStackIndex
]

{ #category : #updating }
GtPharoStackElement >> updateReceiversIndex [
	self
		enqueueTask: (BlTaskAction new
				action: [
					receiversIndex
						stream: (self class receiversStreamFor: stackModel)
						executionConfiguration: GtMoldableDebugger defaultFutureExecutionConfiguration ])
]

{ #category : #updating }
GtPharoStackElement >> updateReceiversIndexTo: aContext [	
	"Must be sent from a UI process"
	| alreadySelectedContext |

	receiversIndex selectedEntityDo: [ :each | alreadySelectedContext := each object ].
	alreadySelectedContext == aContext
		ifTrue: [ ^ self ].

	1
		to: receiversIndex viewModel entityCount
		do: [ :i | 
			(receiversIndex viewModel entityAt: i)
				ifNotNil: [ :each | 
					(each isItem and: [ each object == aContext ])
						ifTrue: [ receiversIndex selectOne: i ] ] ]
]

{ #category : #updating }
GtPharoStackElement >> updateStackIndex [
	self
		enqueueTask: (BlTaskAction new
				action: [
					self stackIndexList
						stream: stackModel contextStream
						executionConfiguration: GtMoldableDebugger defaultFutureExecutionConfiguration.
					self stackIndexList scrollToIndex: 1 ])
]

{ #category : #updating }
GtPharoStackElement >> updateStackIndexListTo: aContext [
	"Must be sent from a UI process"
	| alreadySelectedContext |

	self stackIndexList selectedItemDo: [ :context | alreadySelectedContext := context ].
	alreadySelectedContext == aContext
		ifTrue: [ ^ self ].

	self stackIndexList
		itemSuchThat: [ :each | each == aContext ]
		ifFound:  [ :anIndex |
			self stackIndexList
				scrollToIndex: anIndex;
				selectOne: anIndex ]
]

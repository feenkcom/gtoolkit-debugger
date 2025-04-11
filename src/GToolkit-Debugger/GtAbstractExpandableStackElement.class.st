Class {
	#name : #GtAbstractExpandableStackElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable + TGtPhlowToolDetailAdjustable',
	#classTraits : 'TBrLayoutResizable classTrait + TGtPhlowToolDetailAdjustable classTrait',
	#instVars : [
		'selectedCoderUIModel',
		'annotationsEnabled',
		'stackModel'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #callbacks }
GtAbstractExpandableStackElement >> actOnCoderInFocusFor: aContextCoderUIModel [
	selectedCoderUIModel := aContextCoderUIModel.
	self debuggerElementDo: [ :aDebuggerElement |
		aDebuggerElement actOnSelectedContextChangedFor: aContextCoderUIModel coder context ]
]

{ #category : #testing }
GtAbstractExpandableStackElement >> areAnnotationsEnabled [
	^ annotationsEnabled ifNil: [ false ]
]

{ #category : #'building elements' }
GtAbstractExpandableStackElement >> buildStackFramesList [
	^ BrSimpleList new
		matchParent;
		itemType: [ :itemTypeFactory :eachCoderUIModel | eachCoderUIModel coder elementClass ];
		itemId: [ :eachCoderUIModel | eachCoderUIModel coder id ];
		itemStencil: [ :anElementClass | 
			| coderElement |
			coderElement := anElementClass new.
			coderElement
				when: BlFocusInEvent
				do: [ :anEvent | 
					anEvent currentTarget coderViewModel ifNotNil: [ 
						self actOnCoderInFocusFor: anEvent currentTarget coderViewModel ] ].
			coderElement ];
		itemDataBinder: [ :eachCoderElement :eachCoderUIModel :eachIndex |
			GtDebuggerStackElementBindCoderViewModelSignal new
				coderElement: eachCoderElement;
				oldCoderViewModel: (eachCoderElement hasTextualCoderViewModel
					ifTrue: [ eachCoderElement coderViewModel ]
					ifFalse: [ nil ]);
				newCoderViewModel: eachCoderUIModel;
				coderIndex: eachIndex;
				emit.

			eachCoderElement id: (GtExpandableContextMethodCoderId indexed: eachIndex).
			eachCoderElement coderViewModel: eachCoderUIModel ];
		"the list is initialized with an empty stream to reuse the same stream items provider"
		stream: AsyncEmptyStream new
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> createStackModelOnSession: aDebuggingSession [
	^ GtDebuggerPharoStackModel onSession: aDebuggingSession
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> cursorInterval [
	| cursors |
	selectedCoderUIModel ifNil: [ ^ 1 to: 0 ].
	cursors := selectedCoderUIModel cursors.
	cursors isEmpty ifTrue: [ ^ 1 to: 0 ].
	^ cursors first position to: cursors first position
]

{ #category : #'accessing elements' }
GtAbstractExpandableStackElement >> debuggerElementDo: aBlock [	
	self
		allParentsDetect: [:echParent |
			echParent userData
				at: #debuggerContainer
				ifPresent: [ :aContainerName | aContainerName = #debuggerElement ]
				ifAbsent: [ false ] ]
		ifFound: aBlock
		ifNone: [  ]
]

{ #category : #actions }
GtAbstractExpandableStackElement >> disableVariableAnnotations [
	stackModel hideVariableValueAnnotations
]

{ #category : #actions }
GtAbstractExpandableStackElement >> enableVariableAnnotations [
	stackModel showVariableValueAnnotations
]

{ #category : #initialization }
GtAbstractExpandableStackElement >> initialize [
	super initialize.
	self matchParent.
	
	self beFocusable.
	
	self initializeStackList.
]

{ #category : #initialization }
GtAbstractExpandableStackElement >> initializeStackList [
	| stackFramesList |
	stackFramesList := self buildStackFramesList.
	stackFramesList padding: (BlInsets all: 10).
	self addChild: stackFramesList as: #expandableFrames
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> initializeStackModelFor: aDebuggingSession [
	stackModel := self createStackModelOnSession: aDebuggingSession.
	stackModel announcer weak
		when: GtDebuggerStackChanged
			send: #onStackChanged
			to: self;
		when: GtCoderRefreshStackAnnouncement
			send: #updateDebugger
			to: self
]

{ #category : #'private - updating' }
GtAbstractExpandableStackElement >> onStackChanged [
	GtDebuggerStackElementOnStackChangedSignal emit.

	self openFirstNonFilteredContextFrom: stackModel coderViewModelStream
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> openFirstNonFilteredContextFrom: aStream [
	| anItemsProvider aPreloadPromise |
	anItemsProvider := BrStreamItemsProvider new.
	anItemsProvider stream: aStream.
	anItemsProvider executionConfiguration: GtMoldableDebugger defaultFutureExecutionConfiguration.
	aPreloadPromise := anItemsProvider
			itemSuchThat: [ :eachCoder | (self shouldJumpOverCoverViewModel: eachCoder) not ]
			do: [ :anIndex :isSynchronous | 
				| anAction |
				anAction := [ 
					| wantsToScroll |
					self stackFramesList itemsProvider: anItemsProvider.
					wantsToScroll := stackModel currentContextMethodIndicator 
						ifNotNil: [ :anIndicator | anIndicator wantsToScroll ]
						ifNil: [ true ].
					(anIndex > 0 and: [ wantsToScroll ]) ifTrue: [ 
						self stackFramesList scrollToIndex: anIndex offset: 0 ].
					self selectCoderUIModel: (anItemsProvider itemAt: anIndex) ].

				isSynchronous
					ifTrue: anAction
					ifFalse: [ self enqueueTask: (BlTaskAction new action: anAction) ] ].

	(GtDebuggerStackElementFirstNonFilteredContextPreloadSignal new
		promise: aPreloadPromise) emit.

	self enqueueTask: (BlPromiseTask new promise: aPreloadPromise)
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> selectCoderForContext: aContext [
	| anItemsProvider aPreloadPromise |
	
	self selectedContext = aContext
		ifTrue: [ ^ self selectCoderUIModel: selectedCoderUIModel ].
	
	anItemsProvider := self stackFramesList itemsProvider.
	aPreloadPromise := anItemsProvider
		preloadUntilFoundSuchThat: [ :eachCoder | eachCoder coder context = aContext ].	
	aPreloadPromise := aPreloadPromise then: [ :anIndex |
		anItemsProvider bufferLoadingPromise then: [ anIndex ] ].
	
	aPreloadPromise := aPreloadPromise
		then: [ :anIndex |
			anIndex > 0
				ifTrue: [
				self inUIProcessDo: [
					self stackFramesList scrollToIndex: anIndex offset: 0.
					self selectCoderUIModel: (anItemsProvider itemAt: anIndex) ] ] ]
		otherwise: [ :anError | anError debug ].
		
	self enqueueTask: (BlPromiseTask new promise: aPreloadPromise)
]

{ #category : #actions }
GtAbstractExpandableStackElement >> selectCoderUIModel: aContextCoderUIModel [
	"Must be called from a UI process"
	selectedCoderUIModel
		ifNotNil: [ :aPreviousSelectedCoderUIModel |
			"Only unfocus if the new selected coder is different"
			(aPreviousSelectedCoderUIModel ~~ aContextCoderUIModel)
				ifTrue: [
					self requestFocus.
					aPreviousSelectedCoderUIModel focused: false ] ].

	selectedCoderUIModel := aContextCoderUIModel.

	selectedCoderUIModel expanded: true.
	selectedCoderUIModel focused
		ifFalse: [ selectedCoderUIModel focused: true ]
		ifTrue: [ 
			"We do not give the focus in case the coder view model has the focus.
			Instead we notify the debugger that the current coder was selected without changing the focus"
			self debuggerElementDo: [ :aDebuggerElement |
				aDebuggerElement actOnSelectedContextChangedWithoutFocusChangeFor: selectedCoderUIModel coder context ] ].
	
	"Update the source code as some actions (for example save)
	can change the compiled method stored in the context."
	selectedCoderUIModel coder updateSourceFromContext.
	
	"Update the selection based on the new PC"
	selectedCoderUIModel updateProgramCounterRange
]

{ #category : #actions }
GtAbstractExpandableStackElement >> selectContext: aContext [
	self selectCoderForContext: aContext
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> selectedCoder [
	^ selectedCoderUIModel ifNotNil: [ selectedCoderUIModel coder ]
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> selectedContext [
	^ self selectedCoder ifNotNil: [ :coder | coder context ]
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> shouldJumpOverCoverViewModel: eachCoder [
	^ false
]

{ #category : #'accessing elements' }
GtAbstractExpandableStackElement >> stackFramesList [
	^ self childNamed: #expandableFrames
]

{ #category : #'private - updating' }
GtAbstractExpandableStackElement >> updateContent [
	GtDebuggerStackElementOnUpdateSessionSignal emit.
	
	self debuggerElementDo: [ :aDebuggerElement | self updateForSession: aDebuggerElement session ]
]

{ #category : #'private - updating' }
GtAbstractExpandableStackElement >> updateDebugger [
	GtDebuggerStackElementOnUpdateDebuggerSignal emit.
	
	self debuggerElementDo: [ :aDebuggerElement | aDebuggerElement updateContents ]
]

{ #category : #'private - updating' }
GtAbstractExpandableStackElement >> updateExistingStackModelFor: aDebuggingSession [ 
	stackModel setCurrentContext: aDebuggingSession context
]

{ #category : #'private - updating' }
GtAbstractExpandableStackElement >> updateForSession: aDebuggingSession [
	"Debugging session changed, update the context stack list.
	Possible update reasons are:
	 - an executed debug action"

	GtDebuggerStackElementOnUpdateSessionSignal new 
		debuggingSession: aDebuggingSession;
		emit.

	stackModel
		ifNil: [ self initializeStackModelFor: aDebuggingSession ]
		ifNotNil: [ self updateExistingStackModelFor: aDebuggingSession ].

	self openFirstNonFilteredContextFrom: stackModel coderViewModelStream
]

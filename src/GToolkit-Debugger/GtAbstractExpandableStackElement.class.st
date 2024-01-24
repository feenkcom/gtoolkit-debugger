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

			eachCoderElement coderViewModel: eachCoderUIModel ];
		items: OrderedCollection new
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
	self initializeStackList.
]

{ #category : #initialization }
GtAbstractExpandableStackElement >> initializeStackList [
	| stackFramesList |
	stackFramesList := self buildStackFramesList.
	stackFramesList padding: (BlInsets all: 10).
	stackFramesList items: OrderedCollection new.
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
			to: self.

	self onStackChanged
]

{ #category : #'private - updating' }
GtAbstractExpandableStackElement >> onStackChanged [
	GtDebuggerStackElementOnStackChangedSignal emit.

	self
		inUIProcessDo: [
			self stackFramesList stream: stackModel coderViewModelStream.
			self stackFramesList scrollToIndex: 1 ]
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> openFirstNonFilteredContextFrom: stream [
	(stream next
		then: [ :item | 
			item isSome
				ifTrue: [ (item value coder context method hasPragmaNamed: #debuggerCompleteToSender)
						ifTrue: [ self openFirstNonFilteredContextFrom: stream ]
						ifFalse: [ self enqueueTask: [ self selectCoderUIModel: item value ] asBlTask ] ] ])
		await
]

{ #category : #actions }
GtAbstractExpandableStackElement >> selectCoderUIModel: aContextCoderUIModel [
	selectedCoderUIModel
		ifNotNil: [ :aPreviousSelectedCoderUIModel |
			aPreviousSelectedCoderUIModel focused: false ].
	selectedCoderUIModel := aContextCoderUIModel.

	selectedCoderUIModel expanded: true.
	selectedCoderUIModel focused: true.
	
	"Update the content as some actions (for example save)
	can change the compiled method stored in the context."
	selectedCoderUIModel coder updateSourceFromContext.
	
	"Update the selection based on the new PC"
	self
		enqueueTask: (BlTaskAction new action: [ selectedCoderUIModel updateProgramCounterRange ])
]

{ #category : #actions }
GtAbstractExpandableStackElement >> selectContext: aContext [
	self selectedContext = aContext
		ifTrue: [ self selectCoderUIModel: selectedCoderUIModel ]
		ifFalse: [ 
			self stackFramesList
				scrollToItemSuchThat: [ :aCoderViewModel | 
					aCoderViewModel coder context = aContext
						ifTrue: [ 
							self selectCoderUIModel: aCoderViewModel.
							true ]
						ifFalse: [ false ] ] ]
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> selectedCoder [
	^ selectedCoderUIModel ifNotNil: [ selectedCoderUIModel coder ]
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> selectedContext [
	^ self selectedCoder ifNotNil: [ :coder | coder context ]
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
	
	self debuggerElementDo: [ :aDebuggerElement | aDebuggerElement debuggerElement updateContents ]
]

{ #category : #'private - updating' }
GtAbstractExpandableStackElement >> updateForSession: aDebuggingSession [
	GtDebuggerStackElementOnUpdateSessionSignal emit.

	stackModel
		ifNil: [ self initializeStackModelFor: aDebuggingSession ]
		ifNotNil: [ stackModel updateBasedOnCurentSession ].
	self openFirstNonFilteredContextFrom: stackModel coderViewModelStream
]

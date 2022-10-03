Class {
	#name : #GtAbstractExpandableStackElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'selectedCoderUIModel',
		'annotationsEnabled',
		'stackModel'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #callbacks }
GtAbstractExpandableStackElement >> actOnCoderInFocusFor: aContextCoderUIModel [
	selectedCoderUIModel := aContextCoderUIModel.
	self debuggerElement actOnSelectedContextChangedFor: aContextCoderUIModel coder context.
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
					anEvent currentTarget coderViewModel
						ifNotNil: [ self actOnCoderInFocusFor: anEvent currentTarget coderViewModel ] ].
			coderElement ];
		itemDataBinder: [ :eachCoderElement :eachCoderUIModel | eachCoderElement coderViewModel: eachCoderUIModel ];
		items: OrderedCollection new
]

{ #category : #private }
GtAbstractExpandableStackElement >> coderUIModelsToDisplayFrom: aSession preservingContexts: currenCodersUIModels [
	| methodCoderUIModels context firstContext newCoderUIModels |
	
	methodCoderUIModels := currenCodersUIModels reject: [ :eachUIModel | eachUIModel coder isDead ].
	firstContext := methodCoderUIModels isEmpty
		ifTrue: [ nil ]
		ifFalse: [ methodCoderUIModels first coder context ].
	
	context := aSession interruptedContext.
	newCoderUIModels := OrderedCollection new.
	[ context notNil and: [ 
			context ~~ firstContext  ] ]
		whileTrue: [ 
			| newCoder |
			newCoder := self createCoderFor: context in: aSession.
			newCoderUIModels add: newCoder asCoderViewModel.
			context := context sender ].
		
	"For the moment look only for a new on:do: context that does not have a coder. 
	Those contexts can be added by a Step Through action. This is mostly a hack.
	A better solution would be to iterate over the stack and determine if there are
	new contexts at any point in the stack. "
	(context notNil and: [ context sender notNil and: [ 
		 "The next context should be BlockClosure>>#on:do:"
		(context sender method = (BlockClosure>>#on:do:)) and: [
			"There should be no coder for the context: either we just have a coder 
			or the coder after firstContext is for another context "
			  methodCoderUIModels size = 1 or: [ methodCoderUIModels second coder context ~~ context sender ] ] ] ]) ifTrue: [ 
		
		| newCoder |
		"Insert a new coder after the first context for the new context."	
		newCoder := self createCoderFor: context sender in: aSession.
		methodCoderUIModels 
			add: newCoder asCoderViewModel
			afterIndex: 1 ].
	
	methodCoderUIModels addAllFirst: newCoderUIModels.
	^ methodCoderUIModels
]

{ #category : #private }
GtAbstractExpandableStackElement >> createCoderFor: aContext in: aSession [
	| coder |
	coder := GtPharoMethodContextCoder forContext: aContext session: aSession.
	coder announcer weak when: GtCoderRefreshStackAnnouncement send: #updateDebugger to: self.
	coder announcer weak when: DebugActionExecuted send: #updateDebugger to: self.
	^ coder
]

{ #category : #'accessing elements' }
GtAbstractExpandableStackElement >> debuggerElement [
	| currentElement |
	currentElement := self.
	[ currentElement hasParent ] whileTrue: [ 
		| containerName |
		currentElement := 	currentElement parent.
		containerName := currentElement userData at: #debuggerContainer ifAbsent: [ nil ].
		containerName = #debuggerElement ifTrue: [ 
			^ currentElement ] ].
	^ nil
]

{ #category : #actions }
GtAbstractExpandableStackElement >> disableVariableAnnotations [
	annotationsEnabled := false.
	self stackFramesList items do: [ :aCoderUIModel |
		self todo: #FIXME.
		"aCoderUIModel coder addOns removeStylerOfType: GtCoderContextVariableValueStyler."
		aCoderUIModel coder requestUpdateAddOns ].
	self updateContent
]

{ #category : #actions }
GtAbstractExpandableStackElement >> enableVariableAnnotations [
	annotationsEnabled := true.
	self stackFramesList items do: [ :aCoderUIModel |
		aCoderUIModel coder requestUpdateAddOns ].
	self updateContent.
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
	stackModel := GtPharoStackModel onSession: aDebuggingSession.
	stackModel announcer weak
		when: GtDebuggerStackChanged
			send: #onStackChanged
			to: self;
		when: GtCoderRefreshStackAnnouncement
			send: #updateDebugger
			to: self.

	self onStackChanged
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> onStackChanged [
	self
		inUIProcessDo: [ self stackFramesList stream: stackModel coderViewModelStream.
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
		ifNotNil: [ :aPreviousSelectedCoderUIModel | aPreviousSelectedCoderUIModel focused: false ].
	selectedCoderUIModel := aContextCoderUIModel.

	self
		enqueueTask: (BlTaskAction new action: [ selectedCoderUIModel focused: true ]).
	selectedCoderUIModel expanded: true.
	
	"Update the content as some actions (for example save)
	can change the compiled method stored in the context."
	selectedCoderUIModel coder updateSourceFromContext.
	
	"Update the selection based on the new PC"
	self
		enqueueTask: (BlTaskAction new action: [ selectedCoderUIModel updateProgramCounterRange ])
]

{ #category : #actions }
GtAbstractExpandableStackElement >> selectContext: aContext [
	self selectedContext == aContext
		ifTrue: [ self selectCoderUIModel: selectedCoderUIModel ]
		ifFalse: [ self stackFramesList
				scrollToItemSuchThat: [ :each | 
					each coder context = aContext
						ifTrue: [ self selectCoderUIModel: each.
							true ]
						ifFalse: [ false ] ] ]
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> selectedCoder [
	^ selectedCoderUIModel coder
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> selectedContext [
	selectedCoderUIModel isNil ifTrue: [ ^ nil ].
	^ selectedCoderUIModel coder context
]

{ #category : #'accessing elements' }
GtAbstractExpandableStackElement >> stackFramesList [
	^ self childNamed: #expandableFrames
]

{ #category : #updating }
GtAbstractExpandableStackElement >> updateContent [
	self updateForSession: self debuggerElement session
]

{ #category : #updating }
GtAbstractExpandableStackElement >> updateDebugger [
	self debuggerElement updateContents
]

{ #category : #accessing }
GtAbstractExpandableStackElement >> updateForSession: aDebuggingSession [
	stackModel
		ifNil: [ self initializeStackModelFor: aDebuggingSession ]
		ifNotNil: [ stackModel updateContent ].
	self openFirstNonFilteredContextFrom: stackModel coderViewModelStream
]

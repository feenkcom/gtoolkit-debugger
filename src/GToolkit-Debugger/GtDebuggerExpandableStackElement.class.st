Class {
	#name : #GtDebuggerExpandableStackElement,
	#superclass : #BlElement,
	#instVars : [
		'selectedCoderUIModel',
		'annotationsEnabled'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #callbacks }
GtDebuggerExpandableStackElement >> actOnCoderInFocusFor: aContextCoderUIModel [
	selectedCoderUIModel := aContextCoderUIModel.
	self debuggerElement actOnSelectedContextChangedFor: aContextCoderUIModel coder context.
]

{ #category : #testing }
GtDebuggerExpandableStackElement >> areAnnotationsEnabled [
	^ annotationsEnabled ifNil: [ false ]
]

{ #category : #'building elements' }
GtDebuggerExpandableStackElement >> buildStackFramesList [
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
				anEvent currentTarget coderUIModel ifNotNil: [
					self actOnCoderInFocusFor: anEvent currentTarget coderUIModel ] ].
			coderElement ];
		itemDataBinder: [ :eachCoderElement :eachCoderUIModel | eachCoderElement coderUIModel: eachCoderUIModel ].

	^ stackFramesList
]

{ #category : #private }
GtDebuggerExpandableStackElement >> coderUIModelsToDisplayFrom: aSession preservingContexts: currenCodersUIModels [
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
			newCoderUIModels add: newCoder asCoderUIModel.
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
			add: newCoder asCoderUIModel
			afterIndex: 1 ].
	
	methodCoderUIModels addAllFirst: newCoderUIModels.
	^ methodCoderUIModels
]

{ #category : #private }
GtDebuggerExpandableStackElement >> createCoderFor: aContext in: aSession [
	| coder |
	coder := GtPharoMethodContextCoder forContext: aContext session: aSession.
	coder announcer weak when: GtCoderRefreshStackAnnouncement send: #updateDebugger to: self.
	coder announcer weak when: DebugActionExecuted send: #updateDebugger to: self.
	^ coder
]

{ #category : #'accessing elements' }
GtDebuggerExpandableStackElement >> debuggerElement [
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
GtDebuggerExpandableStackElement >> disableVariableAnnotations [
	annotationsEnabled := false.
	self stackFramesList items do: [ :aCoderUIModel |
		self todo: #FIXME.
		"aCoderUIModel coder addOns removeStylerOfType: GtCoderContextVariableValueStyler."
		aCoderUIModel coder requestUpdateAddOns ].
	self updateContent
]

{ #category : #actions }
GtDebuggerExpandableStackElement >> enableVariableAnnotations [
	annotationsEnabled := true.
	self stackFramesList items do: [ :aCoderUIModel |
		aCoderUIModel coder requestUpdateAddOns ].
	self updateContent.
]

{ #category : #initialization }
GtDebuggerExpandableStackElement >> initialize [
	super initialize.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	self initializeStackList.
]

{ #category : #initialization }
GtDebuggerExpandableStackElement >> initializeStackList [
	| stackFramesList |
	stackFramesList := self buildStackFramesList.
	stackFramesList items: OrderedCollection new.
	self addChild: stackFramesList
]

{ #category : #actions }
GtDebuggerExpandableStackElement >> selectCoderUIModel: aContextCoderUIModel [
	selectedCoderUIModel ifNotNil: [ :aPreviousSelectedCoderUIModel |
		aPreviousSelectedCoderUIModel focused: false ].
	selectedCoderUIModel := aContextCoderUIModel.
	
	selectedCoderUIModel focused: true.
	selectedCoderUIModel expanded: true.
	
	"Update the content as some actions (for example save)
	can change the compiled method stored in the context."
	selectedCoderUIModel coder updateSourceFromContext.
	
	"Update the selection based on the new PC"
	selectedCoderUIModel updateProgramCounterRange.
]

{ #category : #actions }
GtDebuggerExpandableStackElement >> selectContext: aContext [
	self stackFramesList items 
		detect:  [ :eachCoderUIModel | eachCoderUIModel coder context = aContext ]
		ifFound: [ :eachCoderUIModel | self selectCoderUIModel: eachCoderUIModel ] 
		ifNone: [  ]
]

{ #category : #accessing }
GtDebuggerExpandableStackElement >> selectedCoder [
	^ selectedCoderUIModel coder
]

{ #category : #'accessing elements' }
GtDebuggerExpandableStackElement >> stackFramesList [
	^ self children first.
]

{ #category : #updating }
GtDebuggerExpandableStackElement >> updateContent [
	self updateForSession: self debuggerElement session
]

{ #category : #updating }
GtDebuggerExpandableStackElement >> updateDebugger [
	self debuggerElement updateContents
]

{ #category : #updating }
GtDebuggerExpandableStackElement >> updateForSession: aDebuggingSession [
	self stackFramesList
		items: (self
			coderUIModelsToDisplayFrom: aDebuggingSession
			preservingContexts: self stackFramesList items asOrderedCollection).
	
	self stackFramesList items
		ifNotEmpty: [ :methodCoderUIModels | 
			self selectCoderUIModel: methodCoderUIModels first.
			self stackFramesList scrollToItem: methodCoderUIModels first ]
]

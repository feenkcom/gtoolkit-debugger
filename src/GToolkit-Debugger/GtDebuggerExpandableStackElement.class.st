Class {
	#name : #GtDebuggerExpandableStackElement,
	#superclass : #BlElement,
	#instVars : [
		'selectedCoder',
		'annotationsEnabled'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #callbacks }
GtDebuggerExpandableStackElement >> actOnCoderInFocusFor: aCoder [
	selectedCoder := aCoder.
	self debuggerElement actOnSelectedContextChangedFor: aCoder context.
]

{ #category : #testing }
GtDebuggerExpandableStackElement >> areAnnotationsEnabled [
	^ annotationsEnabled ifNil: [ false ]
]

{ #category : #'building elements' }
GtDebuggerExpandableStackElement >> buildElementForCoder: aMethodCoder [
	| element |
	element := aMethodCoder asElement.
	element when: BlFocusInEvent do: [ :event | 
		self actOnCoderInFocusFor: aMethodCoder ].
	aMethodCoder == selectedCoder ifTrue: [
		element requestFocus ].
	^ element
]

{ #category : #'building elements' }
GtDebuggerExpandableStackElement >> buildStackFramesList [
	| stackFramesList |
	stackFramesList := BrSimpleList new.
	stackFramesList stencil: [ :each | self buildElementForCoder: each ].
	stackFramesList padding: (BlInsets all: 10).
	stackFramesList
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	^ stackFramesList
]

{ #category : #private }
GtDebuggerExpandableStackElement >> codersToDisplayFrom: aSession preservingContexts: currenCoders [
	| methodCoders context firstContext coder newCoders |
	
	methodCoders := currenCoders reject: [ :each | each isDead ].
	firstContext := methodCoders isEmpty
		ifTrue: [ nil ]
		ifFalse: [ methodCoders first context ].
	
	context := aSession interruptedContext.
	newCoders := OrderedCollection new.
	[ context notNil and: [ context ~~ firstContext ] ]
		whileTrue: [ 
			coder := GtMethodContextCoder forContext: context session: aSession.
			self areAnnotationsEnabled ifTrue: [
				coder addOns addStyler: (GtCoderContextVariableValueStyler new methodCoder: coder) ].
			coder announcer weak when: GtCoderRefreshStackAnnouncement send: #updateContent to: self.
			newCoders add: coder.
			context := context sender ].
	methodCoders addAllFirst: newCoders.
	^ methodCoders
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
	self stackFramesList items do: [ :aCoder |
		aCoder addOns removeStylerOfType: GtCoderContextVariableValueStyler ].
	self updateContent
]

{ #category : #actions }
GtDebuggerExpandableStackElement >> enableVariableAnnotations [
	annotationsEnabled := true.
	self stackFramesList items do: [ :aCoder |
		aCoder addOns addStyler: (GtCoderContextVariableValueStyler new methodCoder: aCoder) ].
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
	stackFramesList display: OrderedCollection new.
	self addChild: stackFramesList.
]

{ #category : #accessing }
GtDebuggerExpandableStackElement >> selectedCoder [
	^ selectedCoder
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
GtDebuggerExpandableStackElement >> updateForSession: aDebuggingSession [
	self stackFramesList display: (self 
		codersToDisplayFrom: aDebuggingSession
		preservingContexts: self stackFramesList items).
	self stackFramesList items ifNotEmpty: [ :methodCoders |
		selectedCoder := methodCoders first.
		selectedCoder expanded: true.
		selectedCoder isBuilt ifTrue: [
			"Rebuild the top context as both the code and the selection might have changed."
			selectedCoder buildSource ] ]
]

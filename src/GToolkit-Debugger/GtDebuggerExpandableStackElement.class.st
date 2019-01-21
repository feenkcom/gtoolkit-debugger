Class {
	#name : #GtDebuggerExpandableStackElement,
	#superclass : #BlElement,
	#instVars : [
		'selectedCoder'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #initialization }
GtDebuggerExpandableStackElement >> actOnCoderInFocusFor: aCoder [
	
	selectedCoder := aCoder.
	self debuggerElement actOnSelectedContextChangedFor: aCoder context.
]

{ #category : #'building elements' }
GtDebuggerExpandableStackElement >> buildElementForCoder: aMethodCoder [
	| element |
	element := aMethodCoder asElement.
	element when: BlFocusInEvent do: [ :event | 
		self actOnCoderInFocusFor: aMethodCoder ].
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

{ #category : #updating }
GtDebuggerExpandableStackElement >> codersToDisplayFrom: aSession preservingContexts: currenCoders [
	| methodCoders context firstContext coder newCoders |
	
	methodCoders := currenCoders reject: [ :each | each isDead ].
	firstContext := methodCoders isEmpty
		ifTrue: [ nil ]
		ifFalse: [ methodCoders first context ].
	
	context := aSession process suspendedContext.
	newCoders := OrderedCollection new.
	[ context notNil and: [ context ~~ firstContext ] ]
		whileTrue: [ 
			coder := GtMethodContextCoder forContext: context session: aSession.
			"coder announcer weak when: GtCoderRefreshStackAnnouncement send: #updateCoders to: aDebugger."
			newCoders add: coder.
			context := context sender ].
	methodCoders addAllFirst: newCoders.
	^ methodCoders
]

{ #category : #'accessing - elements' }
GtDebuggerExpandableStackElement >> debuggerElement [
	^ self parent parent parent parent
]

{ #category : #ui }
GtDebuggerExpandableStackElement >> focusedCoder: aCoder in: anElement [
	"activeCoder := aCoder.
	self updateVariables"
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
	stackFramesList display: (OrderedCollection new).
	self addChild: stackFramesList.
]

{ #category : #accessing }
GtDebuggerExpandableStackElement >> selectedCoder [
	^ selectedCoder
]

{ #category : #'accessing - elements' }
GtDebuggerExpandableStackElement >> stackFramesList [
	^ self children first.
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
			selectedCoder updateSelection ] ]
]

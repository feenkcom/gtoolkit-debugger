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

{ #category : #'accessing - elements' }
GtDebuggerExpandableStackElement >> debuggerElement [
	^ self parent parent
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
	stackFramesList 
		when: BrSelectionChanged
		do: [ :anEvent | self halt. ].
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
	self stackFramesList display: (aDebuggingSession stack 
		collect: [ :aContext | 
			| coder |
			coder := GtMethodContextCoder forContext: aContext session: aDebuggingSession.
			coder announcer weak when: GtCoderRefreshStackAnnouncement send: #updateCoders to: self.
			coder ]).
	"stackElement selectOne: 1"
]

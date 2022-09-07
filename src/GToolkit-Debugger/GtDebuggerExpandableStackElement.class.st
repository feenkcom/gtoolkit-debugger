Class {
	#name : #GtDebuggerExpandableStackElement,
	#superclass : #GtAbstractExpandableStackElement,
	#category : #'GToolkit-Debugger'
}

{ #category : #accessing }
GtDebuggerExpandableStackElement >> initialize [
	super initialize.
	self initializeStackList
]

{ #category : #initialization }
GtDebuggerExpandableStackElement >> initializeStackList [
	| stackFramesList |
	stackFramesList := self buildStackFramesList.
	stackFramesList items: OrderedCollection new.
	self addChild: stackFramesList
]

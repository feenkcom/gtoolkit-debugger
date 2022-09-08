Class {
	#name : #GtDebuggerExpandableStackElement,
	#superclass : #GtAbstractExpandableStackElement,
	#category : #'GToolkit-Debugger'
}

{ #category : #accessing }
GtDebuggerExpandableStackElement >> initializeStackList [
	| stackFramesList |
	stackFramesList := self buildStackFramesList.
	stackFramesList items: OrderedCollection new.
	self addChild: stackFramesList
]

{ #category : #accessing }
GtDebuggerExpandableStackElement >> onStackChanged [
	self
		enqueueTask: [ self stackFramesList stream: stackModel coderViewModelStream.
			self stackFramesList scrollToIndex: 1 ] asBlTask
]

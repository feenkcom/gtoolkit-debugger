Class {
	#name : #GtDebuggerExpandableStackElement,
	#superclass : #GtAbstractExpandableStackElement,
	#category : #'GToolkit-Debugger'
}

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

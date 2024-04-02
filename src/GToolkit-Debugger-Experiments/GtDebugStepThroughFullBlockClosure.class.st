Class {
	#name : #GtDebugStepThroughFullBlockClosure,
	#superclass : #FullBlockClosure,
	#type : #variable,
	#category : #'GToolkit-Debugger-Experiments'
}

{ #category : #accessing }
GtDebugStepThroughFullBlockClosure >> value [
	self primitiveChangeClassTo: FullBlockClosure new.
	
	GtDebugStepThroughFromBlockClosureRequest signal.
	
	^ super value
]

{ #category : #accessing }
GtDebugStepThroughFullBlockClosure >> value: firstArg [
	self primitiveChangeClassTo: FullBlockClosure new.
	
	GtDebugStepThroughFromBlockClosureRequest signal.
	
	^ super value: firstArg
]

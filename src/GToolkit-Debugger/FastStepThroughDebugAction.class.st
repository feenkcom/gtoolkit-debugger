Class {
	#name : #FastStepThroughDebugAction,
	#superclass : #StepThroughDebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #registration }
FastStepThroughDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	<gt2StackDebuggingAction>
	^(self forDebugger: aDebugger)
]

{ #category : #testing }
FastStepThroughDebugAction >> appliesToDebugger: aDebugger [

	^ aDebugger debugSession class fastStepThroughMode
]

{ #category : #'as yet unclassified' }
FastStepThroughDebugAction >> defaultLabel [

	^ 'Step through (fast)'
]

{ #category : #'as yet unclassified' }
FastStepThroughDebugAction >> executeAction [

	self session fastStepThrough: self currentContext
]

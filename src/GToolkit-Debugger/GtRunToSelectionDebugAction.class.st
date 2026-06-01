Class {
	#name : #GtRunToSelectionDebugAction,
	#superclass : #RunToSelectionDebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #accessing }
GtRunToSelectionDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	<gt2StackDebuggingAction>
	^ (self forDebugger: aDebugger)
		icon: BrGlamorousVectorIcons tohere;
		yourself
]

{ #category : #testing }
GtRunToSelectionDebugAction >> canBeDirectlyRun [
	^ self debugger debugSession  isInterruptedContextSteppable
]

{ #category : #accessing }
GtRunToSelectionDebugAction >> executeAction [
	self session
		runToSelection: self selectionInterval
		inContext: self currentContext
]

{ #category : #testing }
GtRunToSelectionDebugAction >> isAllowedToEnforceExecution [
	^ true
]

{ #category : #accessing }
GtRunToSelectionDebugAction >> selectionInterval [
	^ debugger cursorInterval
]

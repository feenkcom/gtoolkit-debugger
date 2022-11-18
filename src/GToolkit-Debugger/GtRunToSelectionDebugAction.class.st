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
		icon: BrGlamorousIcons tohere;
		yourself
]

{ #category : #accessing }
GtRunToSelectionDebugAction >> executeAction [
	self session
		runToSelection: self selectionInterval
		inContext: self currentContext
]

{ #category : #accessing }
GtRunToSelectionDebugAction >> selectionInterval [
	^ debugger cursorInterval
]

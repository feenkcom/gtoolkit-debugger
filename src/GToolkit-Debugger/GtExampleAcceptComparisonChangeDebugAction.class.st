Class {
	#name : #GtExampleAcceptComparisonChangeDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtExampleAcceptComparisonChangeDebugAction class >> defaultIcon [
	^  BrGlamorousVectorIcons accept
]

{ #category : #accessing }
GtExampleAcceptComparisonChangeDebugAction class >> exampleComparisonDebuggingActionFor: aDebugger [
	<gtExampleComparisonDebuggingAction>
	
	^ self forDebugger: aDebugger
]

{ #category : #accessing }
GtExampleAcceptComparisonChangeDebugAction >> defaultLabel [
	^ 'Accept new version'
]

{ #category : #accessing }
GtExampleAcceptComparisonChangeDebugAction >> executeAction [
	self inform: 'Executed'.
	
	"self debugger 
		acceptCurrentTest;
		resumeAndCloseDebugger"
]

{ #category : #accessing }
GtExampleAcceptComparisonChangeDebugAction >> initialize [
	super initialize.
	
	"No need to update the debgger as it will anyway be closed."
	self needsUpdate: false
]

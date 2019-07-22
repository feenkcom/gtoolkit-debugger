Class {
	#name : #GtEmergencyDebugger,
	#superclass : #Object,
	#instVars : [
		'errorMessage'
	],
	#category : #'GToolkit-Debugger-Emergency'
}

{ #category : #launching }
GtEmergencyDebugger class >> askForEmergencyEvaluatorOrExitWithText: aText [
	self new 
		errorMessage: aText;
		openInNativeWindow.
]

{ #category : #accessing }
GtEmergencyDebugger >> errorMessage [
	^ errorMessage
]

{ #category : #accessing }
GtEmergencyDebugger >> errorMessage: aText [
	errorMessage := aText
]

{ #category : #opening }
GtEmergencyDebugger >> openInNativeWindow [
	| aSpace |
	aSpace := BlSpace new.
	aSpace addChild: (GtEmergencyDebuggerMesssageElement new 
		messageText: self errorMessage).
	aSpace show
]

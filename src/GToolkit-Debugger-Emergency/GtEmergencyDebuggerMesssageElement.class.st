Class {
	#name : #GtEmergencyDebuggerMesssageElement,
	#superclass : #BlElement,
	#instVars : [
		'messageText'
	],
	#category : #'GToolkit-Debugger-Emergency'
}

{ #category : #drawing }
GtEmergencyDebuggerMesssageElement >> drawOnSpartaCanvas: aCanvas [
	| font |
	font := aCanvas font
		size: 14;
		build.
	
	messageText lines withIndexDo: [ :aLine :anIndex |
		aCanvas text
			baseline: 5@(anIndex*15+10);
			string: aLine;
			font: font;
			draw ].
]

{ #category : #initialize }
GtEmergencyDebuggerMesssageElement >> initialize [
	super initialize.
	self 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c vertical exact: 500.
			c horizontal exact: 500 ]
]

{ #category : #accessing }
GtEmergencyDebuggerMesssageElement >> messageText: aText [
	messageText := aText.
]

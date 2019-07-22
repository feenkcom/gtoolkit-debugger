Class {
	#name : #GtEmergencyDebuggerMesssageElement,
	#superclass : #BlElement,
	#instVars : [
		'messageText'
	],
	#category : #'GToolkit-Debugger-Emergency'
}

{ #category : #initialize }
GtEmergencyDebuggerMesssageElement >> initialize [
	super initialize.
	self 
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c vertical matchParent.
			c horizontal matchParent ]
]

{ #category : #accessing }
GtEmergencyDebuggerMesssageElement >> messageText: aText [
	messageText := aText.
	self removeChildren.
	aText linesDo: [ :aLine |
		self addChild: (BlTextElement new text: aLine asRopedText) ]
		
]

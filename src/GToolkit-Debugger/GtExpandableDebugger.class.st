Class {
	#name : #GtExpandableDebugger,
	#superclass : #GtStackDebuggerElement,
	#instVars : [
		'bytecodesPane',
		'bytecodesListElement',
		'expandablePane'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #accessing }
GtExpandableDebugger class >> sessionClass [

	^ GTBytecodeDebuggerSession
]

{ #category : #initialization }
GtExpandableDebugger >> initializePanes [
	expandablePane := BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ].
	detailsPane := self buildPaneElement.	
	self addChildren: {expandablePane . "detailsPane"}.
]

{ #category : #initialization }
GtExpandableDebugger >> updateStackPane [
	expandablePane 
		removeChildren;
		addChild: (GtProcessCoder forDebugSession: self session) asElement
]

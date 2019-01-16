Class {
	#name : #GtExpandableDebugger,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'stackPane',
		'detailsPane'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #updating }
GtExpandableDebugger >> actOnDebugSessionChanged [
	
]

{ #category : #'building widgets' }
GtExpandableDebugger >> buildPaneElement [
	^ BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ]
]

{ #category : #initialization }
GtExpandableDebugger >> initialize [
	super initialize.
	self
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].		
	
	self initializePanes.	
]

{ #category : #initialization }
GtExpandableDebugger >> initializePanes [
	stackPane := self buildPaneElement
		layout: BlLinearLayout horizontal.	
	detailsPane := self buildPaneElement
		layout: BlFrameLayout new;
		border: (BlBorder paint: (Color lightGray alpha: 0.5)).
	
	self addChild: stackPane as: #stackPane.
	self addChild: detailsPane as: #detailsPane.
]

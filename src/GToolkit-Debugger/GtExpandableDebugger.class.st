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
	| stackElement |
	stackElement := self buildStackElement.
	stackElement display: (self session stack collect: [ :aContext | 
		GtMethodContextCoder forContext: aContext session: self session ]).
	self stackPane 
		removeChildren;
		addChild: stackElement as: #stackElement
]

{ #category : #ui }
GtExpandableDebugger >> buildElementForCoder: aMethodCoder [
	^ aMethodCoder asElement
]

{ #category : #'building widgets' }
GtExpandableDebugger >> buildPaneElement [
	^ BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ]
]

{ #category : #'building widgets' }
GtExpandableDebugger >> buildStackElement [
	| stackElement |
	stackElement := BrSimpleList new.
	stackElement stencil: [ :each | self buildElementForCoder: each ].
	stackElement padding: (BlInsets all: 10).
	stackElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	^ stackElement
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

{ #category : #'accessing - elements' }
GtExpandableDebugger >> stackPane [
	^ self childNamed: #stackPane
]

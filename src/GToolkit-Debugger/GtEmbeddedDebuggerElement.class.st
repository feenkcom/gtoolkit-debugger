Class {
	#name : #GtEmbeddedDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggingSession',
		'signaledException'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #opening }
GtEmbeddedDebuggerElement class >> openOn: debugSession dueTo: exception embeddedIn: sourceCoder [
	| selectionInterval |
	selectionInterval := sourceCoder selectedSourceInterval.
	sourceCoder sourceEditor text
		attributes: {(GtPlaygroundEvaluatedCodeHighlightedAttribute new 
			paint: Color red)}
		from: selectionInterval first
		to: selectionInterval last.
	sourceCoder sourceEditor text
		attributes: {(GtEmbeddedDebuggerAttribute new 
			signaledException: exception;
			debugSession: debugSession)}
		from: selectionInterval first
		to: selectionInterval last .
	sourceCoder sourceEditor
		invalidateAll;
		updateAll
]

{ #category : #'tools registry' }
GtEmbeddedDebuggerElement class >> register [
	self registerToolsOn: Smalltalk tools.
]

{ #category : #'tools registry' }
GtEmbeddedDebuggerElement class >> registerToolsOn: registry [
	registry register: self as: #gtEmbeddableDebugger.
]

{ #category : #callbacks }
GtEmbeddedDebuggerElement >> actOnBrowserClosing: ann [
	self session ifNotNil: [ :aSession | 
		aSession terminate.
		debuggingSession := nil ]
]

{ #category : #accessing }
GtEmbeddedDebuggerElement >> actOnDebugSessionChanged [
	| textElement text debugButton |
	self layout: (BlGridLayout horizontal cellSpacing: 3).
	
	text := self signaledException printString asRopedText.
	textElement := BlTextElement new text: text.
	textElement background: (Color red muchLighter alpha: 0.8).
	textElement constraintsDo: [ :c |
		c horizontal fitContent.
		c vertical fitContent.
		c padding: (BlInsets all: 3).
		c margin: (BlInsets all: 3) ].
	debugButton := BrButton new.
	debugButton look: BrGlamorousButtonExteriorRectangularLook + BrGlamorousButtonLabelLook.
	debugButton label: 'Debug'.
	debugButton action: [ self inform: 'it works' ].
	self 
		removeChildren;
		addChild: textElement;
		addChild: debugButton.
	self constraintsDo: [ :c | 
		c vertical fitContent.
		c horizontal fitContent ].
]

{ #category : #'hooks - children' }
GtEmbeddedDebuggerElement >> onAddedToSceneGraph [ 
	self space when: BlSpaceClosedEvent do: [ :event | self actOnBrowserClosing: event ]
]

{ #category : #accessing }
GtEmbeddedDebuggerElement >> session [
	^ debuggingSession
]

{ #category : #accessing }
GtEmbeddedDebuggerElement >> session: aDebugSession [
	debuggingSession := aDebugSession.
	self actOnDebugSessionChanged.
]

{ #category : #accessing }
GtEmbeddedDebuggerElement >> signaledException [
	^ signaledException
]

{ #category : #accessing }
GtEmbeddedDebuggerElement >> signaledException: anException [
	signaledException := anException
]

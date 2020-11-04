Class {
	#name : #GtEmbeddedDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggingSession',
		'signaledException',
		'isTerminationDisabled'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #opening }
GtEmbeddedDebuggerElement class >> openOn: debugSession dueTo: exception embeddedIn: sourceCoder withSelection: aSelection [
	| selectionInterval sourceText |
	sourceText := sourceCoder sourceCode sourceText.
	selectionInterval := aSelection isEmpty
		ifFalse: [ aSelection from + 1 to: aSelection to ] 
		ifTrue: [ 1 to: sourceText size ].
	
	sourceText
		clearAttributes: [ :each | 
			{GtPlaygroundEvaluatedCodeHighlightedAttribute.
			GtEmbeddedDebuggerAttribute} anySatisfy: [ :cls | each isKindOf: cls ] ].
	sourceText
		attributes: {(GtPlaygroundEvaluatedCodeHighlightedAttribute new 
			paint: Color red)}
		from: selectionInterval first
		to: selectionInterval last.
	sourceText
		attributes: {(GtEmbeddedDebuggerAttribute new 
			signaledException: exception;
			debugSession: debugSession)}
		from: selectionInterval first
		to: selectionInterval last
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
	debugButton look: BrGlamorousButtonWithLabelLook.
	debugButton label: 'Debug'.
	debugButton action: [ 
		self switchToSystemDebugger.
		self removeFromParent ].
	self 
		removeChildren;
		addChild: textElement;
		addChild: debugButton.
	self constraintsDo: [ :c | 
		c vertical fitContent.
		c horizontal fitContent ].
]

{ #category : #actions }
GtEmbeddedDebuggerElement >> detachSession [
	debuggingSession := nil 
]

{ #category : #accessing }
GtEmbeddedDebuggerElement >> disableTermination [
	isTerminationDisabled := true
]

{ #category : #accessing }
GtEmbeddedDebuggerElement >> enableTermination [
	isTerminationDisabled := false
]

{ #category : #initialize }
GtEmbeddedDebuggerElement >> initialize [
	super initialize.
	self enableTermination
]

{ #category : #'hooks - children' }
GtEmbeddedDebuggerElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	self terminateSession
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

{ #category : #actions }
GtEmbeddedDebuggerElement >> switchToSystemDebugger [
	"Directly open the registered debugger on the given session."
	| currentSession newDebugger |
	
	currentSession := self session.
	self detachSession.
	newDebugger:= Smalltalk tools debugger 
		openOn: currentSession withFullView: true andNotification: nil.
	^ newDebugger
]

{ #category : #callbacks }
GtEmbeddedDebuggerElement >> terminateSession [ 
	isTerminationDisabled ifFalse: [ 
		self session ifNotNil: [ :aSession | 
			self detachSession.
			aSession terminate ]]
]

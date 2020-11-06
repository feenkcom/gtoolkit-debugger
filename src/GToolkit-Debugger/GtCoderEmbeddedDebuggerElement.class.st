Class {
	#name : #GtCoderEmbeddedDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggingSession',
		'signaledException',
		'isTerminationDisabled'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #opening }
GtCoderEmbeddedDebuggerElement class >> openOn: debugSession dueTo: exception embeddedIn: sourceCoder withSelection: aSelection [
	| selectionInterval sourceText sharedDebugSession |
	sharedDebugSession := GtSharedDebugSession new session: debugSession.
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
			debugSession: sharedDebugSession)}
		from: selectionInterval first
		to: selectionInterval last
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> actOnDebugSessionChanged [
	| label text |
	self layout: (BlGridLayout horizontal cellSpacing: 3).
	
	text := self signaledException printString asRopedText.
	label := BrButton new
		look: BrGlamorousLabelLook new;
		beSmall;
		label: text;
		background: BrGlamorousColors errorBackgroundColor;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
		padding: (BlInsets top: 0 right: 3 bottom: 0 left: 3);
		margin: (BlInsets all: 0);
		action: [ self debug ];
		fitContent.
	self 
		removeChildren;
		addChild: label;
		constraintsDo: [ :c | 
			c padding: (BlInsets top: -3 right: 3 bottom: 0 left: 3).
			c vertical fitContent.
			c horizontal fitContent ].
]

{ #category : #actions }
GtCoderEmbeddedDebuggerElement >> debug [
	self switchToSystemDebugger.
	self removeFromParent.
]

{ #category : #actions }
GtCoderEmbeddedDebuggerElement >> detachSession [
	debuggingSession := nil 
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> disableTermination [
	isTerminationDisabled := true
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> enableTermination [
	isTerminationDisabled := false
]

{ #category : #initialize }
GtCoderEmbeddedDebuggerElement >> initialize [
	super initialize.
	self enableTermination
]

{ #category : #'hooks - children' }
GtCoderEmbeddedDebuggerElement >> onRemovedFromSceneGraph [
	super onRemovedFromSceneGraph.
	"self terminateSession"
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> session [
	^ debuggingSession
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> session: aDebugSession [
	debuggingSession := aDebugSession.
	self subscribeToSession.
	self actOnDebugSessionChanged.

]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> signaledException [
	^ signaledException
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> signaledException: anException [
	signaledException := anException
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> subscribeToSession [
	self session
			when: GtSharedDebugSessionDebuggedAnnouncement
			send: #removeFromParent
			to: self; 
			when: GtSharedDebugSessionTerminatedAnnouncement
			send: #removeFromParent
			to: self
]

{ #category : #actions }
GtCoderEmbeddedDebuggerElement >> switchToSystemDebugger [
	"Directly open the registered debugger on the given session."
	| currentSession |
	
	currentSession := self session.
	self detachSession.
	^ currentSession debug
]

{ #category : #actions }
GtCoderEmbeddedDebuggerElement >> terminate [
	self terminateSession.
	self removeFromParent.
]

{ #category : #callbacks }
GtCoderEmbeddedDebuggerElement >> terminateSession [ 
	isTerminationDisabled ifFalse: [ 
		self session ifNotNil: [ :aSession | 
			self detachSession.
			aSession terminate ]]
]

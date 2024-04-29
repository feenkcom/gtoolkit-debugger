Class {
	#name : #GtCoderEmbeddedDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggingSession',
		'signaledException',
		'isTerminationDisabled'
	],
	#classVars : [
		'IsEmbeddedDebuggerEnabled'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #configuration }
GtCoderEmbeddedDebuggerElement class >> disableEmbeddedDebugger [
	IsEmbeddedDebuggerEnabled := false
]

{ #category : #configuration }
GtCoderEmbeddedDebuggerElement class >> enableEmbeddedDebugger [
	IsEmbeddedDebuggerEnabled := true
]

{ #category : #testing }
GtCoderEmbeddedDebuggerElement class >> isEmbeddedDebuggerEnabled [
	^ IsEmbeddedDebuggerEnabled ifNil: [ IsEmbeddedDebuggerEnabled := false ]
]

{ #category : #opening }
GtCoderEmbeddedDebuggerElement class >> openOn: debugSession dueTo: anException embeddedIn: sourceCoder withSourceString: aSourceString withSourceInterval: aSourceInterval [
	| isHandled |
	isHandled := false.
	self isEmbeddedDebuggerEnabled ifTrue: [ 
		isHandled := sourceCoder
			notifyShowDebuggerRequest: debugSession
			dueTo: anException
			sourceString: aSourceString
			sourceInterval: aSourceInterval ].

	isHandled
		ifFalse: [ ^ Smalltalk tools debugger openOn: debugSession withFullView: true ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> actOnDebugSessionChanged [
	| label text |
	self layout: (BlGridLayout horizontal cellSpacing: 3).
	text := self signaledException printString asRopedText.
	label := BrButton new
		aptitude: BrGlamorousLabelAptitude new;
		beSmallSize;
		label: text;
		background: self theme status errorBackgroundColor;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
		padding:
			(BlInsets
				top: 0
				right: 3
				bottom: 0
				left: 3);
		margin: (BlInsets all: 0);
		action: [ self debug ];
		fitContent.
	self
		removeChildren;
		addChild: label;
		constraintsDo: [ :c | 
			c
				padding:
					(BlInsets
						top: -3
						right: 3
						bottom: 0
						left: 3).
			c vertical fitContent.
			c horizontal fitContent ]
]

{ #category : #actions }
GtCoderEmbeddedDebuggerElement >> debug [
	self switchToSystemDebugger.
	BlTaskAction
		enqueueElement: self
		action: [ self visibility: BlVisibility hidden ]
]

{ #category : #actions }
GtCoderEmbeddedDebuggerElement >> detachSession [
	self unsubscribeFromSession.
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

{ #category : #'private - announcement handling' }
GtCoderEmbeddedDebuggerElement >> onDebugSessionDebuggedAnnouncement: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ self visibility: BlVisibility hidden ]
]

{ #category : #'private - announcement handling' }
GtCoderEmbeddedDebuggerElement >> onDebugSessionTerminatedAnnouncement: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ self visibility: BlVisibility hidden ]
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
	self session weak
			when: GtSharedDebugSessionDebuggedAnnouncement
			send: #onDebugSessionDebuggedAnnouncement:
			to: self; 
			when: GtSharedDebugSessionTerminatedAnnouncement
			send: #onDebugSessionTerminatedAnnouncement:
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
	BlTaskAction enqueueElement: self action: [ self removeFromParent ]
]

{ #category : #callbacks }
GtCoderEmbeddedDebuggerElement >> terminateSession [ 
	isTerminationDisabled ifFalse: [ 
		self session ifNotNil: [ :aSession | 
			self detachSession.
			aSession terminate ]]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> unsubscribeFromSession [
	self session unsubscribe: self
]

Class {
	#name : #GtCoderEmbeddedDebuggerElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'debuggingSession',
		'signaledException',
		'isTerminationDisabled',
		'buttonElement'
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
GtCoderEmbeddedDebuggerElement class >> openOn: debugSession dueTo: anException embeddedIn: aCoderRequesterObject withSourceString: aSourceString withSourceInterval: aSourceInterval [
	| isHandled |
	isHandled := false.
	self isEmbeddedDebuggerEnabled ifTrue: [ 
		isHandled := aCoderRequesterObject
			notifyShowDebuggerRequest: debugSession
			dueTo: anException
			sourceString: aSourceString
			sourceInterval: aSourceInterval ].

	isHandled
		ifFalse: [ ^ Smalltalk tools debugger openOn: debugSession withFullView: true ]
]

{ #category : #actions }
GtCoderEmbeddedDebuggerElement >> debug [
	BlTaskAction
		enqueueElement: self
		action: [ 
			self switchToSystemDebugger.
			self visibility: BlVisibility hidden ]
]

{ #category : #initialize }
GtCoderEmbeddedDebuggerElement >> defaultLayout [
	^ BlLinearLayout horizontal
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

{ #category : #initialization }
GtCoderEmbeddedDebuggerElement >> initialize [
	super initialize.
	self enableTermination.

	self initializeButtonElement.
	self addChild: buttonElement as: #button.
	self
		padding: (BlInsets
				top: 0
				right: 3
				bottom: 0
				left: 3).
	self hFitContentLimited.
	self vFitContent
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerElement >> initializeButtonElement [
	buttonElement := BrButton new
			aptitude: BrGlamorousLabelAptitude new;
			beSmallSize;
			label: '';
			background: self theme status errorBackgroundColor;
			geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
			padding: (BlInsets
					top: 0
					right: 3
					bottom: 0
					left: 3);
			margin: (BlInsets all: 0);
			action: [ :aButtonElement :aButtonModel :anEvent | self onButtonAction: anEvent ];
			vFitContent;
			hFitContentLimited
]

{ #category : #'private - event handling' }
GtCoderEmbeddedDebuggerElement >> onButtonAction: anEvent [
	self debug
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

{ #category : #'private - hooks' }
GtCoderEmbeddedDebuggerElement >> onSessionChanged [
	self updateButtonElement
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> session [
	<return: #GtSharedDebugSession>
	^ debuggingSession
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> session: aDebugSession [
	debuggingSession := aDebugSession.
	self subscribeToSession.
	self onSessionChanged
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

{ #category : #'private - updating' }
GtCoderEmbeddedDebuggerElement >> updateButtonElement [
	| aText |
	aText := self signaledException printString asRopedText.
	buttonElement label: aText
]

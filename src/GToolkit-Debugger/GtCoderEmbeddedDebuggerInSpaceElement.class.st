Class {
	#name : #GtCoderEmbeddedDebuggerInSpaceElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'buttonElement',
		'evaluationStatus',
		'weakDebuggerSpace',
		'coderViewModel'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #accessing }
GtCoderEmbeddedDebuggerInSpaceElement >> coderViewModel [
	^ coderViewModel
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerInSpaceElement >> coderViewModel: anObject [
	coderViewModel := anObject
]

{ #category : #private }
GtCoderEmbeddedDebuggerInSpaceElement >> createWeakDebuggerSpace [
	| aSpace |
	aSpace := self findSpace.
	aSpace ifNil: [ ^ nil ].
	aSpace
		when: BlSpaceClosedEvent
		do: [ :anEvent | self onSpaceClosedEvent: anEvent ].
	^ weakDebuggerSpace := aSpace asWeakReference
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerInSpaceElement >> debugSession [
	^ evaluationStatus debugSession
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerInSpaceElement >> debuggerSpace [
	<return: #BlSpace or: nil>
	weakDebuggerSpace ifNil: [ self createWeakDebuggerSpace ].
	^ weakDebuggerSpace ifNotNil: [ :aWeak | aWeak at: 1 ]
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerInSpaceElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerInSpaceElement >> evaluationStatus [
	<return: #GtCoderDebugSessionInSpaceEvaluationStatus>
	^ evaluationStatus
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerInSpaceElement >> evaluationStatus: anEvaluationStatus [
	evaluationStatus := anEvaluationStatus
]

{ #category : #private }
GtCoderEmbeddedDebuggerInSpaceElement >> findSpace [
	evaluationStatus ifNil: [ ^ nil ].
	^ GtCoderDebuggerSpaceFinder new
		debugSession: self debugSession;
		find;
		space
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerInSpaceElement >> initialize [
	super initialize.
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
GtCoderEmbeddedDebuggerInSpaceElement >> initializeButtonElement [
	buttonElement := BrButton new
			aptitude: BrGlamorousLabelAptitude new;
			beSmallSize;
			label: 'unknown debugger';
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

{ #category : #'hooks - children' }
GtCoderEmbeddedDebuggerInSpaceElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	self updateElement
]

{ #category : #'private - event handling' }
GtCoderEmbeddedDebuggerInSpaceElement >> onButtonAction: anEvent [
	self spaceToFront
]

{ #category : #private }
GtCoderEmbeddedDebuggerInSpaceElement >> onSpaceClosedEvent: anEvent [
	self updateElement
]

{ #category : #'private - event handling' }
GtCoderEmbeddedDebuggerInSpaceElement >> spaceToFront [
	self debuggerSpace ifNotNil: [ :theSpace | theSpace toFront ]
]

{ #category : #'private - updating' }
GtCoderEmbeddedDebuggerInSpaceElement >> updateElement [
	| aText aSpace |
	aSpace := self debuggerSpace.
	aText := aSpace
			ifNotNil: [ aSpace isOpened
					ifTrue: [ 'Locate debugger' asRopedText ]
					ifFalse: [ 'Debugger was closed' asRopedText ] ]
			ifNil: [ 'Debugger was closed' asRopedText ].
	buttonElement label: aText.

	(aSpace isNil or: [ aSpace isOpened not ])
		ifTrue: [ buttonElement visibility: BlVisibility hidden.
			coderViewModel evaluationStatus: GtCoderNoEvaluationStatus default ]
]

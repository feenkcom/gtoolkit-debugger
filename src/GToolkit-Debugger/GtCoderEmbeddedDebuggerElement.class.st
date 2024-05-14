Class {
	#name : #GtCoderEmbeddedDebuggerElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'buttonElement',
		'debuggerViewModel',
		'buttonDropdownAptitude'
	],
	#classVars : [
		'IsEmbeddedDebuggerEnabled'
	],
	#category : #'GToolkit-Debugger-Embedded - Elements'
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
GtCoderEmbeddedDebuggerElement class >> openOn: debugSession dueTo: anException embeddedIn: aCoderRequesterObject withSourceString: aSourceString withSourceInterval: aSourceInterval evaluationInfo: anEvaluationInfo [
	| isHandled |
	isHandled := false.
	self isEmbeddedDebuggerEnabled
		ifTrue: [ isHandled := aCoderRequesterObject
					notifyShowDebuggerRequest: debugSession
					dueTo: anException
					sourceString: aSourceString
					sourceInterval: aSourceInterval
					evaluationInfo: anEvaluationInfo ].

	isHandled
		ifFalse: [ ^ Smalltalk tools debugger openOn: debugSession withFullView: true ]
]

{ #category : #'private - updating' }
GtCoderEmbeddedDebuggerElement >> buttonText [
	self
		debuggerViewModelDo: [ :aViewModel | 
			^ (aViewModel signaledException printStringLimitedTo: 72) asRopedText ].
	^ 'detached debugger' asRopedText
]

{ #category : #actions }
GtCoderEmbeddedDebuggerElement >> debug [
	BlTaskAction
		enqueueElement: self
		action: [ 
			self switchToSystemDebugger.
			self visibility: BlVisibility hidden ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> debuggerViewModel [
	^ debuggerViewModel
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> debuggerViewModel: aViewModel [
	debuggerViewModel = aViewModel ifTrue: [ ^ self ].
	debuggerViewModel ifNotNil: [ self unsubscribeFromDebuggerViewModel ].
	debuggerViewModel := aViewModel.
	self subscribeToDebuggerViewModel.
	self onDebuggerViewModelChanged.
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> debuggerViewModelDo: aBlock [
	^ self debuggerViewModel ifNotNil: aBlock
]

{ #category : #initialize }
GtCoderEmbeddedDebuggerElement >> defaultLayout [
	^ BlLinearLayout horizontal
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerElement >> initialize [
	super initialize.
	self initializeButtonElement.
	self initializeButtonElementDropdown.
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
	buttonElement := self newBasicButtonElement.
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerElement >> initializeButtonElementDropdown [
	| anElement |
	buttonDropdownAptitude := BrGlamorousWithDropdownAptitude
			handle: [ self newButtonDropdownHandleElement ]
			content: [ anElement := self newButtonDropdownContentElement ]
			aptitudeDo: [ :anAnchoredAptitude |
				anAnchoredAptitude border: (self theme status errorBorderColor).
				anAnchoredAptitude background: self theme status errorBackgroundColor ].
	buttonDropdownAptitude
		preferredExtent: GtCoderEmbeddedDebuggerDropdownConfiguration userExtent;
		doKeepRatio;
		whenResizedDo: [ :anEvent | 
			GtCoderEmbeddedDebuggerDropdownConfiguration userExtent:anElement extent. ].
	buttonElement addAptitude: buttonDropdownAptitude
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerElement >> newBasicButtonElement [
	^ BrButton new
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
		vFitContent;
		hFitContent
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerElement >> newButtonDropdownContentElement [
	| anElement |
	anElement := GtCoderEmbeddedDebuggerDetailsElement new.
	self debuggerViewModelDo: [ :aViewModel | 
		anElement debuggerViewModel: aViewModel
	].
	^ anElement
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerElement >> newButtonDropdownHandleElement [
	| aButton |
	aButton := self newBasicButtonElement.
	aButton label: self buttonText.
	^ aButton
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
GtCoderEmbeddedDebuggerElement >> onDebuggerViewModelChanged [
	self updateButtonElement
]

{ #category : #'hooks - children' }
GtCoderEmbeddedDebuggerElement >> onRemovedFromParent: aParentElement [
	super onRemovedFromParent: aParentElement.
	BlTaskAction enqueueElement: aParentElement action: [ buttonDropdownAptitude hide ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> subscribeToDebuggerViewModel [
	self debuggerViewModel weak
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

	self debuggerViewModelDo: [ :aViewModel | 
		self unsubscribeFromDebuggerViewModel.
		aViewModel switchToSystemDebugger ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerElement >> unsubscribeFromDebuggerViewModel [
	self debuggerViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtCoderEmbeddedDebuggerElement >> updateButtonElement [
	buttonElement label: self buttonText.
	BlTaskAction enqueueElement: self action: [ buttonDropdownAptitude show ]
]

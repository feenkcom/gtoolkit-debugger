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
	^ IsEmbeddedDebuggerEnabled ifNil: [ IsEmbeddedDebuggerEnabled := true ]
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

{ #category : #private }
GtCoderEmbeddedDebuggerElement >> ensureDetailsElement: aChild fitsInAnchoredElement: aParent [
	"Sometime the BrAnchoredElement (aParent) extent is not large enough
	and GtCoderEmbeddedDebuggerDetailsElement (aChild) is not fully visible.
	Particularly, the toolbar may not be accesible. For that reason a new
	aChild extent is computed.
	See https://github.com/feenkcom/gtoolkit/issues/3960"

	| aChildRectangle aParentRectangle outsideRectangles extraHeight aContentRectangle aVisibleRectangle |
	aChildRectangle := aChild bounds inSpace asRectangle.
	aParentRectangle := aParent bounds inSpace asRectangle.
	aContentRectangle := (aParent childNamed: #content) bounds inSpace asRectangle.
	aVisibleRectangle := aParentRectangle intersect: aContentRectangle.
	
	(aVisibleRectangle containsRect: aChildRectangle) ifTrue: [ ^ self ].
	
	outsideRectangles := aChildRectangle areasOutside: aVisibleRectangle.
	extraHeight := outsideRectangles inject: 0 into: [ :aHeight :aRectangle | aHeight + aRectangle height ].
	aChild exact: aChild extent - (0 @ extraHeight)
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerElement >> initialize [
	super initialize.
	self initializeButtonElement.
	self initializeButtonElementDropdown.
	self addChild: buttonElement as: GtCoderEmbeddedDebuggerButtonId.
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
	buttonDropdownAptitude := BrGlamorousWithExplicitDropdownAptitude
			handle: [ self newButtonDropdownHandleElement ]
			content: [ anElement := self newButtonDropdownContentElement.
				anElement addAptitude: (BrGlamorousPopoverResizableAptitude new
					whenResizedDo: [ :anEvent | 
						GtCoderEmbeddedDebuggerDropdownConfiguration userExtent:anElement extent. ]).
				anElement ]
			containerDo: [ :aContainerElement |
				aContainerElement border: (self theme status errorBorderColor).
				aContainerElement background: self theme status errorBackgroundColor ].
	buttonDropdownAptitude
		when: BrDropdownIsVisible do: [ :anEvent | self onDropdownIsVisible: anEvent ];
		when: BrDropdownIsHidden do: [ :anEvent | self onDropdownIsHidden: anEvent ].
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
	
	"See https://github.com/feenkcom/gtoolkit/issues/3960
	I think we can remove this code since we use BrGlamorousWithExplicitDropdownAptitude"
	anElement
		when: BlElementAddedToSceneGraphEvent
		doOnce: [ :anEvent | self onAddedToSceneGraphEvent: anEvent ].
	
	self
		debuggerViewModelDo: [ :aViewModel | anElement debuggerViewModel: aViewModel ].
	^ anElement
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerElement >> newButtonDropdownHandleElement [
	| aButton |
	aButton := self newBasicButtonElement.
	aButton label: self buttonText.
	^ aButton
]

{ #category : #'event handling' }
GtCoderEmbeddedDebuggerElement >> onAddedToSceneGraphEvent: anEvent [
	"See https://github.com/feenkcom/gtoolkit/issues/3960"

	anEvent currentTarget
		allParentsDo: [ :aParent | 
			(aParent isKindOf: BrAnchoredElement)
				ifTrue: [ 
					BlTaskAction
						enqueueElement: anEvent currentTarget
						action: [ 
							self
								ensureDetailsElement: anEvent currentTarget
								fitsInAnchoredElement: aParent ].
					^ self ] ]
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

{ #category : #'event handling' }
GtCoderEmbeddedDebuggerElement >> onDropdownIsHidden: anEvent [ 
	self debuggerViewModelDo: [ :aViewModel | aViewModel isDropdownDisplayed: false ]
]

{ #category : #'event handling' }
GtCoderEmbeddedDebuggerElement >> onDropdownIsVisible: anEvent [
	self debuggerViewModelDo: [ :aViewModel | aViewModel isDropdownDisplayed: true ]
]

{ #category : #'hooks - children' }
GtCoderEmbeddedDebuggerElement >> onRemovedFromParent: aParentElement [
	super onRemovedFromParent: aParentElement.
	buttonDropdownAptitude hide
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
	BlTaskAction 
		enqueueElement: self 
		action: [ buttonDropdownAptitude visible: debuggerViewModel isDropdownDisplayed ]
]

Class {
	#name : #GtCoderEmbeddedDebuggerDetails2Element,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'debuggerViewModel',
		'stackListElement',
		'toolbarElement',
		'debuggingConfiguration'
	],
	#category : #'GToolkit-Debugger-Embedded - Elements'
}

{ #category : #accessing }
GtCoderEmbeddedDebuggerDetails2Element class >> defaultExactSize [
	^ 300 @ 200
]

{ #category : #actions }
GtCoderEmbeddedDebuggerDetails2Element >> debug [
	BlTaskAction
		enqueueElement: self
		action: [
			self switchToSystemDebugger.
			self fireEvent: BrDropdownHideWish new ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDetails2Element >> debugSessionDo: aBlock [
	^ self debuggerViewModelDo: [ :aViewModel | aViewModel debugSessionDo: aBlock ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDetails2Element >> debuggerViewModel [
	<return: #GtCoderEmbeddedDebuggerViewModel>
	^ debuggerViewModel
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDetails2Element >> debuggerViewModel: aViewModel [
	debuggerViewModel = aViewModel ifTrue: [ ^ self ].
	debuggerViewModel ifNotNil: [ self unsubscribeFromDebuggerViewModel ].
	debuggerViewModel := aViewModel.
	self subscribeToDebuggerViewModel.
	self onDebuggerViewModelChanged.
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDetails2Element >> debuggerViewModelDo: aBlock [
	^ self debuggerViewModel ifNotNil: aBlock
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetails2Element >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetails2Element >> initialize [
	super initialize.
	self initializeStackListElement.
	self initializeToolbarElement.
	
	self addChild: stackListElement as: #stack.
	self addChild: toolbarElement as: #toolbar.

	self padding: (BlInsets all: 5).
	self exact: self class defaultExactSize.
	self background: self theme default contentBackgroundColor
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetails2Element >> initializeStackListElement [
	stackListElement := BrFrame new.
	stackListElement
		background: self theme default contentBackgroundColor;
		hMatchParent;
		vMatchParent;
		padding: (BlInsets left: 5 right: 5)
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetails2Element >> initializeStackListElement2 [
	stackListElement := GtPharoStackIndexStencil new asElement.
	stackListElement
		background: self theme default contentBackgroundColor;
		hMatchParent;
		vMatchParent;
		padding: (BlInsets left: 5 right: 5)
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetails2Element >> initializeToolbarElement [
	| aDebugButton aTerminateButton |
	toolbarElement := BrToolbar new
			aptitude: BrGlamorousToolbarAptitude;
			margin: (BlInsets top: 3);
			hFitContentLimited;
			vFitContent.

	aDebugButton := BrButton new
			fitContent;
			aptitude: BrGlamorousButtonWithIconAptitude;
			beTinySize;
			icon: BrGlamorousVectorIcons debug;
			label: 'Debug';
			action: [ self debug ].
			
	aTerminateButton := BrButton new
			fitContent;
			aptitude: BrGlamorousButtonWithIconAptitude;
			beTinySize;
			icon: BrGlamorousVectorIcons stop;
			label: 'Terminate';
			action: [ self terminate ].

	toolbarElement addItem: aDebugButton.
	toolbarElement addItem: aTerminateButton
]

{ #category : #'private - subscriptions' }
GtCoderEmbeddedDebuggerDetails2Element >> onDebugSessionDebuggedAnnouncement: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ self fireEvent: BrDropdownHideWish new ]
]

{ #category : #'private - subscriptions' }
GtCoderEmbeddedDebuggerDetails2Element >> onDebugSessionTerminatedAnnouncement: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ self fireEvent: BrDropdownHideWish new ]
]

{ #category : #'private - hooks' }
GtCoderEmbeddedDebuggerDetails2Element >> onDebuggerViewModelChanged [
	debuggingConfiguration := self debuggerViewModel gtExceptionEmbeddedDebuggerSpecification.
	self updateElement
]

{ #category : #'private - subscriptions' }
GtCoderEmbeddedDebuggerDetails2Element >> subscribeToDebuggerViewModel [
	self debuggerViewModel weak
		when: GtSharedDebugSessionDebuggedAnnouncement
			send: #onDebugSessionDebuggedAnnouncement:
			to: self;
		when: GtSharedDebugSessionTerminatedAnnouncement
			send: #onDebugSessionTerminatedAnnouncement:
			to: self
]

{ #category : #actions }
GtCoderEmbeddedDebuggerDetails2Element >> switchToSystemDebugger [
	"Directly open the registered debugger on the given session."

	self debuggerViewModelDo: [ :aViewModel | 
		self unsubscribeFromDebuggerViewModel.
		aViewModel switchToSystemDebugger ]
]

{ #category : #actions }
GtCoderEmbeddedDebuggerDetails2Element >> terminate [
	BlTaskAction
		enqueueElement: self
		action: [ self
				debuggerViewModelDo: [ :aViewModel | 
					self unsubscribeFromDebuggerViewModel.
					aViewModel terminateDebugSession ].
			self fireEvent: BrDropdownHideWish new ]
]

{ #category : #'private - subscriptions' }
GtCoderEmbeddedDebuggerDetails2Element >> unsubscribeFromDebuggerViewModel [
	self debuggerViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtCoderEmbeddedDebuggerDetails2Element >> updateElement [
	self updateStackListElement
]

{ #category : #'private - updating' }
GtCoderEmbeddedDebuggerDetails2Element >> updateStackListElement [
	| aCompositeView |
	stackListElement removeChildren.
	aCompositeView := GtPhlowView empty composite.
	debuggingConfiguration
		collectTargetDebuggingViewsForDebugger: self
		in: aCompositeView.
	aCompositeView views
		ifEmpty: [ self updateWithEmptyView.
			^ self ].
	aCompositeView views first
		asElementDo: [ :anElement | stackListElement addChild: anElement ]
]

{ #category : #'private - updating' }
GtCoderEmbeddedDebuggerDetails2Element >> updateStackListElement2 [
	self
		debugSessionDo: [ :aDebugSession | 
			aDebugSession interruptedContext
				ifNotNil: [ :anInterruptedContext | 
					anInterruptedContext stack
						ifNotNil: [ :aStack | stackListElement items: (aStack collect: #copy) ] ] ]
]

{ #category : #'private - updating' }
GtCoderEmbeddedDebuggerDetails2Element >> updateWithEmptyView [
	| anElement |
	anElement := BrLabel new
			fitContent;
			aptitude: BrGlamorousLabelAptitude new;
			text: 'Exception without stack';
			constraintsDo: [ :c | 
				c frame horizontal alignCenter.
				c frame vertical alignCenter ].
	stackListElement
		removeChildren;
		addChild: anElement
]

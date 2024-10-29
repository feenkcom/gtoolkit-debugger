Class {
	#name : #GtCoderEmbeddedDebuggerDetailsElement,
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

{ #category : #actions }
GtCoderEmbeddedDebuggerDetailsElement >> debug [
	BlTaskAction
		enqueueElement: self
		action: [
			self switchToSystemDebugger.
			self fireEvent: BrDropdownHideWish new ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDetailsElement >> debuggerViewModel [
	<return: #GtCoderEmbeddedDebuggerViewModel>
	^ debuggerViewModel
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDetailsElement >> debuggerViewModel: aViewModel [
	debuggerViewModel = aViewModel ifTrue: [ ^ self ].
	debuggerViewModel ifNotNil: [ self unsubscribeFromDebuggerViewModel ].
	debuggerViewModel := aViewModel.
	self subscribeToDebuggerViewModel.
	self onDebuggerViewModelChanged.
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDetailsElement >> debuggerViewModelDo: aBlock [
	^ self debuggerViewModel ifNotNil: aBlock
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDetailsElement >> debugSessionDo: aBlock [
	^ self debuggerViewModelDo: [ :aViewModel | aViewModel debugSessionDo: aBlock ]
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetailsElement >> defaultLayout [
	^ BlLinearLayout vertical
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetailsElement >> initialize [
	super initialize.
	self initializeStackListElement.
	self initializeToolbarElement.
	
	self addChild: stackListElement as: #stack.
	self addChild: toolbarElement as: #toolbar.

	self padding: (BlInsets all: 5).
	self exact: GtCoderEmbeddedDebuggerDropdownConfiguration userExtent.
	self background: self theme default contentBackgroundColor
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetailsElement >> initializeStackListElement [
	stackListElement := BrFrame new.
	stackListElement
		background: self theme default contentBackgroundColor;
		hMatchParent;
		vMatchParent.
	stackListElement
		when: BlElementExtentChangedEvent
		do: [ :anEvent | self onContentExtentChanged: anEvent ]
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetailsElement >> initializeToolbarElement [
	| aDebugButton aTerminateButton |
	toolbarElement := BrToolbar new
			aptitude: BrGlamorousToolbarAptitude;
			margin: (BlInsets top: 3);
			hFitContentLimited;
			vFitContent.

	aDebugButton := BrButton new
			id: GtCoderEmbeddedDebuggerDebugButtonId;
			fitContent;
			aptitude: BrGlamorousButtonWithIconAptitude;
			beTinySize;
			icon: BrGlamorousVectorIcons debug;
			label: 'Debug';
			action: [ self debug ].
			
	aTerminateButton := BrButton new
			id: GtCoderEmbeddedDebuggerTerminateButtonId;
			fitContent;
			aptitude: BrGlamorousButtonWithIconAptitude;
			beTinySize;
			icon: BrGlamorousVectorIcons stop;
			label: 'Terminate';
			action: [ self terminate ].

	toolbarElement addItem: aDebugButton.
	toolbarElement addItem: aTerminateButton
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetailsElement >> onContentExtentChanged: anEvent [
	| aPreviewElement |
	aPreviewElement := (stackListElement children at: 1 ifAbsent: [ ^ self ])
			children at: 1 ifAbsent: [ ^ self ].

	aPreviewElement
		exact: (GtCoderEmbeddedDebuggerDropdownConfiguration
				contentExtentForContainerExtent: stackListElement extent)
]

{ #category : #'private - hooks' }
GtCoderEmbeddedDebuggerDetailsElement >> onDebuggerViewModelChanged [
	debuggingConfiguration := self debuggerViewModel gtExceptionEmbeddedDebuggerSpecification.
	self updateElement
]

{ #category : #'private - subscriptions' }
GtCoderEmbeddedDebuggerDetailsElement >> onDebugSessionDebuggedAnnouncement: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ self fireEvent: BrDropdownHideWish new ]
]

{ #category : #'private - subscriptions' }
GtCoderEmbeddedDebuggerDetailsElement >> onDebugSessionTerminatedAnnouncement: anAnnouncement [
	BlTaskAction
		enqueueElement: self
		action: [ self fireEvent: BrDropdownHideWish new ]
]

{ #category : #'private - subscriptions' }
GtCoderEmbeddedDebuggerDetailsElement >> subscribeToDebuggerViewModel [
	self debuggerViewModel weak
		when: GtSharedDebugSessionDebuggedAnnouncement
			send: #onDebugSessionDebuggedAnnouncement:
			to: self;
		when: GtSharedDebugSessionTerminatedAnnouncement
			send: #onDebugSessionTerminatedAnnouncement:
			to: self
]

{ #category : #actions }
GtCoderEmbeddedDebuggerDetailsElement >> switchToSystemDebugger [
	"Directly open the registered debugger on the given session."

	self debuggerViewModelDo: [ :aViewModel | 
		self unsubscribeFromDebuggerViewModel.
		aViewModel switchToSystemDebugger ]
]

{ #category : #actions }
GtCoderEmbeddedDebuggerDetailsElement >> terminate [
	BlTaskAction
		enqueueElement: self
		action: [ self
				debuggerViewModelDo: [ :aViewModel | 
					self unsubscribeFromDebuggerViewModel.
					aViewModel terminateDebugSession ].
			self fireEvent: BrDropdownHideWish new ]
]

{ #category : #'private - subscriptions' }
GtCoderEmbeddedDebuggerDetailsElement >> unsubscribeFromDebuggerViewModel [
	self debuggerViewModel unsubscribe: self
]

{ #category : #'private - updating' }
GtCoderEmbeddedDebuggerDetailsElement >> updateElement [
	self updateStackListElement
]

{ #category : #'private - updating' }
GtCoderEmbeddedDebuggerDetailsElement >> updateStackListElement [
	| aCompositeView |
	stackListElement removeChildren.
	aCompositeView := GtPhlowView empty composite.
	debuggingConfiguration
		collectTargetDebuggingViewsForDebugger: self
		in: aCompositeView.
	aCompositeView views
		ifEmpty: [ self updateWithEmptyView.
			^ self ].
	aCompositeView views do: [ :aView |
		aView ifItHasContent: [ 
			aView asElementDo: [ :anElement | 
				(anElement respondsTo: #exact:)
					ifTrue: [
						anElement exact: GtCoderEmbeddedDebuggerDropdownConfiguration contentExtent ]
					ifFalse: [ 
						anElement size:  GtCoderEmbeddedDebuggerDropdownConfiguration contentExtent ].
				stackListElement 
					addChild: anElement asScalableElement.
				^ self ] ] ]
]

{ #category : #'private - updating' }
GtCoderEmbeddedDebuggerDetailsElement >> updateWithEmptyView [
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

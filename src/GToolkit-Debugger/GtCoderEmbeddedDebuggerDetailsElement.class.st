Class {
	#name : #GtCoderEmbeddedDebuggerDetailsElement,
	#superclass : #BlElement,
	#traits : 'TBrLayoutResizable',
	#classTraits : 'TBrLayoutResizable classTrait',
	#instVars : [
		'debuggerViewModel',
		'stackListElement',
		'toolbarElement'
	],
	#category : #'GToolkit-Debugger-Elements'
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
GtCoderEmbeddedDebuggerDetailsElement >> debugSessionDo: aBlock [
	^ self debuggerViewModelDo: [ :aViewModel | aViewModel debugSessionDo: aBlock ]
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
	self exact: 300 @ 300.
	self background: self theme default contentBackgroundColor
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetailsElement >> initializeStackListElement [
	stackListElement := BrSimpleList new
		hMatchParent;
		vMatchParent;
		padding: (BlInsets left: 5 right: 5);
		itemType: [ :anItemTypeFactory :anItemObject :anItemIndex | DebugSession ];
		itemStencil: [ :anEventElementClass :aListWidget | 
			BrLabel new
				aptitude: (BrGlamorousLabelAptitude new
					glamorousRegularFont;
					glamorousRegularSmallSize);
				hMatchParent;
				vFitContent ];
		itemDataBinder: [ :aLabel :aContext :anItemIndex | 
				aLabel text: (self textForContext: aContext) ]
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

{ #category : #'private - hooks' }
GtCoderEmbeddedDebuggerDetailsElement >> onDebuggerViewModelChanged [
	self updateElement
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

{ #category : #initialization }
GtCoderEmbeddedDebuggerDetailsElement >> textForContext: aContext [
	^ aContext printString
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
	self
		debugSessionDo: [ :aDebugSession | 
			aDebugSession interruptedContext
				ifNotNil: [ :anInterruptedContext | 
					anInterruptedContext stack
						ifNotNil: [ :aStack | stackListElement items: (aStack collect: #copy) ] ] ]
]

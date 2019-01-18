Class {
	#name : #GtExpandableDebugger,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'stackPane',
		'detailsPane'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #updating }
GtExpandableDebugger >> actOnDebugSessionChanged [
	| stackElement  |
	stackElement := self buildStackElement.
	self stackPane 
		removeChildren;
		addChild: stackElement as: #stackElement.
	stackElement updateForSession: self session.
]

{ #category : #updating }
GtExpandableDebugger >> actOnSelectedContextChangedFor: aContext [
	| detailsTabGroupElement |
	detailsTabGroupElement := self buildDetailsElement.
	self detailsPane 
		removeChildren;
		addChild: detailsTabGroupElement as: #detailsElement
]

{ #category : #'building widgets' }
GtExpandableDebugger >> buildContextVariablesElement [
	| contextVariablesElement |
	contextVariablesElement := self buildVariablesListElement.
	contextVariablesElement display: self contextVariables.
	contextVariablesElement userData at: #blocContainer put: #contextVariablesElement.
	^ contextVariablesElement
]

{ #category : #'building widgets' }
GtExpandableDebugger >> buildDetailsElement [
	| tab1 tab2 tabGroup |
	tab1 := BrTabModel new
		add: (BrLabelModel text: 'Variables');
		stencil: [ self buildContextVariablesElement ].
	tab2 := BrTabModel new
		add: (BrLabelModel text: 'Watches');
		stencil: [ self buildWatchVariablesElement ].
	tabGroup := BrTabGroupModel
		with: {tab1. tab2}.
	tabGroup tabs
		do: [ :aTab | 
			BlElement new
				look: BrGlamorousTabLook;
				viewModel: aTab ].
	^ BrTabGroup new
		background: Color white;
		look: BrGlamorousTabGroupLook + BrShadowLook;
		viewModel: tabGroup
]

{ #category : #'building widgets' }
GtExpandableDebugger >> buildPaneElement [
	^ BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ]
]

{ #category : #'building widgets' }
GtExpandableDebugger >> buildStackElement [
	^ GtDebuggerExpandableStackElement new 
]

{ #category : #'building widgets' }
GtExpandableDebugger >> buildVariablesListElement [
	| list |
	list := BrColumnedList new.
	list margin: (BlInsets top: 10).
	list addEventHandler: (GtInspectorListToSelectHandler new transformation: [ :each | each last ]).
	list column
		title: 'Icon';
		stencil: [ :each | 
			| icon |
			icon := [ each last gtInspectorIcon ifNil: [ each last class systemIcon ] ]
				on: Error
				do: [ :error | self iconNamed: #smallWarningIcon ].
			icon asElement
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ].
	list column
		title: 'Variable';
		stencil: [ :each | 
			BrLabel new
				look: (BrGlamorousLabelLook new foreground: Color black);
				text: each first asString;
				hMatchParent;
				vMatchParent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ].
	list column
		title: 'Value';
		stencil: [ :each | 
			BrLabel new
				look: BrGlamorousLabelLook new;
				text: ([ each last gtDisplayString asRopedText ] 
						on: Error, Halt
						do: [ :e | e messageText asRopedText foreground: Color red ]);
				hMatchParent;
				vMatchParent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ].
	^ list
]

{ #category : #'building widgets' }
GtExpandableDebugger >> buildWatchVariablesElement [
	| watchVariablesElement |
	watchVariablesElement := self buildVariablesListElement.
	watchVariablesElement display: {}"self watchVariables".
	^ watchVariablesElement
]

{ #category : #'building widgets' }
GtExpandableDebugger >> contextVariables [
	| vars activeCoder |
	activeCoder := self selectedCoder.
	(activeCoder isNil or: [ activeCoder isDead ])
		ifTrue: [ ^ #() ].
	vars := OrderedCollection new.
	activeCoder tempNamesAndValuesDo: [ :name :value | vars add: {name. 'temporary'. value} ].
	activeCoder instanceVariableNamesAndValuesDo: [ :name :value | vars add: {name. 'instance'. value} ].
	vars sort: [ :a :b | a first < b first ].
	vars addFirst: {'self'. 'self'. activeCoder receiver}.
	activeCoder stackVariableNamesAndValuesDo: [ :name :value | vars add: {name. 'stack'. value} ].
	^ vars
]

{ #category : #'accessing - elements' }
GtExpandableDebugger >> detailsPane [
	^ self childNamed: #detailsPane
]

{ #category : #initialization }
GtExpandableDebugger >> initialize [
	super initialize.
	self
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].		
	
	self initializePanes.	
]

{ #category : #initialization }
GtExpandableDebugger >> initializePanes [
	stackPane := self buildPaneElement
		layout: BlLinearLayout horizontal.
	detailsPane := self buildPaneElement
		layout: BlFrameLayout new;
		padding: (BlInsets all: 20).
	
	self addChild: stackPane as: #stackPane.
	self addChild: detailsPane as: #detailsPane.
]

{ #category : #'accessing context' }
GtExpandableDebugger >> selectedCoder [
	^ self stackElement selectedCoder
]

{ #category : #'accessing context' }
GtExpandableDebugger >> selectedContext [
	^ self selectedCoder context
]

{ #category : #'accessing - elements' }
GtExpandableDebugger >> stackElement [
	^ self stackPane childNamed: #stackElement
]

{ #category : #'accessing - elements' }
GtExpandableDebugger >> stackPane [
	^ self childNamed: #stackPane
]

{ #category : #updating }
GtExpandableDebugger >> updateCoders [
	'TODO'
]

{ #category : #updating }
GtExpandableDebugger >> updateDebugger [
	self updateStackWidget
]

Class {
	#name : #GtExpandableDebuggerElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'stackElement'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #callbacks }
GtExpandableDebuggerElement >> actOnDebugSessionChanged [
	| tabGroupElement cotainerElement |
	cotainerElement := BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	self buildPanesStructureIn: cotainerElement.
	
	tabGroupElement := self buildStackTabGroupForElement: cotainerElement.
	self 
		removeChildren;
		addChild: tabGroupElement.
	self updateStackPane.
]

{ #category : #callbacks }
GtExpandableDebuggerElement >> actOnSelectedContextChangedFor: aContext [
	| detailsTabGroupElement |
	detailsTabGroupElement := self buildDetailsElement.
	self detailsPane 
		removeChildren;
		addChild: detailsTabGroupElement as: #detailsElement
]

{ #category : #'building widgets' }
GtExpandableDebuggerElement >> buildContextVariablesElement [
	| contextVariablesElement |
	contextVariablesElement := self buildVariablesListElement.
	contextVariablesElement display: self contextVariables.
	contextVariablesElement userData at: #blocContainer put: #contextVariablesElement.
	^ contextVariablesElement
]

{ #category : #'building widgets' }
GtExpandableDebuggerElement >> buildDetailsElement [
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
GtExpandableDebuggerElement >> buildPaneElement [
	^ BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ]
]

{ #category : #'building widgets' }
GtExpandableDebuggerElement >> buildPanesStructureIn: aContainer [
	| stackPane detailsPane |
	stackPane := self buildPaneElement
		constraintsDo: [ :c | c linear weight: 2 ];
		layout: BlLinearLayout horizontal.
	detailsPane := self buildPaneElement
		layout: BlFrameLayout new;
		padding: (BlInsets all: 10).
	
	aContainer 
		removeChildren;
		addChild: stackPane as: #stackPane;
		addChild: detailsPane as: #detailsPane.
]

{ #category : #'building widgets' }
GtExpandableDebuggerElement >> buildStackElement [
	| stackElement |
	stackElement := GtDebuggerExpandableStackElement new.
	stackElement userData at: #blocContainer put: #stackElement.
	^ stackElement
]

{ #category : #'building widgets' }
GtExpandableDebuggerElement >> buildStackTabGroupForElement: aStackElement [
	| tab tabGroup |
	tab := BrTab new.
	tab 
		look: BrGlamorousTabLook new invisibleBar;
		label: self session name;
		stencil: (BrValuableStencil from: aStackElement); "aStackElement asStencil"
		padding: (BlInsets top: 15 right: 0 bottom: 15 left: 10);
		actionsStencil: [
			| aToolbar |
			aToolbar := BrToolbar new.
			aToolbar look: BrGlamorousToolbarLook new.
			self buildStackToolbarActions do: [ :anAction |
				aToolbar addItem: anAction ].
			aToolbar ].
	tabGroup := BrTabGroup new.
	tabGroup 
		look: (BrMaterialTabGroupLook new headerBackground: BrGlamorousColors errorBackgroundColor);
		addTab: tab;
		constraintsDo: [ :c | 
			c vertical matchParent. 
			c horizontal matchParent ].
	^ tabGroup
]

{ #category : #'building widgets' }
GtExpandableDebuggerElement >> buildStackToolbarActions [
	<return: #Collection of: #BrButton>	
		
	| buttons toggle |
	buttons := (self actionsForPragmas: self stackDebuggingActionsPragmas) collect: [ :aDebuggingAction | 
		| actionButton |
		actionButton := BrButton new 
			look: BrGlamorousButtonWithIconLook;
			label: aDebuggingAction label; 
			action: [ 
				aDebuggingAction execute.
				aDebuggingAction needsUpdate ifTrue: [
					self updateStackWidget ] ].
			aDebuggingAction icon ifNotNil: [ :anIcon | 
				actionButton icon: aDebuggingAction icon asElement ].
			actionButton ].
		
	toggle := BrToggle new 
		look: BrMaterialToggleBackgroundLook + BrGlamorousButtonWithIconLook;
		icon: BrGlamorousIcons edit asElement;
		when: BrToggleActivatedEvent do: [ :anEvent | 
			self stackElement enableVariableAnnotations ];
		when: BrToggleDeactivatedEvent do: [ :anEvent | 
			self stackElement disableVariableAnnotations ].
	buttons add: toggle.
	^ buttons
]

{ #category : #'building widgets' }
GtExpandableDebuggerElement >> buildVariablesListElement [
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
GtExpandableDebuggerElement >> buildWatchVariablesElement [
	| watchVariablesElement |
	watchVariablesElement := self buildVariablesListElement.
	watchVariablesElement display: {}"self watchVariables".
	^ watchVariablesElement
]

{ #category : #'building widgets' }
GtExpandableDebuggerElement >> contextVariables [
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

{ #category : #'accessing context' }
GtExpandableDebuggerElement >> currentContext [
	^ self selectedContext 
]

{ #category : #'accessing - elements' }
GtExpandableDebuggerElement >> detailsPane [
	^ self childNamed: #detailsPane
]

{ #category : #initialization }
GtExpandableDebuggerElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	self userData at: #debuggerContainer put: #debuggerElement.
]

{ #category : #'accessing context' }
GtExpandableDebuggerElement >> selectedCoder [
	^ self stackElement selectedCoder
]

{ #category : #'accessing context' }
GtExpandableDebuggerElement >> selectedContext [
	^ self selectedCoder context
]

{ #category : #'building actions' }
GtExpandableDebuggerElement >> stackDebuggingActionsPragmas [
	^ #( gt2StackDebuggingAction )
]

{ #category : #'accessing - elements' }
GtExpandableDebuggerElement >> stackElement [
	^ self stackPane childNamed: #stackElement
]

{ #category : #'accessing - elements' }
GtExpandableDebuggerElement >> stackPane [
	^ self childNamed: #stackPane
]

{ #category : #updating }
GtExpandableDebuggerElement >> updateCoders [
	'TODO'
]

{ #category : #updating }
GtExpandableDebuggerElement >> updateDebugger [
	self updateStackWidget
]

{ #category : #updating }
GtExpandableDebuggerElement >> updateStackPane [
	| stackElement |
	stackElement := self buildStackElement.
	self stackPane 
		removeChildren;
		addChild: stackElement.
	self updateStackWidget.
]

{ #category : #updating }
GtExpandableDebuggerElement >> updateStackWidget [
	self stackElement updateForSession: debuggingSession.
]

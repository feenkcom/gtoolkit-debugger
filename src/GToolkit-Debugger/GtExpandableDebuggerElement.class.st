Class {
	#name : #GtExpandableDebuggerElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'stackElement'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #'tools registry' }
GtExpandableDebuggerElement class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry register: self as: #debugger.
	registry registerDebugger: self withRank: 1000.
]

{ #category : #accessing }
GtExpandableDebuggerElement class >> sessionClass [
	^ DebugSession 
]

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
	| tab1 tab2 tab3 tabGroup |
	tab1 := BrTabModel new
		add: (BrLabelModel text: 'Variables');
		stencil: [ self buildContextVariablesElement ].
	tab2 := BrTabModel new
		add: (BrLabelModel text: 'Evaluator');
		stencil: [ self buildEvaluatorElement ].
	tab3 := BrTabModel new
		add: (BrLabelModel text: 'Watches');
		stencil: [ self buildWatchVariablesElement ].
	tabGroup := BrTabGroupModel
		with: {tab1. tab2. tab3}.
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
GtExpandableDebuggerElement >> buildEvaluatorElement [
	| snippetCoder |
	snippetCoder := GtPharoSnippetCoder new
		source: 'self';
		context: self selectedContext;
		variableBindings: (GtSnippetBindings new
			receiver: self selectedContext receiver).
	^ snippetCoder asElement
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
	| newStackElement |
	newStackElement := GtDebuggerExpandableStackElement new.
	newStackElement userData at: #blocContainer put: #stackElement.
	^ newStackElement
]

{ #category : #'building widgets' }
GtExpandableDebuggerElement >> buildStackTabGroupForElement: aStackElement [
	| tab tabGroup |
	tab := BrTab new.
	tab
		look: BrGlamorousTabLook new invisibleBar;
		label: self session name;
		stencil: (BrValuableStencil from: aStackElement);
		padding:
			(BlInsets
				top: 15
				right: 0
				bottom: 15
				left: 10);
		actionsStencil: [ | aToolbar |
			aToolbar := BrToolbar new.
			aToolbar look: BrGlamorousToolbarLook new.
			self buildStackToolbarActions
				do: [ :anAction | aToolbar addItem: anAction ].
			aToolbar ].
	tabGroup := BrTabGroup new.
	tabGroup
		look:
			(BrMaterialTabGroupLook new
				headerBackground: BrGlamorousColors defaultButtonBorderColor);
		addTab: tab;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		addChild:
			(BlElement new
				constraintsDo: [ :c | 
					c ignoreByLayout.
					c horizontal matchParent.
					c vertical exact: 5 ];
				background: BrGlamorousColors errorBackgroundColor;
				yourself).
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
		look: BrGlamorousButtonWithIconLook + BrGlamorousToggleBackgroundLook;
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
	list addEventHandler: (GtInspectorListToSelectHandler new 
		transformation: [ :variableNode | variableNode value ]).
	list column
		title: 'Icon';
		stencil: [ :variableNode | 
			| icon variableValue |
			icon := [ 
				variableValue := variableNode rawValue.
				variableValue gtInspectorIcon ifNil: [ variableValue class systemIcon ] 
			]	on: Error, Halt
				do: [ :error | self iconNamed: #smallWarningIcon ].
			icon asElement
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ].
	list column
		title: 'Variable';
		stencil: [ :variableNode | 
			BrLabel new
				look: (BrGlamorousLabelLook new foreground: Color black);
				text: variableNode key;
				hMatchParent;
				vMatchParent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ].
	list column
		title: 'Value';
		stencil: [ :variableNode || rawValue displayValue| 
			[ rawValue := variableNode rawValue ] 
				on: Error 
				do: [ :error | displayValue := variableNode errorMessage asRopedText foreground: Color red ].
			BrLabel new
				look: BrGlamorousLabelLook new;
				text: ([ displayValue ifNil: [ rawValue gtDisplayString asRopedText ] ] 
					on: Error, Halt
					do: [ :error | error messageText asRopedText foreground: Color red ]);
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
	| activeCoder |
	activeCoder := self selectedCoder.
	(activeCoder isNil or: [ activeCoder isDead ])
		ifTrue: [ ^ #() ].
	^ activeCoder debuggerVariableNodes
	
]

{ #category : #'accessing context' }
GtExpandableDebuggerElement >> currentContext [
	^ self selectedContext 
]

{ #category : #'accessing - elements' }
GtExpandableDebuggerElement >> detailsPane [
	^ self childNamed: #detailsPane
]

{ #category : #opening }
GtExpandableDebuggerElement >> filteredStack [
	^ (self session stackOfSize: 50 ) select: [ :aContext | 
		(aContext method hasPragmaNamed: #debuggerCompleteToSender) not ]
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

{ #category : #opening }
GtExpandableDebuggerElement >> openWithFullView [
	"Open the debugger and also select the first non filtered context, this mean that we will ignore some methods like halts or debug method to select the first interesting line in the debugger."
	self setDebuggerToFirstNonFilteredContext.
	super openWithFullView
]

{ #category : #'accessing context' }
GtExpandableDebuggerElement >> selectedCoder [
	^ self stackElement selectedCoder
]

{ #category : #'accessing context' }
GtExpandableDebuggerElement >> selectedContext [
	^ self selectedCoder context
]

{ #category : #opening }
GtExpandableDebuggerElement >> setDebuggerToFirstNonFilteredContext [
	"I set the debugger to the first non filtered stack"

	| selection |
	selection := self selectedContext.
	(selection isNil or: [ selection method hasPragmaNamed: #debuggerCompleteToSender ]) ifFalse: [ ^ self ].
	
	 self filteredStack ifNotEmpty: [ :filteredStack |
		self selectedCoder expanded: false. "Do not expand the first context as another context is going to be expanded"
		self stackElement selectContext: filteredStack first ]
	
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

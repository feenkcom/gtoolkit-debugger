Class {
	#name : #GtAbstractExpandableDebuggerElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'toolbar'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #accessing }
GtAbstractExpandableDebuggerElement class >> sessionClass [
	^ DebugSession 
]

{ #category : #callbacks }
GtAbstractExpandableDebuggerElement >> actOnDebugActionExecuted [
	self updateContents
]

{ #category : #callbacks }
GtAbstractExpandableDebuggerElement >> actOnDebugSessionChanged [
	| panesContainerElement panesTabGroupElement showToolbar |
	panesContainerElement := BlElement new
			layout: BlLinearLayout horizontal;
			constraintsDo: [ :c | 
				c horizontal matchParent.
				c vertical matchParent ].
	self buildPanesStructureIn: panesContainerElement.


	panesTabGroupElement := self
			buildStackTabGroupForElement: panesContainerElement
			withToolbar: self createToolbar.
	self
		removeChildren;
		addChild: panesTabGroupElement.

	showToolbar := debuggingSession
			isContextPostMortem: debuggingSession interruptedContext.
	self
		inUIProcessDo: [ toolbar
				ifNotNil: [ toolbar
						visibility: (showToolbar ifTrue: [ BlVisibility gone ] ifFalse: [ BlVisibility visible ]) ] ].
	self updateStackPane
]

{ #category : #callbacks }
GtAbstractExpandableDebuggerElement >> actOnSelectedContextChangedFor: aContext [
	| detailsTabGroupElement |
	detailsTabGroupElement := self buildDetailsElement.
	self detailsPane 
		removeChildren;
		addChild: detailsTabGroupElement as: #detailsElement
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildContextVariablesElement [
	| contextVariablesElement |
	contextVariablesElement := self buildVariablesListElement.
	contextVariablesElement items: self contextVariables.
	contextVariablesElement containerName: #contextVariablesElement.
	^ contextVariablesElement
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildDetailsElement [
	| detailsTabGroupElement |
	
	detailsTabGroupElement := self buildDetailsTabElement.
	detailsTabGroupElement viewModel 
		when: BrTabSelectedEvent 
		do: [ :event | event tab widgetDo: [ :aTab | self selectedDetailesTabName: aTab label asString ] ].

	(detailsTabGroupElement viewModel tabs 
		select: [ :aTabModel | aTabModel isAttachedToWidget ])
			detect: [ :aTabModel | aTabModel widget label asString = self selectedDetailesTabName ]
			ifFound: [ :aTabModel | aTabModel select ].
	^ detailsTabGroupElement
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildDetailsTabElement [
	^ BrTabGroup new
		background: Color white;
		aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude;
		addTab: (BrTab new
			aptitude: BrGlamorousTabAptitude new;
			label: 'Variables';
			stencil: [ self buildContextVariablesElement ]);
		addTab: (BrTab new
			aptitude: BrGlamorousTabAptitude new;
			label: 'Watches';
			stencil: [ self buildWatchVariablesElement ])
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildPaneElement [
	^ BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ]
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildPanesStructureIn: aContainer [
	| stackPane detailsPane resizableDetailsPane |
	stackPane := self buildPaneElement
		constraintsDo: [ :c | c linear weight: 2 ];
		layout: BlLinearLayout horizontal.
	detailsPane := self buildPaneElement
		layout: BlFrameLayout new;
		padding: (BlInsets all: 10).
	resizableDetailsPane := BrVerticalPane new matchParent addAptitude: (BrGlamorousWithHorizontalResizerAptitude new beLeft).
	resizableDetailsPane addChild: detailsPane as: #detailsPane.
	aContainer 
		removeChildren;
		addChild: stackPane as: #stackPane;
		addChild: resizableDetailsPane
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildStackElement [
	self subclassResponsibility
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildStackTabGroupForElement: aStackContainerElement withToolbar: anObject [
	| tab tabGroup |
	tab := BrTab new.
	tab
		aptitude: BrGlamorousTabWithoutBarAptitude;
		label: self session name;
		stencil: (BrValuableStencil from: aStackContainerElement);
		padding:
			(BlInsets
				top: 15
				right: 0
				bottom: 15
				left: 10);
		toolbarStencil: [ anObject ].
	tabGroup := BrTabGroup new.
	tabGroup
		aptitude:
			(BrGlamorousTabGroupAptitude new
				headerBackground: self theme header defaultBackgroundColor);
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
				background: self theme status errorBackgroundColor;
				yourself).
	^ tabGroup
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildStackToolbarActions [
	<return: #Collection of: #BrButton>	
		
	| buttons toggle |
	buttons := (self actionsForPragmas: self stackDebuggingActionsPragmas) collect: [ :aDebuggingAction | 
		| actionButton |
		actionButton := BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: aDebuggingAction label; 
			action: [ 
				aDebuggingAction execute ].
			aDebuggingAction icon ifNotNil: [ :anIcon | 
				actionButton icon: aDebuggingAction icon asElement ].
			actionButton ].
		
	toggle := BrToggle new 
		aptitude: BrGlamorousButtonWithIconAptitude + BrGlamorousToggleBackgroundAptitude;
		label: 'Variable Value Overlays';
		icon: BrGlamorousIcons edit asElement;
		when: BrToggleActivatedEvent do: [ :anEvent | 
			self stackElement enableVariableAnnotations ];
		when: BrToggleDeactivatedEvent do: [ :anEvent | 
			self stackElement disableVariableAnnotations ].
	buttons add: toggle.
	^ buttons
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildVariablesListElement [
	| list |
	list := BrColumnedList new.
	list margin: (BlInsets top: 10).
	list addEventHandler: (GtPhlowListToSelectHandler new 
		transformation: [ :variableNode | variableNode value ]).
	list rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new).
	list column
		title: 'Icon';
		width: 26;
		cellStencil: [ BlElement new 
			size: 26@22;
			layout: BlLinearLayout horizontal alignCenterLeft;
			labeled: 'Icon Container';
			padding: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :aVariableNode |
			| anIconForm aVariableValue |
			anIconForm := [ 
				aVariableValue := aVariableNode rawValue.
				aVariableValue gtInspectorIcon ifNil: [ aVariableValue class systemIcon ]
			]	on: Error, Halt
				do: [ :error | self iconNamed: #smallWarningIcon ].
			aCellElement
				removeChildren;
				addChild: anIconForm asElement ].
	list column
		title: 'Variable';
		cellStencil: [ 
			BrLabel new
				aptitude: (BrGlamorousLabelAptitude new foreground: Color black);
				hMatchParent;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :aVariableNode |
			aCellElement text: aVariableNode key asRopedText ].
	list column
		title: 'Value';
		cellStencil: [
			BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				hMatchParent;
				vFitContent;
				margin: (BlInsets top: 3 left: 10 bottom: 3 right: 0) ];
		dataBinder: [ :aCellElement :aVariableNode |
			| aRawValue anErrorText|
			[ aRawValue := aVariableNode rawValue ] 
				on: Error 
				do: [ :error | anErrorText := aVariableNode errorMessage asRopedText foreground: Color red ].
			
			aCellElement text: ([ anErrorText ifNil: [ aRawValue gtDisplayString asRopedText ] ] 
					on: Error, Halt
					do: [ :error | error messageText asRopedText foreground: Color red ]) ].
	^ list
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildWatchVariablesElement [
	| watchVariablesElement |
	watchVariablesElement := self buildVariablesListElement.
	watchVariablesElement items: {}.	"self watchVariables"
	^ watchVariablesElement
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> contextVariables [
	| activeCoder |
	activeCoder := self selectedCoder.
	(activeCoder isNil or: [ activeCoder isDead ])
		ifTrue: [ ^ #() ].
	^ activeCoder debuggerVariableNodes
	
]

{ #category : #'accessing - elements' }
GtAbstractExpandableDebuggerElement >> contextVariablesElement [
	^ self detailsPane
		childNamed: #contextVariablesElement
		ifFound: [ :elem | elem ]
		ifNone: [ nil ]
]

{ #category : #callbacks }
GtAbstractExpandableDebuggerElement >> createToolbar [

	toolbar := BrToolbar new.
	toolbar aptitude: BrGlamorousToolbarAptitude new.
	self updateToolbarActions.
	^ toolbar
]

{ #category : #'accessing context' }
GtAbstractExpandableDebuggerElement >> currentContext [
	^ self selectedContext 
]

{ #category : #accessing }
GtAbstractExpandableDebuggerElement >> cursorInterval [
	^ self stackElement cursorInterval
]

{ #category : #'accessing - elements' }
GtAbstractExpandableDebuggerElement >> detailsPane [
	^ self childNamed: #detailsPane
]

{ #category : #opening }
GtAbstractExpandableDebuggerElement >> filteredStack [
	^ (self session stackOfSize: 50 ) select: [ :aContext | 
		(aContext method hasPragmaNamed: #debuggerCompleteToSender) not ]
]

{ #category : #initialization }
GtAbstractExpandableDebuggerElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self userData at: #debuggerContainer put: #debuggerElement.
	self
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						key: BlKeyboardKey F10;
						build);
				action: [ :anEvent :aShortcut | (StepOverDebugAction forDebugger: self) execute ]);
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						key: BlKeyboardKey F11;
						build);
				action: [ :anEvent :aShortcut | (StepIntoDebugAction forDebugger: self) execute ]);
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						key: BlKeyboardKey F12;
						build);
				action: [ :anEvent :aShortcut | (StepThroughDebugAction forDebugger: self) execute ]);
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						key: BlKeyboardKey F5;
						build);
				action: [ :anEvent :aShortcut | (ResumeDebugAction forDebugger: self) execute ]);
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						key: BlKeyboardKey F7;
						build);
				action: [ :anEvent :aShortcut | (RestartDebugAction forDebugger: self) execute ])
]

{ #category : #'accessing context' }
GtAbstractExpandableDebuggerElement >> selectedCoder [
	^ self stackElement selectedCoder
]

{ #category : #'accessing context' }
GtAbstractExpandableDebuggerElement >> selectedContext [
	^ self stackElement selectedContext
]

{ #category : #'accessing - settings' }
GtAbstractExpandableDebuggerElement >> selectedDetailesTabName [
	^ self settings 
		at: #selectedDetailedTabName 
		ifAbsent: [ nil ]
]

{ #category : #'accessing - settings' }
GtAbstractExpandableDebuggerElement >> selectedDetailesTabName: aString [
	self settings 
		at: #selectedDetailedTabName 
		put: aString
]

{ #category : #opening }
GtAbstractExpandableDebuggerElement >> setDebuggerToFirstNonFilteredContext [
	"I set the debugger to the first non filtered stack"

	| selection |
	selection := self selectedContext.
	(selection isNil or: [ 
		selection method hasPragmaNamed: #debuggerCompleteToSender ]) 
			ifFalse: [ ^ self ].
	
	 self filteredStack ifNotEmpty: [ :filteredStack |
		self stackElement selectContext: filteredStack first ]
]

{ #category : #'accessing - elements' }
GtAbstractExpandableDebuggerElement >> stackElement [
	^ self stackPane childNamed: #stackElement
]

{ #category : #'accessing - elements' }
GtAbstractExpandableDebuggerElement >> stackPane [
	^ self childNamed: #stackPane
]

{ #category : #updating }
GtAbstractExpandableDebuggerElement >> updateCoders [
	'TODO'
]

{ #category : #updating }
GtAbstractExpandableDebuggerElement >> updateContents [
	self updateStackWidget.
	self updateVariablesList.
	self updateToolbarActions
]

{ #category : #updating }
GtAbstractExpandableDebuggerElement >> updateStackPane [
	| stackElement |
	stackElement := self buildStackElement.
	self stackPane 
		removeChildren;
		addChild: stackElement.
	self updateStackWidget.
]

{ #category : #updating }
GtAbstractExpandableDebuggerElement >> updateStackWidget [
	self stackElement updateForSession: debuggingSession.
]

{ #category : #callbacks }
GtAbstractExpandableDebuggerElement >> updateToolbarActions [
	toolbar removeAllItems.
	self buildStackToolbarActions do: [ :anAction | 
		toolbar addItem: anAction ]
]

{ #category : #updating }
GtAbstractExpandableDebuggerElement >> updateVariablesList [
	self contextVariablesElement
		ifNotNil: [ :elem | elem items: self contextVariables ]
]

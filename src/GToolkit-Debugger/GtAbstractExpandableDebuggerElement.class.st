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
		enqueueTask: (BlTaskAction new
				action: [ toolbar
						ifNotNil: [ toolbar
								visibility: (showToolbar ifTrue: [ BlVisibility gone ] ifFalse: [ BlVisibility visible ]) ] ]).
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

{ #category : #callbacks }
GtAbstractExpandableDebuggerElement >> actOnSelectedContextChangedWithoutFocusChangeFor: aContext [
	"No action needed at the moment"
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> addDefaultTabsToGroup: aTabGroup [ 
	aTabGroup
		addTab: (BrTab new
			aptitude: BrGlamorousTabAptitude new;
			label: 'Variables';
			stencil: [ self buildContextVariablesElement ])
		at: 1
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildContextVariablesElement [
	| contextVariablesElement |
	contextVariablesElement := self buildVariablesListElement.
	contextVariablesElement groups: self contextVariables.
	contextVariablesElement containerName: #contextVariablesElement.
	^ contextVariablesElement
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildDetailsElement [
	| detailsContainer detailsTabGroup debuggerPlaygroundElement |
	
	detailsContainer := BrVerticalPane new
		matchParent;
		addAptitude: BrShadowAptitude.
	
	detailsTabGroup := self buildDetailsTabElement.
	self registerDetailsTabSelectionEventsFor: detailsTabGroup.
	self selectDetailsTabFor: detailsTabGroup. 
			
	debuggerPlaygroundElement := self buildPlaygroundElement.
	
	detailsContainer addChild: detailsTabGroup.
	detailsContainer addChild: debuggerPlaygroundElement.
	
	^ detailsContainer
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildDetailsTabElement [
	| compositeView tabGroup |
	
	compositeView := self collectDetailsPaneDebuggingViews.
	
	tabGroup := compositeView asElementDo: [ :e | e ].
	tabGroup
		matchParent;
		background: Color white.

	self addDefaultTabsToGroup: tabGroup.
			
	^ tabGroup
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
		beInSeparateCompositionLayer;
		layout: BlFrameLayout new;
		padding: (BlInsets all: 10).
	resizableDetailsPane := BrVerticalPane new matchParent 
		addAptitude: (BrGlamorousWithHorizontalResizerAptitude new beLeft).
	
	resizableDetailsPane addChild: detailsPane as: #detailsPane.
	aContainer 
		removeChildren;
		addChild: stackPane as: #stackPane;
		addChild: resizableDetailsPane
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildPlaygroundElement [
	^ GtDebuggerPlaygroundElement new
		debuggerElement:  self;
		updateContent
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
		padding: (BlInsets top: 15 right: 0 bottom: 15 left: 10);
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
GtAbstractExpandableDebuggerElement >> buildStackToolbarActionsForDebuggingActions: aCollectionOfDebuggingActions [
	<return: #Collection of: #BrButton>	
	| debuggingActionButtons toggle |
	
	debuggingActionButtons := OrderedCollection new.
	aCollectionOfDebuggingActions do: [ :aDebuggingAction | 
		aDebuggingAction 
			asDebugActionElementWithHostElement: self
			do: [ :anElement | 
				debuggingActionButtons add: anElement ] ].
		
	toggle := BrToggle new 
		aptitude: BrGlamorousButtonWithIconAptitude 
			+ BrGlamorousToggleBackgroundAptitude;
		label: 'Variable Value Overlays';
		icon: BrGlamorousIcons edit asElement;
		when: BrToggleActivatedEvent do: [ :anEvent | 
			self stackElement enableVariableAnnotations ];
		when: BrToggleDeactivatedEvent do: [ :anEvent | 
			self stackElement disableVariableAnnotations ].
	debuggingActionButtons add: toggle.
	
	^ debuggingActionButtons
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> buildVariablesListElement [
	| list |
	list := BrGroupedList new.
	list
		margin: (BlInsets all: 10);
		headerElementStencil: [ 
			BrLabel new
				margin: (BlInsets top: 5);
				aptitude: (BrGlamorousLabelAptitude new 
						foreground: Color gray)
					+ (BrStyleCommonAptitude new
							default: [ :aStyle | 
								aStyle
									geometry: (BlRoundedRectangleGeometry 
										cornerRadius: 4);
									border: BlBorder empty ]) ];
		headerDataBinder: [ :aLabel :eachItem | 
			aLabel viewModel model: eachItem domainObject.
			aLabel text: eachItem domainObject ].
	list
		addEventHandler: (GtPhlowListToSelectHandler new
				transformation: [ :variableNode | variableNode value ]).
	^ list
]

{ #category : #'building actions' }
GtAbstractExpandableDebuggerElement >> collectContextDebuggingViewsIn: aComposite [ 
	| targetObjects |
	targetObjects := {
		self selectedContext . 
		self selectedContext  receiver } asOrderedCollection.
	debuggingSession exception ifNotNil: [ :anException | 
		targetObjects add: anException ].
		
	targetObjects do: [ :aTargetObject | 
		aComposite collectorAppend: [ :aCollector |
			aCollector pragmaName: #gtContextView.
			aCollector context: (GtPhlowContext new 
				currentDebugger: self).
			aCollector fromObject: aTargetObject ] ]
]

{ #category : #'building actions' }
GtAbstractExpandableDebuggerElement >> collectDetailsPaneDebuggingViews [
	| composite |
	composite := GtPhlowView empty composite.
	composite title: 'Views'.
		
	self collectDetailsPaneDebuggingViewsin: composite.
	
	^ composite
]

{ #category : #'building actions' }
GtAbstractExpandableDebuggerElement >> collectDetailsPaneDebuggingViewsin: aComposite [
	
	self collectContextDebuggingViewsIn: aComposite. 
	self collectReceiverExceptionSpecificDebuggingViewsIn: aComposite.
]

{ #category : #'building actions' }
GtAbstractExpandableDebuggerElement >> collectGlobalDebuggingActions [
	^ self actionsForPragmas: self stackDebuggingActionsPragmas
]

{ #category : #'building actions' }
GtAbstractExpandableDebuggerElement >> collectMainToolbarDebuggingActions [
	| globalDebuggingActions targetObjectsDebuggingActions |
	
	globalDebuggingActions := self collectGlobalDebuggingActions.
	targetObjectsDebuggingActions := self collectTargetDebuggingActions.
	
	^ (globalDebuggingActions, targetObjectsDebuggingActions) 
		sorted: [ :aDebuggingAction | aDebuggingAction order ] ascending
]

{ #category : #'building actions' }
GtAbstractExpandableDebuggerElement >> collectReceiverExceptionSpecificDebuggingViewsIn: aComposite [
	debuggingSession exception ifNotNil: [ :anException |
		| currentReceiver |
		currentReceiver := self selectedContext  receiver .
		anException gtDefaultDebuggerSpecification
			collectContextDebuggingViewsForReceiver: currentReceiver
			forDebugger: self 
			in: aComposite ] 
]

{ #category : #'building actions' }
GtAbstractExpandableDebuggerElement >> collectTargetDebuggingActions [
	^ debuggingSession exception 
		ifNil: [ #() ] 
		ifNotNil: [ :anException |
			anException gtDefaultDebuggerSpecification
				collectTargetDebuggingActionsForDebugger: self ] 
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> contextVariableGroupsFor: aListOfVariables [
	^ (self groupVariableNodes: aListOfVariables)
		collect: [ :each | 
			BrGroup new
				items: each value;
				domainObject: each key;
				itemStencil: [ self createVariableRowElement ];
				itemDataBinder: [ :aRowElement :aVariableNode | 
					self 
						updateRowElement: aRowElement 
						withVariableNode: aVariableNode ];
				shouldShowWithoutItems: false ]
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> contextVariables [
	| activeCoder |
	activeCoder := self selectedCoder.
	(activeCoder isNil or: [ activeCoder isDead ])
		ifTrue: [ ^ #() ].
		
	^self contextVariableGroupsFor: activeCoder debuggerVariableNodes
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
	toolbar beInSeparateCompositionLayer.
	toolbar aptitude: BrGlamorousToolbarAptitude new.
	self updateToolbarActions.
	^ toolbar
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> createVariableRowElement [
	| valueLabel varLabel |
	varLabel := GtPhlowLabelWithIcon new id: #varLabelId.
	valueLabel := BrLabel new
			aptitude: BrGlamorousLabelAptitude;
			hMatchParent;
			id: #valueLabelId.
	^ BrHorizontalPane new
		addAptitude: BrGlamorousListItemAptitude;
		hMatchParent;
		vFitContent;
		alignCenter;
		margin: (BlInsets left: 5);
		addChildren: {varLabel.
				valueLabel}
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
	^ self childWithId: #detailsPane
]

{ #category : #opening }
GtAbstractExpandableDebuggerElement >> filteredStack [
	^ (self session stackOfSize: 50 ) select: [ :aContext | 
		(aContext method hasPragmaNamed: #debuggerCompleteToSender) not ]
]

{ #category : #utils }
GtAbstractExpandableDebuggerElement >> groupVariableNodes: aListOfVariables [ 
	| sortOrder|
	sortOrder := #('implicit' 'parameter' 'temporary' 'slot' 'stack').
	^ (aListOfVariables groupedBy: [ :each | each variableTag ]) associations
		sorted: [ :each | sortOrder indexOf: each key ifAbsent: [0] ] ascending
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

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> registerDetailsTabSelectionEventsFor: aDetailsTabGroupElement [ 
	aDetailsTabGroupElement viewModel 
		when: BrTabSelectedEvent 
		do: [ :anEvent | anEvent tab 
			widgetDo: [ :aTab | 
				self selectedDetailesTabName: aTab label asString ] ]
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> selectDetailsTabFor: aDetailsTabGroupElement [
	(aDetailsTabGroupElement viewModel tabs
		select: [ :aTabModel | aTabModel isAttachedToWidget ])
		detect: [ :aTabModel | aTabModel widget label asString sameContentAs: self selectedDetailesTabName ]
		ifFound: [ :aTabModel | aTabModel select ]
		ifNone: [ aDetailsTabGroupElement viewModel tabs
				ifNotEmpty: [ :aTabsList | aTabsList first select ] ]
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

{ #category : #'building actions' }
GtAbstractExpandableDebuggerElement >> stackDebuggingActionsPragmas [
	<return: #Collection of: #Symbol>
	^ debuggingSession exception 
		ifNil: [ super stackDebuggingActionsPragmas ] 
		ifNotNil: [ :anException |
			super stackDebuggingActionsPragmas
				, anException gtDefaultDebuggerSpecification globalDebuggingActionPragmas ] 
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
GtAbstractExpandableDebuggerElement >> updateDetailsPane [
	self updateVariablesList.
	self updateDetailsPaneDebuggingViews.
]

{ #category : #updating }
GtAbstractExpandableDebuggerElement >> updateDetailsPaneDebuggingViews [
	"Place to update in the future the tabs in the details pane for step operations within the same context"
	
	"| compositeView |
	
	compositeView := self collectDetailsPaneDebuggingViews.
	compositeView ifEmpty: [ ^ self ].
	"
]

{ #category : #'building widgets' }
GtAbstractExpandableDebuggerElement >> updateRowElement: aRowElement withVariableNode: aVariableNode [
	| aRawValue anErrorText anIconForm |
	anIconForm := [ | aVariableValue |
		aVariableValue := aVariableNode rawValue.
		aVariableValue gtInspectorIcon
			ifNil: [ aVariableValue class 
				iconNamed: aVariableValue class systemIconName ] ]
			on: Error , Halt
			do: [ :error | self iconNamed: #smallWarningIcon ].
	
	(aRowElement childWithId: #varLabelId)
		initializeWithIcon: anIconForm
		label: aVariableNode key asString.
	[ aRawValue := aVariableNode rawValue ]
		on: Error
		do: [ :error | 
			anErrorText := aVariableNode errorMessage asRopedText
					foreground: Color red ].
	(aRowElement childWithId: #valueLabelId)
		text: ([ anErrorText ifNil: [ aRawValue gtDisplayText asRopedText ] ]
				on: Error , Halt
				do: [ :error | error messageText asRopedText foreground: Color red ])
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
	| debuggingActions |
	
	debuggingActions := self collectMainToolbarDebuggingActions.
	(debuggingActions
		gtHasEqualElements: toolbar viewModel model
		by: [ :a :b | a id = b id ])
			ifTrue: [ ^ self ].
			
	toolbar viewModel model: debuggingActions.
	toolbar removeAllItems.
	
	(self buildStackToolbarActionsForDebuggingActions: debuggingActions) 
		do: [ :anAction | 
			toolbar addItem: anAction ].
	self updateToolbarWithExtraActions.
]

{ #category : #callbacks }
GtAbstractExpandableDebuggerElement >> updateToolbarWithExtraActions [
	| phlowAction |
	phlowAction := GtPhlowAction new dropdown
		tooltip: 'Inspect';
		icon: BrGlamorousVectorIcons hamburger;
		content: [ :aButton | 
			| actions |
			actions := OrderedCollection new.
			debuggingSession exception ifNotNil: [
				actions add: ('Inspect Exception' -> [ :anElement | 
					anElement phlow spawnObject: debuggingSession exception.
					aButton dispatchEvent: BrDropdownHideWish new])].
			actions add: ('Inspect Debugging Session' -> [ :anElement | 
				anElement phlow spawnObject: debuggingSession.
				aButton dispatchEvent: BrDropdownHideWish new ]).
			BrGlamorousSimpleContextMenuContent new
				items:actions;
				yourself ].
	phlowAction 
		asElement: [ :actionElement | 
			toolbar addItem: actionElement ]				
		withHostElement: toolbar 
]

{ #category : #updating }
GtAbstractExpandableDebuggerElement >> updateVariablesList [
	self contextVariablesElement
		ifNotNil: [ :elem | 
			| newContextVariables |
			newContextVariables := self contextVariables.
			elem groups: newContextVariables
			"(elem items gtHasIdenticalElements: newContextVariables)
				ifFalse: [ elem items: self contextVariables ]" ]
]

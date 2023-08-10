Class {
	#name : #GtExceptionViewsDebuggingElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'toolbar',
		'viewsContainer',
		'mainTab',
		'compositeView',
		'debuggingConfiguration'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #testing }
GtExceptionViewsDebuggingElement class >> availableAutomatically [
	"Should this debugger be taken into account when looking for a debugger to handle an exception."
	
	^ true
]

{ #category : #accessing }
GtExceptionViewsDebuggingElement class >> defaultTitle [
	^ 'Exception'
]

{ #category : #testing }
GtExceptionViewsDebuggingElement class >> handlesDebugSession: aDebugSession [
	| targetException |
	
	targetException := aDebugSession exception.
	targetException ifNil: [ ^ false ].
	
	^ targetException gtDebuggingViewConfiguration canShowDebuggingExtension
]

{ #category : #'tool registration' }
GtExceptionViewsDebuggingElement class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry registerDebugger: self withRank: 100.
]

{ #category : #accessing }
GtExceptionViewsDebuggingElement class >> sessionClass [
	^ GtFilteredDebugSession
]

{ #category : #callbacks }
GtExceptionViewsDebuggingElement >> actOnDebugSessionChanged [
	debuggingConfiguration := self targetException gtDebuggingViewConfiguration.
	self updateContent.
]

{ #category : #'views - collecting' }
GtExceptionViewsDebuggingElement >> attachDebuggingActionsForView: aView [ 
	(self collectDebuggingActionsForView: aView) 
		do: [ :aDebuggingAction |
			aDebuggingAction addToPhlowView: aView ].
]

{ #category : #'building - widgets' }
GtExceptionViewsDebuggingElement >> buildMainTabWithContent: aTabContent andToolbar: aToolbarElement [
	^ BrTab new
		aptitude: BrGlamorousTabWithoutBarAptitude;
		"label: self session name;"
		stencil: (BrValuableStencil from: aTabContent);
		padding: (BlInsets top: 15 right: 0 bottom: 15 left: 10);
		toolbarStencil: [ aToolbarElement ].
]

{ #category : #'building - widgets' }
GtExceptionViewsDebuggingElement >> buildStackToolbarActions [
	<return: #Collection of: #BrButton>	
	| buttons |
	
	buttons := (self actionsForPragmas: self exceptionGlobalDebugActionsPragmas) 
		collect: [ :aDebuggingAction | 
			aDebuggingAction asBrickButton ].
	
	^ buttons
]

{ #category : #'building - widgets' }
GtExceptionViewsDebuggingElement >> buildTabGroupWithTab: aTab [
	| tabGroup |
	tabGroup := BrTabGroup new.
	tabGroup
		aptitude:
			(BrGlamorousTabGroupAptitude new
				headerBackground: self theme header defaultBackgroundColor);
		addTab: aTab;
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

{ #category : #'building - widgets' }
GtExceptionViewsDebuggingElement >> buildToolbar [
	^ BrToolbar new
		aptitude: BrGlamorousToolbarAptitude new;
		yourself
]

{ #category : #'building - widgets' }
GtExceptionViewsDebuggingElement >> buildViewsContainer [
	^ BrFrame new
		matchParent
]

{ #category : #'views - collecting' }
GtExceptionViewsDebuggingElement >> collectDebuggingActionsForView: aView [ 
	 ^ (self actionsForPragmas: self viewActionsPragmas)
	 	select: [ :aDebuggingAction | 
			aDebuggingAction appliesToPhlowView: aView]
]

{ #category : #'views - collecting' }
GtExceptionViewsDebuggingElement >> collectTargetDebuggingViews [
	^ (GtPhlowEmptyView empty composite 
		title: 'Views';
		collectorDo: [ :aCollector |
			aCollector 
				fromObject: self debuggingConfiguration debuggingTargetObject;
				pragmaNames: self debuggingConfiguration debuggingViewPragmas ])
]

{ #category : #accessing }
GtExceptionViewsDebuggingElement >> debuggingConfiguration [
	^ debuggingConfiguration
]

{ #category : #accessing }
GtExceptionViewsDebuggingElement >> exceptionGlobalDebugActionsPragmas [
	^ self debuggingConfiguration globalDebuggingActionPragmas
]

{ #category : #initialization }
GtExceptionViewsDebuggingElement >> initialize [
	super initialize.
	
	self
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	
	self initializeContent.
]

{ #category : #initialization }
GtExceptionViewsDebuggingElement >> initializeContent [
	toolbar := self buildToolbar.
	viewsContainer := self buildViewsContainer.
	
	mainTab := self 
		buildMainTabWithContent: viewsContainer 
		andToolbar: toolbar.
	
	self addChild: (self buildTabGroupWithTab: mainTab)
]

{ #category : #initialization }
GtExceptionViewsDebuggingElement >> initializeViewsContainer [
	| mainContainer |
	mainContainer := BrFrame new
		matchParent. 
		
	self addChild: mainContainer as: #viewsContainer.
]

{ #category : #'debugging actions' }
GtExceptionViewsDebuggingElement >> resumeAndCloseDebugger [
	(self session)
		resume;
		clear.
	self close
]

{ #category : #accessing }
GtExceptionViewsDebuggingElement >> targetException [
	^ debuggingSession exception
]

{ #category : #updating }
GtExceptionViewsDebuggingElement >> updateContent [
	self updateMainTabLabel.
	self updateViews.
	self updateToolbarActions.

]

{ #category : #updating }
GtExceptionViewsDebuggingElement >> updateMainTabLabel [
	mainTab label: self session name
]

{ #category : #updating }
GtExceptionViewsDebuggingElement >> updateToolbarActions [
	toolbar removeAllItems.
	self buildStackToolbarActions do: [ :anAction | 
		toolbar addItem: anAction ].
	compositeView views size = 1 ifTrue: [
		self updateToolbarWithActionsFromView: compositeView views first ].
	self updateToolbarWithExtraActions.
]

{ #category : #updating }
GtExceptionViewsDebuggingElement >> updateToolbarWithActionsFromView: aPhlowView [
	aPhlowView allActionsPromise wait do: [ :aPhlowAction |
		aPhlowAction 
			asElement: [ :actionElement | 
				toolbar addItem: actionElement ]				
			withHostElement: mainTab ]
]

{ #category : #updating }
GtExceptionViewsDebuggingElement >> updateToolbarWithExtraActions [
	| phlowAction |
	phlowAction := GtPhlowAction new dropdown
		tooltip: 'Inspect';
		icon: BrGlamorousVectorIcons hamburger;
		content: [ :aButton | 
			BrGlamorousSimpleContextMenuContent new
				items:{
					('Inspect Exception' -> [ :anElement | 
						anElement phlow spawnObject: self targetException.
						aButton dispatchEvent: BrDropdownHideWish new]).
					('Inspect Debugging Session' -> [ :anElement | 
						anElement phlow spawnObject: debuggingSession.
						aButton dispatchEvent: BrDropdownHideWish new ])};
				yourself ].
	phlowAction 
		asElement: [ :actionElement | 
			toolbar addItem: actionElement ]				
		withHostElement: mainTab 
]

{ #category : #updating }
GtExceptionViewsDebuggingElement >> updateViews [
	| viewsElement |
	compositeView := self collectTargetDebuggingViews.
	
	"compositeView views do: [ :aView |
		self attachDebuggingActionsForView: aView ]."
	
	viewsElement := compositeView views size = 1 
		ifTrue: [ compositeView views first asElementDo: [ :e | e ] ]
		ifFalse: [ compositeView asElementDo: [ :e | e ] ].
	viewsElement addAptitude: BrShadowAptitude new.
	
	viewsContainer
		removeChildren;
		addChild: viewsElement 
		as: #viewsElement
]

{ #category : #accessing }
GtExceptionViewsDebuggingElement >> viewActionsPragmas [
	^ self targetException gtDebuggerViewActionsPragmas
]

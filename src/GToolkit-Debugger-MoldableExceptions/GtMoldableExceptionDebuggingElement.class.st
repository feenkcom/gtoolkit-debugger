"
{{gtClass:GtMoldableExceptionDebuggingElement}} is a domain-specific debugger that shows views and debugging actions based on the current exception.

The debugged uses the settings from the {{gtClass:name=GtMoldableExceptionDebuggingExtensionConfiguration}}  instance returned by {{gtMethod:name=Exception>>#gtDebuggingExtensionConfiguration}}  (this can be overriden by exceptions) to select debugging views and actions.
"
Class {
	#name : #GtMoldableExceptionDebuggingElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'toolbar',
		'viewsContainer',
		'mainTab',
		'compositeView',
		'debuggingConfiguration'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #testing }
GtMoldableExceptionDebuggingElement class >> availableAutomatically [
	"Should this debugger be taken into account when looking for a debugger to handle an exception."
	
	^ true
]

{ #category : #accessing }
GtMoldableExceptionDebuggingElement class >> defaultTitle [
	^ 'Exception'
]

{ #category : #testing }
GtMoldableExceptionDebuggingElement class >> handlesDebugSession: aDebugSession [
	| targetException |
	
	targetException := aDebugSession exception.
	targetException ifNil: [ ^ false ].
	
	^ targetException gtDebuggingExtensionConfiguration canShowDebuggingExtension
]

{ #category : #'tool registration' }
GtMoldableExceptionDebuggingElement class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry registerDebugger: self withRank: 100.
]

{ #category : #accessing }
GtMoldableExceptionDebuggingElement class >> sessionClass [
	^ GtFilteredDebugSession
]

{ #category : #callbacks }
GtMoldableExceptionDebuggingElement >> actOnDebugSessionChanged [
	debuggingConfiguration := self targetException gtDebuggingExtensionConfiguration.
	self updateContent.
]

{ #category : #'views - collecting' }
GtMoldableExceptionDebuggingElement >> attachDebuggingActionsForView: aView [ 
	(self collectDebuggingActionsForView: aView) 
		do: [ :aDebuggingAction |
			aDebuggingAction addToPhlowView: aView ].
]

{ #category : #'building - widgets' }
GtMoldableExceptionDebuggingElement >> buildMainTabWithContent: aTabContent andToolbar: aToolbarElement [
	^ BrTab new
		aptitude: BrGlamorousTabWithoutBarAptitude;
		"label: self session name;"
		stencil: (BrValuableStencil from: aTabContent);
		padding: (BlInsets top: 15 right: 0 bottom: 15 left: 10);
		toolbarStencil: [ aToolbarElement ].
]

{ #category : #'building - widgets' }
GtMoldableExceptionDebuggingElement >> buildStackToolbarActionElementsForToolbar: aToolbar [
	| debuggingActionButtons |
	
	debuggingActionButtons := OrderedCollection new.
	self collectMainToolbarDebuggingActions
		do: [ :aDebuggingAction | 
			aDebuggingAction 
				asDebugActionElementWithHostElement: aToolbar
				do: [ :anElement | 
					debuggingActionButtons add: anElement ] ].
	
	^ debuggingActionButtons
]

{ #category : #'building - widgets' }
GtMoldableExceptionDebuggingElement >> buildTabGroupWithTab: aTab [
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
GtMoldableExceptionDebuggingElement >> buildToolbar [
	^ BrToolbar new
		aptitude: BrGlamorousToolbarAptitude new;
		yourself
]

{ #category : #'building - widgets' }
GtMoldableExceptionDebuggingElement >> buildViewsContainer [
	^ BrFrame new
		matchParent
]

{ #category : #'views - collecting' }
GtMoldableExceptionDebuggingElement >> collectDebuggingActionsForView: aView [ 
	 ^ (self actionsForPragmas: self viewActionsPragmas)
	 	select: [ :aDebuggingAction | 
			aDebuggingAction appliesToPhlowView: aView]
]

{ #category : #'views - collecting' }
GtMoldableExceptionDebuggingElement >> collectGlobalDebuggingActions [
	^ self actionsForPragmas: self exceptionGlobalDebugActionsPragmas
]

{ #category : #'building - widgets' }
GtMoldableExceptionDebuggingElement >> collectMainToolbarDebuggingActions [
	| globalDebuggingActions targetObjectsDebuggingActions |
	
	globalDebuggingActions := self collectGlobalDebuggingActions.
	targetObjectsDebuggingActions := self collectTargetDebuggingActions.
	
	^ (globalDebuggingActions, targetObjectsDebuggingActions) 
		sorted: [ :aDebuggingAction | aDebuggingAction order ] ascending
]

{ #category : #'views - collecting' }
GtMoldableExceptionDebuggingElement >> collectTargetDebuggingActions [
	^ self debuggingConfiguration 
		collectTargetDebuggingActionsForDebugger: self
]

{ #category : #'views - collecting' }
GtMoldableExceptionDebuggingElement >> collectTargetDebuggingViews [
	| composite |
	composite := GtPhlowView empty composite 
		title: 'Views'.
		
	self debuggingConfiguration 
		collectTargetDebuggingViewsForDebugger: self
		in: composite.
	
	^ composite
]

{ #category : #accessing }
GtMoldableExceptionDebuggingElement >> debuggingConfiguration [
	^ debuggingConfiguration
]

{ #category : #accessing }
GtMoldableExceptionDebuggingElement >> exceptionGlobalDebugActionsPragmas [
	^ self debuggingConfiguration globalDebuggingActionPragmas
]

{ #category : #initialization }
GtMoldableExceptionDebuggingElement >> initialize [
	super initialize.
	
	self
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	
	self initializeContent.
]

{ #category : #initialization }
GtMoldableExceptionDebuggingElement >> initializeContent [
	toolbar := self buildToolbar.
	viewsContainer := self buildViewsContainer.
	
	mainTab := self 
		buildMainTabWithContent: viewsContainer 
		andToolbar: toolbar.
	
	self addChild: (self buildTabGroupWithTab: mainTab)
]

{ #category : #initialization }
GtMoldableExceptionDebuggingElement >> initializeViewsContainer [
	| mainContainer |
	mainContainer := BrFrame new
		matchParent. 
		
	self addChild: mainContainer as: #viewsContainer.
]

{ #category : #accessing }
GtMoldableExceptionDebuggingElement >> targetException [
	^ debuggingSession exception
]

{ #category : #updating }
GtMoldableExceptionDebuggingElement >> updateContent [
	self updateMainTabLabel.
	self updateViews.
	self updateToolbarActions.
]

{ #category : #updating }
GtMoldableExceptionDebuggingElement >> updateMainTabLabel [
	mainTab label: self session name
]

{ #category : #updating }
GtMoldableExceptionDebuggingElement >> updateToolbarActions [
	toolbar removeAllItems.
	(self buildStackToolbarActionElementsForToolbar: toolbar) do: [ :anAction | 
		toolbar addItem: anAction ].
	compositeView views size = 1 ifTrue: [
		self updateToolbarWithActionsFromView: compositeView views first ].
	self updateToolbarWithExtraActions.
]

{ #category : #updating }
GtMoldableExceptionDebuggingElement >> updateToolbarWithActionsFromView: aPhlowView [
	aPhlowView allActionsPromise wait do: [ :aPhlowAction |
		aPhlowAction 
			asElement: [ :actionElement | 
				toolbar addItem: actionElement ]				
			withHostElement: mainTab ]
]

{ #category : #updating }
GtMoldableExceptionDebuggingElement >> updateToolbarWithExtraActions [
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
GtMoldableExceptionDebuggingElement >> updateViews [
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
GtMoldableExceptionDebuggingElement >> viewActionsPragmas [
	^ self targetException gtDebuggerViewActionsPragmas
]

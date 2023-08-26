"
{{gtClass:GtExceptionDebuggingElement}} is a domain-specific debugger that shows views and debugging actions based on the current exception.

The debugged uses the settings from the {{gtClass:name=GtExceptionDebugingExtensionConfiguration}}  instance returned by {{gtMethod:name=Exception>>#gtDebuggingExtensionConfiguration}}  (this can be overriden by exceptions) to select debugging views and actions.
"
Class {
	#name : #GtExceptionDebuggingElement,
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
GtExceptionDebuggingElement class >> availableAutomatically [
	"Should this debugger be taken into account when looking for a debugger to handle an exception."
	
	^ true
]

{ #category : #accessing }
GtExceptionDebuggingElement class >> defaultTitle [
	^ 'Exception'
]

{ #category : #testing }
GtExceptionDebuggingElement class >> handlesDebugSession: aDebugSession [
	| targetException |
	
	targetException := aDebugSession exception.
	targetException ifNil: [ ^ false ].
	
	^ targetException gtDebuggingExtensionConfiguration canShowDebuggingExtension
]

{ #category : #'tool registration' }
GtExceptionDebuggingElement class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry registerDebugger: self withRank: 100.
]

{ #category : #accessing }
GtExceptionDebuggingElement class >> sessionClass [
	^ GtFilteredDebugSession
]

{ #category : #callbacks }
GtExceptionDebuggingElement >> actOnDebugSessionChanged [
	debuggingConfiguration := self targetException gtDebuggingExtensionConfiguration.
	self updateContent.
]

{ #category : #'views - collecting' }
GtExceptionDebuggingElement >> attachDebuggingActionsForView: aView [ 
	(self collectDebuggingActionsForView: aView) 
		do: [ :aDebuggingAction |
			aDebuggingAction addToPhlowView: aView ].
]

{ #category : #'building - widgets' }
GtExceptionDebuggingElement >> buildMainTabWithContent: aTabContent andToolbar: aToolbarElement [
	^ BrTab new
		aptitude: BrGlamorousTabWithoutBarAptitude;
		"label: self session name;"
		stencil: (BrValuableStencil from: aTabContent);
		padding: (BlInsets top: 15 right: 0 bottom: 15 left: 10);
		toolbarStencil: [ aToolbarElement ].
]

{ #category : #'building - widgets' }
GtExceptionDebuggingElement >> buildStackToolbarActions [
	<return: #Collection of: #BrButton>	
	| buttons |
	
	buttons := (self actionsForPragmas: self exceptionGlobalDebugActionsPragmas) 
		collect: [ :aDebuggingAction | 
			aDebuggingAction asBrickButton ].
	
	^ buttons
]

{ #category : #'building - widgets' }
GtExceptionDebuggingElement >> buildTabGroupWithTab: aTab [
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
GtExceptionDebuggingElement >> buildToolbar [
	^ BrToolbar new
		aptitude: BrGlamorousToolbarAptitude new;
		yourself
]

{ #category : #'building - widgets' }
GtExceptionDebuggingElement >> buildViewsContainer [
	^ BrFrame new
		matchParent
]

{ #category : #'views - collecting' }
GtExceptionDebuggingElement >> collectDebuggingActionsForView: aView [ 
	 ^ (self actionsForPragmas: self viewActionsPragmas)
	 	select: [ :aDebuggingAction | 
			aDebuggingAction appliesToPhlowView: aView]
]

{ #category : #'views - collecting' }
GtExceptionDebuggingElement >> collectTargetDebuggingViews [
	^ self debuggingConfiguration collectTargetDebuggingViews
]

{ #category : #accessing }
GtExceptionDebuggingElement >> debuggingConfiguration [
	^ debuggingConfiguration
]

{ #category : #accessing }
GtExceptionDebuggingElement >> exceptionGlobalDebugActionsPragmas [
	^ self debuggingConfiguration globalDebuggingActionPragmas
]

{ #category : #initialization }
GtExceptionDebuggingElement >> initialize [
	super initialize.
	
	self
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	
	self initializeContent.
]

{ #category : #initialization }
GtExceptionDebuggingElement >> initializeContent [
	toolbar := self buildToolbar.
	viewsContainer := self buildViewsContainer.
	
	mainTab := self 
		buildMainTabWithContent: viewsContainer 
		andToolbar: toolbar.
	
	self addChild: (self buildTabGroupWithTab: mainTab)
]

{ #category : #initialization }
GtExceptionDebuggingElement >> initializeViewsContainer [
	| mainContainer |
	mainContainer := BrFrame new
		matchParent. 
		
	self addChild: mainContainer as: #viewsContainer.
]

{ #category : #'debugging actions' }
GtExceptionDebuggingElement >> resumeAndCloseDebugger [
	(self session)
		resume;
		clear.
	self close
]

{ #category : #accessing }
GtExceptionDebuggingElement >> targetException [
	^ debuggingSession exception
]

{ #category : #updating }
GtExceptionDebuggingElement >> updateContent [
	self updateMainTabLabel.
	self updateViews.
	self updateToolbarActions.
]

{ #category : #updating }
GtExceptionDebuggingElement >> updateMainTabLabel [
	mainTab label: self session name
]

{ #category : #updating }
GtExceptionDebuggingElement >> updateToolbarActions [
	toolbar removeAllItems.
	self buildStackToolbarActions do: [ :anAction | 
		toolbar addItem: anAction ].
	compositeView views size = 1 ifTrue: [
		self updateToolbarWithActionsFromView: compositeView views first ].
	self updateToolbarWithExtraActions.
]

{ #category : #updating }
GtExceptionDebuggingElement >> updateToolbarWithActionsFromView: aPhlowView [
	aPhlowView allActionsPromise wait do: [ :aPhlowAction |
		aPhlowAction 
			asElement: [ :actionElement | 
				toolbar addItem: actionElement ]				
			withHostElement: mainTab ]
]

{ #category : #updating }
GtExceptionDebuggingElement >> updateToolbarWithExtraActions [
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
GtExceptionDebuggingElement >> updateViews [
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
GtExceptionDebuggingElement >> viewActionsPragmas [
	^ self targetException gtDebuggerViewActionsPragmas
]

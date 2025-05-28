Class {
	#name : #GtDebuggerPlaygroundElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'widthStrategy',
		'pageElement',
		'resizerElement',
		'databasesRegistry',
		'debuggerElement'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #accessing }
GtDebuggerPlaygroundElement >> beExact: aNumber [
	widthStrategy := BrResizerElementLength exact: aNumber.
]

{ #category : #visibility }
GtDebuggerPlaygroundElement >> collapse [
	self height: self minimumHeight.
	self playgroundElementHeight: self minimumHeight
]

{ #category : #accessing }
GtDebuggerPlaygroundElement >> databasesRegistry [
	^ databasesRegistry ifNil: [
			LeDatabasesRegistry default ]
]

{ #category : #accessing }
GtDebuggerPlaygroundElement >> debuggerElement: anElement [
	debuggerElement := anElement
]

{ #category : #'accessing - settings' }
GtDebuggerPlaygroundElement >> debuggerElementSettings [
	^ debuggerElement settings
]

{ #category : #'accessing - defaults' }
GtDebuggerPlaygroundElement >> defaultPlaygroundHeight [
	^ 200
]

{ #category : #visibility }
GtDebuggerPlaygroundElement >> expand [
	widthStrategy adjustHeightFor: self.
	self playgroundElementHeight: widthStrategy length.
]

{ #category : #initialization }
GtDebuggerPlaygroundElement >> initialize [
	super initialize.

	widthStrategy := BrResizerElementLength exact: self defaultPlaygroundHeight.
	
	self initializePageElement.
	
	self cellSpacing: 5.
	self hMatchParent.
	self vFitContent.
	self clipChildren: false.

	"resizer is added in this method"
	self initializeResizerElement.
	self background: self theme default backdropColor.

	self addChild: (BrVerticalPane new 
		matchParent;
		margin: (BlInsets all: 10);
		background: self theme default contentBackground;
		aptitude: BrShadowAptitude;
		addChild: self pageElement as: #page).
]

{ #category : #initialization }
GtDebuggerPlaygroundElement >> initializePageElement [
	pageElement := LePageToolContentTreeElement new 
		withEmptyHeader;
		beInSingleCompositionLayer;
		matchParent
]

{ #category : #initialization }
GtDebuggerPlaygroundElement >> initializeResizerElement [
	resizerElement := BrResizer new
		aptitude: BrGlamorousHandleBarResizerAptitude;
		elevation: (BlRelativeElevation elevation: 1000);
		constraintsDo: [ :c | c ignoreByLayout ];
		beTop;
		target: self.

	self addChild: resizerElement.

	resizerElement
		when: BlResizerResizedEvent
			do: [ :anEvent | self onResizerResized: anEvent ];
		when: BlDoubleClickEvent
			do: [ :anEvent | self onResizerDoubleClick: anEvent ]
]

{ #category : #testing }
GtDebuggerPlaygroundElement >> isCollapsed [
	<return: #Boolean>
	^ self height <= self minimumHeight
]

{ #category : #accessing }
GtDebuggerPlaygroundElement >> locateDefaultPlaygroundDatabase [
	^ self databasesRegistry currentLoadedDefaultLogicalDatabase playgroundDB
]

{ #category : #accessing }
GtDebuggerPlaygroundElement >> locatePageForObject [
	"To update to take the page from the database"
	
	^ self targetPage
]

{ #category : #accessing }
GtDebuggerPlaygroundElement >> minimumHeight [
	^ 8
]

{ #category : #callbacks }
GtDebuggerPlaygroundElement >> onResizerDoubleClick: anEvent [
	anEvent consumed: true.
	self isCollapsed
		ifTrue: [ 
			self expand.
			self tryToFocusFirstSnippet ]
		ifFalse: [ self collapse ]
]

{ #category : #callbacks }
GtDebuggerPlaygroundElement >> onResizerResized: anEvent [
	self beExact: anEvent extent y.
	self playgroundElementHeight: anEvent extent y.
]

{ #category : #accessing }
GtDebuggerPlaygroundElement >> pageElement [
	<return: #LePageToolContentTreeElement>
	^ pageElement
]

{ #category : #'accessing - settings' }
GtDebuggerPlaygroundElement >> playgroundElementHeight [
	^ self debuggerElementSettings 
		at: #playgroundElementHeight 
		ifAbsent: [ self minimumHeight ]
]

{ #category : #'accessing - settings' }
GtDebuggerPlaygroundElement >> playgroundElementHeight: anInteger [
	^ self debuggerElementSettings 
		at: #playgroundElementHeight 
		put: anInteger
]

{ #category : #accessing }
GtDebuggerPlaygroundElement >> selectedContext [
	^ debuggerElement selectedContext
]

{ #category : #'accessing - settings' }
GtDebuggerPlaygroundElement >> targetPage [
	^ self debuggerElementSettings 
		at: #targetPage
		ifAbsentPut: [ 
			| newPage |
			newPage := LePage unnamedPage.
			newPage addSnippet: LePharoSnippet new.
			newPage ]
]

{ #category : #updating }
GtDebuggerPlaygroundElement >> tryToFocusFirstSnippet [
	self pageElement snippetsViewModel
		allChildrenBreadthFirstDo: [ :c | 
			c focused: true.
			^ self ]
]

{ #category : #updating }
GtDebuggerPlaygroundElement >> updateContent [
	self updatePage.
	self updateResizer.
]

{ #category : #updating }
GtDebuggerPlaygroundElement >> updatePage [
	| page pageViewModel |
	
	page := self locatePageForObject.
	
	pageViewModel := page asContentUIModel .
	pageViewModel sharedSnippetContext 
		pharoRuntimeContext: self selectedContext;
		selfObject: self selectedContext receiver.
		
	self pageElement pageViewModel: pageViewModel.
]

{ #category : #updating }
GtDebuggerPlaygroundElement >> updateResizer [
	^ self playgroundElementHeight <= self minimumHeight
		ifTrue: [ self collapse ]
		ifFalse: [ 
			self beExact: self playgroundElementHeight.
			self expand ]
]

"
process ifNotNil: [process terminate].
context := [ '11211212' printString ] asContext.
process := Process
	forContext: context
	priority: Processor userInterruptPriority.	
debuggingSession := (process 
	newDebugSessionNamed: 'test debugging' 
	startedAt: process suspendedContext).
20 timesRepeat: [ 
	debuggingSession stepInto ].
GtDebugger openSwitcherInInspectorOn: debuggingSession.
"
Class {
	#name : #GtDebugger,
	#superclass : #BlElement,
	#instVars : [
		'debuggingSession',
		'stackPane',
		'codePane',
		'detailsPane',
		'stackElement'
	],
	#category : 'GToolkit-Debugger'
}

{ #category : #'instance creation' }
GtDebugger class >> openInSwitcherOn: aDebuggingSession [
	| switcher aDebugger aSpace |

	aDebugger := self new.
	aDebugger constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	aDebugger session: aDebuggingSession.
	
	switcher := GtDebuggerSwitcher new.
	switcher addGenericDebugger: aDebugger.
	switcher constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aDebuggingSession name.
	aSpace extent: 1200@600.
	aSpace addChild: switcher.
	aSpace show.
	
	^ switcher
]

{ #category : #'instance creation' }
GtDebugger class >> openInspectorOn: aDebuggingSession [
	| aDebugger anInspector aSpace |

	aDebugger := self new.
	aDebugger constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	aDebugger session: aDebuggingSession.
	
	anInspector := GtInspector new.
	anInspector constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	anInspector addPageWithContent: aDebugger for: aDebuggingSession.

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aDebuggingSession name.
	aSpace extent: 1200@600.
	aSpace addChild: anInspector.
	aSpace show.
	
	^ aDebugger
]

{ #category : #'instance creation' }
GtDebugger class >> openOn: aDebuggingSession [
	| aDebugger aSpace |

	aDebugger := self new.
	aDebugger constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	aDebugger session: aDebuggingSession.

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aDebuggingSession name.
	aSpace extent: 1200@600.
	aSpace addChild: aDebugger.
	aSpace show.
	
	^ aDebugger
]

{ #category : #'instance creation' }
GtDebugger class >> openSwitcherInInspectorOn: aDebuggingSession [
	| switcher aDebugger anInspector aSpace |

	aDebugger := self new.
	aDebugger constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	aDebugger session: aDebuggingSession.
	
	switcher := GtDebuggerSwitcher new.
	switcher addGenericDebugger: aDebugger.
	switcher constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	
	anInspector := GtInspector new.
	anInspector constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	anInspector addPageWithContent: switcher for: aDebuggingSession.

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aDebuggingSession name.
	aSpace extent: 1200@600.
	aSpace addChild: anInspector.
	aSpace show.
	
	^ aDebugger
]

{ #category : #accessing }
GtDebugger class >> sessionClass [

	^ DebugSession 
]

{ #category : #accessing }
GtDebugger class >> spanNewSessionFrom: anotherSession [

	^ (self sessionClass 
		named: anotherSession name 
		on: anotherSession interruptedProcess 
		startedAt: anotherSession interruptedContext)
			errorWasInUIProcess: anotherSession errorWasInUIProcess;
			yourself
]

{ #category : #accessing }
GtDebugger >> actOnBrowserClosing: ann [
	self session ifNotNil: [ :aSession | 
		aSession terminate.
		debuggingSession := nil ]
]

{ #category : #callbacks }
GtDebugger >> actOnSelectedContextChangedFor: aContext [
	self updateCodePaneFor: aContext.
	self updateDetailsPaneFor: aContext
]

{ #category : #'building actions' }
GtDebugger >> actionsForPragmas: aSymbolsCollection [
	^ (self session class
		debuggingActionsForPragmas: aSymbolsCollection 
		for: self)
	
]

{ #category : #announce }
GtDebugger >> announce: something [
	"Needed by the debugger actions"
]

{ #category : #'building widgets' }
GtDebugger >> buildCodeWidgetForMethodInClass: aClass [
	| styler editor editorElement completionStrategy completionController |
		
	styler := BrRBTextStyler new.
	styler classOrMetaClass: aClass.
	editor := BrTextEditor new.
	editor styler: styler.
	editorElement := BrEditorElement new.
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	editorElement editor: editor.
	completionStrategy := GtPharoCompletionStrategy new.
	completionStrategy classOrMetaClass: aClass.
	completionController := GtCompletionController on: editorElement strategy: completionStrategy.
	completionController install.
	editorElement padding: (BlInsets all: 10).
	^ editorElement
	
]

{ #category : #'building widgets' }
GtDebugger >> buildContextVariablesList [
	| contextVariablesList |
	
	contextVariablesList := BrColumnedList new 
		addEventHandler: (GtInspectorListToSelectHandler new transformation: [:each | each rawValue ]);
		constraintsDo: [ :c | 
			c padding: (BlInsets all: 10) ].
			
	contextVariablesList column
		title: 'Variable';
		stencil: [ :aNode :index |
			| textElement |
			textElement := (BrListLabelStencil matchParent: (GTObjectPrinter asNonTruncatedTextFrom: aNode key)) asElement.
			textElement constraintsDo: [ :c | c padding: (BlInsets right: 10)] ].

	contextVariablesList column
		title: 'Value';
		stencil: [ :aNode :index | 
			| textElement rawValue displayValue |
				[ rawValue := aNode rawValue. ] 
					on: Error 
					do: [ displayValue := Text string: aNode errorMessage attribute: TextColor red ].
			textElement := (BrListLabelStencil matchParent: (displayValue 
				ifNil: [ GTObjectPrinter asTruncatedTextFrom: rawValue ])) asElement.
			textElement constraintsDo: [ :c | c padding: (BlInsets right: 10) ] ].
	^ contextVariablesList
	
	
]

{ #category : #'building widgets' }
GtDebugger >> buildPaneElement [
	^ BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ];
		border: (BlBorder paint: (Color lightGray alpha: 0.5))
]

{ #category : #'building widgets' }
GtDebugger >> buildStackElement [
	^ GtDebuggerStackElement new 
]

{ #category : #'building widgets' }
GtDebugger >> buildStackTabGroupForElement: aStackElement [
	| tab tabGroup |
	tab := BrTab new.
	tab 
		look: (BrGlamorousTabLook new invisibleBar);
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
GtDebugger >> buildStackToolbarActions [
	^ (self actionsForPragmas: self stackDebuggingActionsPragmas) collect: [ :aDebuggingAction | 
		| actionButton |
		actionButton := BrButton new 
			look: BrGlamorousButtonWithIconLook;
			label: aDebuggingAction label; 
			action: [ 
				aDebuggingAction execute.
				aDebuggingAction needsUpdate ifTrue: [
					self updateDebugger ] ].
			aDebuggingAction icon ifNotNil: [ :anIcon | 
				actionButton icon: aDebuggingAction icon asElement ].
			actionButton ]
]

{ #category : #action }
GtDebugger >> close [
	self space close
]

{ #category : #'accessing - elements' }
GtDebugger >> codePane [
	^ codePane
]

{ #category : #accessing }
GtDebugger >> currentContext [
	^ self selectedContext 
]

{ #category : #actions }
GtDebugger >> detachSession [
	debuggingSession := nil
]

{ #category : #'accessing - elements' }
GtDebugger >> detailsPane [
	^ detailsPane
]

{ #category : #'accessing - elements' }
GtDebugger >> editorElement [
 	^ self codePane children first
]

{ #category : #initialization }
GtDebugger >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].		
	
	self initializePanes.	
	
	
]

{ #category : #initialization }
GtDebugger >> initializePanes [
	stackPane := self buildPaneElement.
	codePane := self buildPaneElement
		border: (BlBorder paint: (BrGlamorousColors lightBorderColor)).
	detailsPane := self buildPaneElement.
	self addChildren: {stackPane . codePane . detailsPane}.
]

{ #category : #initialization }
GtDebugger >> initializeStackTransmissions [
	self stackElement stackFramesWidget
		when: BrSelectionChanged
		do: [ :anEvent | anEvent selectedDo: [ :anInterval |
			| anIndex anItemValue |
			anIndex := anInterval first.
			anItemValue := self stackElement stackFramesWidget items at: anIndex.
			self actOnSelectedContextChangedFor: anItemValue ] ]
]

{ #category : #accessing }
GtDebugger >> interruptedContext [
	^ self session interruptedContext
]

{ #category : #accessing }
GtDebugger >> onAddedToSceneGraph [ 
	self space when: BlSpaceClosedEvent do: [ :event | self actOnBrowserClosing: event ]
]

{ #category : #accessing }
GtDebugger >> selectedContext [
	| selectionInterval |
	selectionInterval := self stackElement stackFramesWidget selection.
	^ self stackElement stackFramesWidget items at: selectionInterval from.
]

{ #category : #accessing }
GtDebugger >> session [
	^ debuggingSession
]

{ #category : #accessing }
GtDebugger >> session: aDebuggingSession [
	debuggingSession := aDebuggingSession.
	self updateStackPane.
]

{ #category : #'building actions' }
GtDebugger >> stackDebuggingActionsPragmas [

	^ #( gt2StackDebuggingAction )
]

{ #category : #'accessing - elements' }
GtDebugger >> stackElement [
 	^ stackElement
]

{ #category : #'accessing - elements' }
GtDebugger >> stackPane [
	^ stackPane
]

{ #category : #'updating panes' }
GtDebugger >> updateCodePaneFor: aContext [
	| editorWidget text selectionInterval |
	
	text := aContext sourceCode asRopedText.
	text
		attributes:
			{BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BlFontSizeAttribute size: 14) beNotOverwritableByStyler}.	
	selectionInterval := self session selectedCodeRangeForContext: self selectedContext.
	(text from: selectionInterval first to: selectionInterval last) attributes: { 
		BlTextUnderlineAttribute new 
			paint: BrGlamorousColors errorBackgroundColor; 
			beNotOverwritableByStyler }.
	editorWidget := self buildCodeWidgetForMethodInClass: aContext methodClass.
	editorWidget editor text: text.
	
	self codePane 
		removeChildren;
		addChild: editorWidget.
]

{ #category : #updating }
GtDebugger >> updateDebugger [
	self updateStackWidget
]

{ #category : #'updating panes' }
GtDebugger >> updateDetailsPaneFor: aContext [
	| contextVariablesList |
	
	contextVariablesList := self buildContextVariablesList.
	contextVariablesList display: (self variablesListForContext: aContext).
	
	self detailsPane 
		removeChildren;
		addChild: contextVariablesList.
	
]

{ #category : #'updating panes' }
GtDebugger >> updateStackPane [
	| tabGroup |

	stackElement := self buildStackElement.
	tabGroup := self buildStackTabGroupForElement: stackElement.
	
	self stackPane 
		removeChildren;
		addChild: tabGroup.
	self initializeStackTransmissions.
	self updateStackWidget.
]

{ #category : #updating }
GtDebugger >> updateStackWidget [
	self stackElement updateForSession: debuggingSession.
]

{ #category : #accessing }
GtDebugger >> variablesListForContext: aContext [
	^ aContext gtDebuggerRetrieveVariableValuePairs
]

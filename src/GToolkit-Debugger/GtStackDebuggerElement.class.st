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
	#name : #GtStackDebuggerElement,
	#superclass : #GtDebuggerElement,
	#instVars : [
		'stackPane',
		'codePane',
		'detailsPane',
		'stackElement'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #initialization }
GtStackDebuggerElement class >> defaultTitle [
	^ 'Stack'
]

{ #category : #'tools registry' }
GtStackDebuggerElement class >> registerToolsOn: registry [
	registry registerDebugger: self withRank: 1020.
]

{ #category : #accessing }
GtStackDebuggerElement class >> sessionClass [

	^ DebugSession 
]

{ #category : #updating }
GtStackDebuggerElement >> actOnDebugSessionChanged [
	self updateStackPane
]

{ #category : #callbacks }
GtStackDebuggerElement >> actOnSelectedContextChangedFor: aContext [
	self updateCodePaneFor: aContext.
	self updateDetailsPaneFor: aContext
]

{ #category : #'building widgets' }
GtStackDebuggerElement >> buildCodeWidgetForMethodInClass: aClass [
	| styler editor editorElement completionStrategy completionController |
		
	styler := BrRBTextStyler new.
	styler classOrMetaClass: aClass.
	editor := BrTextEditorModel new.
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
GtStackDebuggerElement >> buildContextVariablesList [
	| contextVariablesList |
	
	contextVariablesList := BrColumnedList new 
		addEventHandler: (GtPhlowListToSelectHandler new transformation: [:each | each rawValue ]);
		constraintsDo: [ :c | 
			c padding: (BlInsets all: 10) ].
			
	contextVariablesList column
		title: 'Variable';
		stencil: [ :aNode :index |
			| textElement |
			textElement := (BrColumnCellLabelStencil 
				matchParent: (aNode key asString replaceAll: String cr with: String space)) asElement.
			textElement constraintsDo: [ :c | c padding: (BlInsets right: 10)] ].

	contextVariablesList column
		title: 'Value';
		stencil: [ :aNode :index | 
			| textElement rawValue displayValue |
				[ rawValue := aNode rawValue. ] 
					on: Error 
					do: [ displayValue := Text string: aNode errorMessage attribute: TextColor red ].
			textElement := (BrColumnCellLabelStencil matchParent: (displayValue 
				ifNil: [ rawValue asString replaceAll: String cr with: String space ])) asElement.
			textElement constraintsDo: [ :c | c padding: (BlInsets right: 10) ] ].
	^ contextVariablesList
	
	
]

{ #category : #'building widgets' }
GtStackDebuggerElement >> buildPaneElement [
	^ BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ];
		border: (BlBorder paint: (Color lightGray alpha: 0.5))
]

{ #category : #'building widgets' }
GtStackDebuggerElement >> buildStackElement [
	^ GtDebuggerStackElement new 
]

{ #category : #'building widgets' }
GtStackDebuggerElement >> buildStackTabGroupForElement: aStackElement [
	| tab tabGroup |
	tab := BrTab new.
	tab
		aptitude: BrGlamorousTabWithoutBarAptitude;
		label: self session name;
		stencil: (BrValuableStencil from: aStackElement);
		padding:
			(BlInsets
				top: 15
				right: 0
				bottom: 15
				left: 10);
		toolbarStencil: [ | aToolbar |
			aToolbar := BrToolbar new.
			aToolbar aptitude: BrGlamorousToolbarAptitude new.
			self buildStackToolbarActions
				do: [ :anAction | aToolbar addItem: anAction ].
			aToolbar ].
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
GtStackDebuggerElement >> buildStackToolbarActions [
	^ (self actionsForPragmas: self stackDebuggingActionsPragmas) collect: [ :aDebuggingAction | 
		| actionButton |
		actionButton := BrButton new 
			aptitude: BrGlamorousButtonWithIconAptitude;
			label: aDebuggingAction label; 
			action: [ 
				aDebuggingAction execute.
				aDebuggingAction needsUpdate ifTrue: [
					self updateStackWidget ] ].
			aDebuggingAction icon ifNotNil: [ :anIcon | 
				actionButton icon: aDebuggingAction icon asElement ].
			actionButton ]
]

{ #category : #'accessing - elements' }
GtStackDebuggerElement >> codePane [
	^ codePane
]

{ #category : #accessing }
GtStackDebuggerElement >> currentContext [
	^ self selectedContext 
]

{ #category : #'accessing - elements' }
GtStackDebuggerElement >> detailsPane [
	^ detailsPane
]

{ #category : #'accessing - elements' }
GtStackDebuggerElement >> editorElement [
 	^ self codePane children first
]

{ #category : #initialization }
GtStackDebuggerElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].		
	
	self initializePanes.	
	
	
]

{ #category : #initialization }
GtStackDebuggerElement >> initializePanes [
	stackPane := self buildPaneElement.
	codePane := self buildPaneElement
		border: (BlBorder paint: self theme default lightBorderColor).
	detailsPane := self buildPaneElement.
	self
		addChildren:
			{stackPane.
			codePane.
			detailsPane}
]

{ #category : #initialization }
GtStackDebuggerElement >> initializeStackTransmissions [
	self stackElement stackFramesWidget
		when: BrSelectionChanged
		do: [ :anEvent | anEvent selectedDo: [ :anInterval |
			| anIndex anItemValue |
			anIndex := anInterval first.
			anItemValue := self stackElement stackFramesWidget items at: anIndex.
			self actOnSelectedContextChangedFor: anItemValue ] ]
]

{ #category : #accessing }
GtStackDebuggerElement >> selectedContext [
	^ self stackElement stackFramesWidget selectedIndices
		ifEmpty: [ nil ]
		ifNotEmpty: [ :theIndices | self stackElement stackFramesWidget items at: theIndices first ]
]

{ #category : #'accessing - elements' }
GtStackDebuggerElement >> stackElement [
 	^ stackElement
]

{ #category : #'accessing - elements' }
GtStackDebuggerElement >> stackPane [
	^ stackPane
]

{ #category : #'updating panes' }
GtStackDebuggerElement >> updateCodePaneFor: aContext [
	| editorWidget text selectionInterval |
	text := aContext sourceCode asRopedText.
	text attributes: {(BlFontSizeAttribute size: 14) beNotOverwritableByStyler}.
	selectionInterval := self session
			selectedCodeRangeForContext: self selectedContext.
	(text from: selectionInterval first to: selectionInterval last)
		attributes: {BlTextUnderlineAttribute new
					color: self theme status errorBackgroundColor;
					thickness: 3;
					beNotOverwritableByStyler}.
	editorWidget := self buildCodeWidgetForMethodInClass: aContext methodClass.
	editorWidget editor text: text.
	self codePane
		removeChildren;
		addChild: editorWidget
]

{ #category : #'updating panes' }
GtStackDebuggerElement >> updateDetailsPaneFor: aContext [
	| contextVariablesList |
	
	contextVariablesList := self buildContextVariablesList.
	contextVariablesList items: (self variablesListForContext: aContext).
	
	self detailsPane 
		removeChildren;
		addChild: contextVariablesList.
	
]

{ #category : #'updating panes' }
GtStackDebuggerElement >> updateStackPane [
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
GtStackDebuggerElement >> updateStackWidget [
	self stackElement updateForSession: debuggingSession.
]

{ #category : #accessing }
GtStackDebuggerElement >> variablesListForContext: aContext [
	^ aContext gtDebuggerRetrieveVariableValuePairs
]

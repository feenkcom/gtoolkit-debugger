Class {
	#name : #GtRewriteDebuggerElement,
	#superclass : #GtDebuggerElement,
	#classInstVars : [
		'availableAutomatically'
	],
	#category : #'GToolkit-Debugger-RB'
}

{ #category : #testing }
GtRewriteDebuggerElement class >> availableAutomatically [
	^ availableAutomatically ifNil: [ true ]
]

{ #category : #accessing }
GtRewriteDebuggerElement class >> availableAutomatically: aBoolean [
	availableAutomatically := aBoolean
]

{ #category : #initialization }
GtRewriteDebuggerElement class >> defaultTitle [
	^ 'RBParseTreeRewriter'
]

{ #category : #testing }
GtRewriteDebuggerElement class >> handlesContext: aContext [
	^ self sessionClass handlesContext: aContext
]

{ #category : #'class initialization' }
GtRewriteDebuggerElement class >> initialize [
	self register
]

{ #category : #'tools registry' }
GtRewriteDebuggerElement class >> registerToolsOn: registry [
	registry registerDebugger: self withRank: 900.
]

{ #category : #accessing }
GtRewriteDebuggerElement class >> sessionClass [
	^ GtRewriteDebugSession
]

{ #category : #callbacks }
GtRewriteDebuggerElement >> actOnDebugSessionChanged [
	self buildUI
]

{ #category : #'building widgets' }
GtRewriteDebuggerElement >> buildContextFor: aDictionary [
	^ (GtPhlowProtoView new columnedList
		title: 'Items';
		priority: 1;
		items: [ aDictionary associations ];
		column: 'Key'
			text: [ :each | 
				((each key isKindOf: RBProgramNode)
					ifTrue: [ each key sourceCode ]
					ifFalse: [ each key ]) asString ];
		column: 'Value'
			text: [ :each | 
				((each value isKindOf: RBProgramNode)
					ifTrue: [ each value sourceCode ]
					ifFalse: [ each value ]) asString ]
			weight: 3;
		contextItemLabel: 'Inspect key'
			action: [ :elem :each | elem phlow spawnObject: each key ];
		contextItemLabel: 'Inspect value'
			action: [ :elem :each | elem phlow spawnObject: each value ];
		contextItemLabel: 'Inspect association'
			action: [ :elem :each | elem phlow spawnObject: each ];
		send: [ :each | each value ]) asElement
]

{ #category : #'building widgets' }
GtRewriteDebuggerElement >> buildDetails [
	| element |
	element := BrVerticalPane new
			matchParent;
			padding: (BlInsets all: 10).
	element addChild: self buildRewrite.
	element addChild: self buildSource as: #source.
	^ element
]

{ #category : #'building widgets' }
GtRewriteDebuggerElement >> buildRewrite [
	| element text tree editor  styler |
	element := BrHorizontalPane new.
	element matchParent.
	tree := debuggingSession replaceTree.
	text := (tree ifNil: [ '' ] ifNotNil: [ tree sourceCode ]) asRopedText.
	styler := GtCompositeSmaCCASTStyler forParser: GtPharoPatternParser.
	styler stylers: {GtPharoPatternStyler new}.
	styler startingState: ((tree notNil and: [ tree isMethod ])
				ifTrue: [ GtPharoParser startingStateForMethod ]
				ifFalse: [ GtPharoParser startingStateForMethodSequence ]).
	editor := BrEditor new.
	editor matchParent.
	editor editor styler: styler.
	editor editor text: text.
	element addChild: editor as: #rewrite.
	debuggingSession context
		ifNotNil: [ :dict | 
			| el |
			el := self buildContextFor: dict.
			element addChild: el as: #matches ].
	^ element
]

{ #category : #'building widgets' }
GtRewriteDebuggerElement >> buildSource [
	| ast coderViewModel |
	ast := debuggingSession ast.
	ast ifNil: [ ^ BlElement new ].
	coderViewModel := (ast methodNode compilationContext
			ifNil: [ (GtPharoMethodCoder forNewMethod: Object)
					sourceCode: (GtCoderExplicitTextSource new text: ast sourceCode) ]
			ifNotNil: [ GtPharoMethodCoder forMethod: ast methodNode compiledMethod ])
			asCoderViewModel.
	debuggingSession matchedNode
		ifNotNil: [ :node | 
			coderViewModel
				addTextAttribute: (BlTextHighlightAttribute
						paint: BrGlamorousColors debuggerTextHighlightColor)
						beNotOverwritableByStyler
				from: node start
				to: node stop ].
	^ coderViewModel asExpandedOnlyElement matchParent
]

{ #category : #initialization }
GtRewriteDebuggerElement >> buildToolbar [
	| toolbar |
	toolbar := BrToolbar new.
	toolbar aptitude: BrGlamorousToolbarAptitude new.
	self toolbarButtons do: [ :anAction | toolbar addItem: anAction ].
	toolbar margin: (BlInsets right: 5).
	toolbar alignTopRight.
	toolbar hMatchParent.
	^ toolbar
]

{ #category : #initialization }
GtRewriteDebuggerElement >> buildUI [
	| tab tabGroup |
	self removeChildren.

	tab := BrTab new.
	tab
		aptitude: BrGlamorousTabWithoutBarAptitude;
		label: self session name;
		stencil: (BrValuableStencil
				from: [ | element |
					element := self buildDetails.
					element enqueueTask: [ self updateUI ] asBlTask.
					element ]);
		padding: (BlInsets
				top: 15
				right: 0
				bottom: 15
				left: 10);
		toolbarStencil: [ | aToolbar |
			aToolbar := BrToolbar new.
			aToolbar aptitude: BrGlamorousToolbarAptitude new.
			self toolbarButtons do: [ :anAction | aToolbar addItem: anAction ].
			aToolbar ].
	tabGroup := BrTabGroup new.
	tabGroup
		aptitude: (BrGlamorousTabGroupAptitude new
				headerBackground: self theme header defaultBackgroundColor);
		addTab: tab;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		addChild: (BlElement new
				constraintsDo: [ :c | 
					c ignoreByLayout.
					c horizontal matchParent.
					c vertical exact: 5 ];
				background: self theme status errorBackgroundColor;
				yourself).
	self addChild: tabGroup
]

{ #category : #accessing }
GtRewriteDebuggerElement >> currentContext [
	^ self session interruptedContext
]

{ #category : #'building widgets' }
GtRewriteDebuggerElement >> debuggerActions [
	^ {GtRewriteRestartAction.
		ResumeDebugAction.
		GtRewriteStepBlockNodeAction.
		GtRewriteStepNodeAction}
		collect: [ :each | each gt2ContextDebuggingActionFor: self ]
]

{ #category : #execution }
GtRewriteDebuggerElement >> executeAction: aDebuggingAction [
	aDebuggingAction execute.
	self updateUI
]

{ #category : #initialization }
GtRewriteDebuggerElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						key: BlKeyboardKey F10;
						build);
				action: [ :anEvent :aShortcut | self executeAction: (GtRewriteStepNodeAction forDebugger: self) ]);
		addShortcut: (BlShortcutWithAction new
				combination: (BlKeyCombination builder
						key: BlKeyboardKey F12;
						build);
				action: [ :anEvent :aShortcut | self executeAction: (GtRewriteStepBlockNodeAction forDebugger: self) ])
]

{ #category : #private }
GtRewriteDebuggerElement >> intervalForContext: context andNode: node [
	| to range from debuggerNode |
	debuggerNode := context method sourceNodeForPC: context pc.
	range := debuggerNode gtDebugHighlightRange.
	range first = 0 ifTrue: [ range := 1 to: node stop - node start + 1 ].
	from := node start + range first - 1.
	to := node start + range last - 1.
	^ from to: to
]

{ #category : #testing }
GtRewriteDebuggerElement >> isPatternBlockContext: aContext [
	^ debuggingSession isPatternBlockContext: aContext
]

{ #category : #initialization }
GtRewriteDebuggerElement >> toolbarButtons [
	| buttons |
	buttons := self debuggerActions
			collect: [ :aDebuggingAction | 
				| actionButton |
				actionButton := BrButton new
						margin: (BlInsets right: 3);
						aptitude: BrGlamorousButtonWithIconAptitude;
						label: aDebuggingAction defaultLabel;
						action: [ self executeAction: aDebuggingAction ].
				aDebuggingAction icon ifNotNil: [ :icon | actionButton icon: icon ].
				actionButton ].
	^ buttons
]

{ #category : #updating }
GtRewriteDebuggerElement >> updateRewrite [
	| editor |
	self session ifNil: [ ^ self ].
	editor := self childNamed: #rewrite.
	editor ifNil: [ ^ self ].
	editor editor text
		clearAttributes: [ :each | each class = BlTextHighlightAttribute ].
	self session node
		ifNotNil: [ :node | 
			self session patternBlockContext
				ifNotNil: [ :context | 
					| interval |
					interval := self intervalForContext: context andNode: node.
					(editor editor text from: interval first to: interval last)
						attribute: (BlTextHighlightAttribute paint: BrGlamorousColors debuggerTextHighlightColor)
								beNotOverwritableByStyler ]
				ifNil: [ (editor editor text from: node start to: node stop)
						attribute: (BlTextHighlightAttribute paint: BrGlamorousColors debuggerTextHighlightColor)
								beNotOverwritableByStyler ] ]
]

{ #category : #updating }
GtRewriteDebuggerElement >> updateUI [
	self updateRewrite
]

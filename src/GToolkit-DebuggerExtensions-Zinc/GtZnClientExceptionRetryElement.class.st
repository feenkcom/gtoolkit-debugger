Class {
	#name : #GtZnClientExceptionRetryElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'retryAction',
		'playButton',
		'messageEditorElement',
		'countEditorElement',
		'currentDebugger',
		'sourceElement'
	],
	#category : #'GToolkit-DebuggerExtensions-Zinc'
}

{ #category : #'instance creation' }
GtZnClientExceptionRetryElement class >> forZnClient: aZnClient andDebugger: aDebugger fromSourceElement: aSourceElement [
	^ self new 
		initializeForZnClient: aZnClient 
		andDebugger: aDebugger 
		fromSourceElement: aSourceElement
]

{ #category : #accessing }
GtZnClientExceptionRetryElement >> actionLabel: aString [ 
	playButton label: aString
]

{ #category : #'building widgets' }
GtZnClientExceptionRetryElement >> createHelpButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude;
		icon: BrGlamorousIcons help;
		label: ('Open the page "{1}"' format: {self helpPageName});
		action:  [ :aButton  |
			self spawnHelpPageFrom: (sourceElement ifNil: [aButton]) ]
]

{ #category : #'building widgets' }
GtZnClientExceptionRetryElement >> createMessageElement [
	| newEditorElement |
	
	newEditorElement := BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude new .
	
	newEditorElement 
		hExact: 325;
		vFitContent.
	
	^ newEditorElement
]

{ #category : #'building widgets' }
GtZnClientExceptionRetryElement >> createPlayButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude;
		icon: BrGlamorousVectorIcons play;
		action:  [ self runRetryAction ]
]

{ #category : #'building widgets' }
GtZnClientExceptionRetryElement >> createRedirectCountLabel [
	^ BrLabel new 
		text: self editLabelText;
		aptitude: (BrGlamorousLabelAptitude new 
			foreground: Color gray;
			fontSize: 12)
]

{ #category : #'building widgets' }
GtZnClientExceptionRetryElement >> createRedirectsCountEditorElement [
	| newEditorElement |
	
	newEditorElement := BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude new .
	
	newEditorElement 
		hExact: 75;
		vFitContent;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 4).
	
	newEditorElement addAptitude: (BrStyleCommonAptitude new
		default: [ :aStyle | 
			aStyle border: (BlBorder 
				paint: BrGlamorousColors disabledButtonBorderColor 
				width: 1) ];
		hovered: [ :aStyle | 
			aStyle border: (BlBorder 
				paint: BrGlamorousColors disabledButtonBorderColor 
				width: 1) ];
		focused: [ :aStyle | 
			aStyle border: (BlBorder 
				paint: BrGlamorousColors focusedEditorBorderColor 
				width: 1) ]).
				
	newEditorElement 
		when: BlFocusInEvent do: [ :anEvent | 
			countEditorElement selecter all select ];
		when: BlFocusOutEvent do: [ :anEvent | 
			countEditorElement deselecter all deselect ].
			
	^ newEditorElement
]

{ #category : #accessing }
GtZnClientExceptionRetryElement >> editLabelText [
	^ 'Value:'
]

{ #category : #accessing }
GtZnClientExceptionRetryElement >> helpPageName [
	^ 'Zinc debugging extensions'
]

{ #category : #initialialize }
GtZnClientExceptionRetryElement >> initialize [ 
	| toolbar |
	super initialize.
	
	self hFitContent.
	self vFitContent.
	self padding: (BlInsets all: 5).
	
	messageEditorElement := self createMessageElement.
	countEditorElement := self createRedirectsCountEditorElement  . 
	playButton := self createPlayButton.
	
	toolbar := BrToolbar new.
	toolbar aptitude: BrGlamorousToolbarAptitude new.
	toolbar
		addChild: playButton;
		addChild: self createHelpButton.
	
	self 
		addChild: messageEditorElement;
		addChild: (BrHorizontalPane new 
			fitContent;
			alignCenter;
			margin: (BlInsets left: 5);
			addChild: (self createRedirectCountLabel 
							margin: (BlInsets right: 5));
			addChild: countEditorElement);
		addChild: toolbar
]

{ #category : #initialization }
GtZnClientExceptionRetryElement >> initializeForDebugger: aDebugger fromSourceElement: aSourceElement [
	currentDebugger := aDebugger.
	sourceElement := aSourceElement
]

{ #category : #'instance creation' }
GtZnClientExceptionRetryElement >> initializeForZnClient: aZnClient andDebugger: aDebugger fromSourceElement: aSourceElement [ 
	self initializeForDebugger: aDebugger fromSourceElement: aSourceElement
]

{ #category : #'instance creation' }
GtZnClientExceptionRetryElement >> retryAction: aBlockClosure [ 
	retryAction := aBlockClosure
]

{ #category : #'building widgets' }
GtZnClientExceptionRetryElement >> runRetryAction [
	retryAction 
		cull: countEditorElement text asString trimBoth asNumber
		cull: currentDebugger
]

{ #category : #actions }
GtZnClientExceptionRetryElement >> spawnHelpPageFrom: anElement [
	| helpPage |
	helpPage := LeDatabasesRegistry default defaultLogicalDatabase  
		pageNamed: self helpPageName.
	anElement phlow 
		spawnTool: helpPage asLepiterPagePhlowTool.
	anElement dispatchEvent: BrDropdownHideWish new
]

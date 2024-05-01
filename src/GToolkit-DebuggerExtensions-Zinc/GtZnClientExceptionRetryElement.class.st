Class {
	#name : #GtZnClientExceptionRetryElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'retryAction',
		'playButton',
		'messageEditorElement',
		'countEditorElement',
		'currentDebugger'
	],
	#category : #'GToolkit-DebuggerExtensions-Zinc'
}

{ #category : #'instance creation' }
GtZnClientExceptionRetryElement class >> forZnClient: aZnClient andDebugger: aDebugger [ 
	^ self new 
		initializeForZnClient: aZnClient 
		andDebugger: aDebugger 
]

{ #category : #accessing }
GtZnClientExceptionRetryElement >> actionLabel: aString [ 
	playButton label: aString
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

{ #category : #initialialize }
GtZnClientExceptionRetryElement >> initialize [ 
	super initialize.
	
	self hFitContent.
	self vFitContent.
	self padding: (BlInsets all: 5).
	
	messageEditorElement := self createMessageElement.
	countEditorElement := self createRedirectsCountEditorElement  . 
	playButton := self createPlayButton.
	
	self 
		addChild: messageEditorElement;
		addChild: (BrHorizontalPane new 
			fitContent;
			alignCenter;
			addChild: (self createRedirectCountLabel
				margin: (BlInsets right: 5));
			addChild: countEditorElement);
		addChild: playButton
]

{ #category : #initialization }
GtZnClientExceptionRetryElement >> initializeForZnClient: aZnClient andDebugger: aDebugger [ 
	currentDebugger := aDebugger.
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

Class {
	#name : #GtZnClientTooManyRedirectsRetryElement,
	#superclass : #BrVerticalPane,
	#instVars : [
		'retryAction',
		'playButton',
		'messageEditorElement',
		'countEditorElement'
	],
	#category : #'GToolkit-DebuggerExtensions-Zinc'
}

{ #category : #accessing }
GtZnClientTooManyRedirectsRetryElement >> actionLabel: aString [ 
	playButton label: aString
]

{ #category : #'building widgets' }
GtZnClientTooManyRedirectsRetryElement >> createMessageElement [
	| newEditorElement |
	
	newEditorElement := BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude new .
	
	newEditorElement 
		hExact: 275;
		vFitContent.
	
	^ newEditorElement
]

{ #category : #'building widgets' }
GtZnClientTooManyRedirectsRetryElement >> createPlayButton [
	^ BrButton new
		aptitude: BrGlamorousButtonWithIconAptitude;
		icon: BrGlamorousVectorIcons play;
		action:  [ self runRetryAction ]
]

{ #category : #'building widgets' }
GtZnClientTooManyRedirectsRetryElement >> createRedirectCountLabel [
	^ BrLabel new 
		text: 'Maximum redirect count:';
		aptitude: (BrGlamorousLabelAptitude new 
			foreground: Color gray;
			fontSize: 12)
]

{ #category : #'building widgets' }
GtZnClientTooManyRedirectsRetryElement >> createRedirectsCountEditorElement [
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
GtZnClientTooManyRedirectsRetryElement >> currentMaxNumberOfRedirects: anInteger [ 
	countEditorElement text:  (anInteger * 2) asString.
	messageEditorElement text: (self messageTextForRedirectCount: anInteger)
]

{ #category : #initialialize }
GtZnClientTooManyRedirectsRetryElement >> initialize [ 
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

{ #category : #accessing }
GtZnClientTooManyRedirectsRetryElement >> messageTextForRedirectCount: anInteger [ 
	^ 'Reached the maximum number of {1} {2}. Retry by increasing the value in the ZnClient.' format: {
		anInteger. 
		'redirect' asPluralBasedOn: anInteger}
]

{ #category : #'instance creation' }
GtZnClientTooManyRedirectsRetryElement >> retryAction: aBlockClosure [ 
	retryAction := aBlockClosure
]

{ #category : #'building widgets' }
GtZnClientTooManyRedirectsRetryElement >> runRetryAction [
	retryAction cull: countEditorElement text asString trimBoth asNumber
]

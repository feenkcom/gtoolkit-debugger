Class {
	#name : #GtDebuggerDiffObjectStateComparisonStencil,
	#superclass : #BrStencil,
	#instVars : [
		'fromLabelText',
		'toLabelText',
		'fromValue',
		'toValue'
	],
	#category : #'GToolkit-DebuggerExtensions'
}

{ #category : #'api - instantiation' }
GtDebuggerDiffObjectStateComparisonStencil >> create [
	| headerElement diffContainer |
	
	headerElement := BrHorizontalPane new
		padding: (BlInsets all: 0);
		hMatchParent;
		vFitContent.

	headerElement 
		addChild: self createFromLabel;
		addChild: self createToLabel.
	
	diffContainer := self createDiffContainer.
	
	^ BrVerticalPane new
	 	hMatchParent;
	 	vMatchParent;
	 	addChild: headerElement;
	 	addChild: diffContainer "asScrollableElement"
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> createDiffContainer [
	| diffContainer |
	diffContainer := BrVerticalPane new
		hMatchParent;
		vMatchParent
		"vFitContentLimited".

	diffContainer addChild: self createPanesDiffElement.
	
	^ diffContainer
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> createFromLabel [
	^ BrLabel new 
		aptitude: BrGlamorousLabelAptitude; 
		text: (self fullFromLabelText asRopedText glamorousCodeSmallSize
			foreground: BrGlamorousColors defaultButtonTextColor);
	 	hMatchParent
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> createFromStateElement [
	^ (fromValue gtRawFor: GtPhlowView empty) asElement 
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> createPanesDiffContent [

	| leftElement rightElement |
	leftElement := self createFromStateElement.
	rightElement := self createToStateElement.
	
	leftElement 
		margin: (BlInsets all: 10);
		geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
		border: (BlBorder paint: (Color gray alpha: 0.2) width: 1).
	rightElement 
		margin: (BlInsets all: 10);
		geometry: (BlRoundedRectangleGeometry cornerRadius: 4);
		border: (BlBorder paint: (Color gray alpha: 0.2) width: 1).

	^ BrHorizontalPane new 
		hMatchParent;
		"vFitContentLimited;"
		vMatchParent;
		addChild: leftElement;
		addChild: rightElement;
		yourself
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> createPanesDiffElement [
	| diffWrapper |
	diffWrapper := BrVerticalPane new.	"
	diffWrapper margin: (BlInsets all: 3)."
	diffWrapper hMatchParent.
	diffWrapper vMatchParent.
	"diffWrapper vFitContentLimited."

	diffWrapper addChild: self createPanesDiffContent.

	^ diffWrapper
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> createToLabel [
	^ BrLabel new 
		aptitude: BrGlamorousLabelAptitude;
		text: (self fullToLabelText asRopedText glamorousCodeSmallSize
				foreground: BrGlamorousColors defaultButtonTextColor);
	 	hMatchParent 
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> createToStateElement [
	^ (toValue gtRawFor: GtPhlowView empty) asElement 
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> fromLabelText [
	^ fromLabelText ifNil: [ 
		'From:' ]
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> fromLabelText: aString [
	fromLabelText := aString
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> fullFromLabelText [
	^ self fromLabelText, ' ', (fromValue 
		ifNil: [''] 
		ifNotNil: [ :anObject | anObject gtDisplayString ])
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> fullToLabelText [
	^ self toLabelText, ' ', (toValue 
		ifNil: [''] 
		ifNotNil: [ :anObject | anObject gtDisplayString ])
]

{ #category : #accessing }
GtDebuggerDiffObjectStateComparisonStencil >> toLabelText [
	^ toLabelText ifNil: [ 'To:' ]
]

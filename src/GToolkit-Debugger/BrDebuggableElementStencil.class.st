Class {
	#name : #BrDebuggableElementStencil,
	#superclass : #BrStencil,
	#instVars : [
		'exception'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #'api - instantiation' }
BrDebuggableElementStencil >> create [
	<return: #BlElement>
	| aLabel aButton aContainer |
	aLabel := BrButton new
		hMatchParent;
		label: self newTextLabel;
		aptitude: BrGlamorousLabelAptitude new;
		margin: (BlInsets right: 6);
		constraintsDo: [ :c | 
			c linear vertical alignCenter ];
		action: self newDebugAction.
	aButton := self createDebugButton.
	aContainer := BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal fitContentLimited.
			c vertical fitContent.
			c frame horizontal alignCenter.
			c frame vertical alignCenter ];
		addChildren: {aLabel. aButton}.
	^ BrFrame new
		matchParent;
		addChild: aContainer
]

{ #category : #'api - instantiation' }
BrDebuggableElementStencil >> createDebugButton [
	^ BrButton new
		hFitContent;
		aptitude: BrGlamorousButtonWithIconAptitude new;
		icon: BrGlamorousVectorIcons debug;
		label: 'Open debugger';
		beTinySize;
		constraintsDo: [ :c | 
			c linear vertical alignCenter ];
		action: self newDebugAction
]

{ #category : #accessing }
BrDebuggableElementStencil >> exception [
	^ exception
]

{ #category : #accessing }
BrDebuggableElementStencil >> exception: anException [
	exception := anException
]

{ #category : #accessing }
BrDebuggableElementStencil >> freeze: anException [
	| anExceptionCopy |
	
	anExceptionCopy := anException copy.
	
	anExceptionCopy signalContext
		ifNotNil: [ anExceptionCopy freeze ].
	self exception: anExceptionCopy
]

{ #category : #'instance creation' }
BrDebuggableElementStencil >> newDebugAction [

	^ [ 
	  [ 
	  UIManager default
		  gtDebugProcess: Processor activeProcess
		  context:
		  (self exception signalerContext ifNil: [ 
			   self exception signalContext ])
		  label: self exception description
		  fullView: true
		  notification: nil ] forkNamed: 'Debug' ]
]

{ #category : #'instance creation' }
BrDebuggableElementStencil >> newTextLabel [
	^ self exception printString asRopedText 
		glamorousCodeFontAndSmallSize;
		foreground: BrGlamorousColors linkWithErrorColor
]

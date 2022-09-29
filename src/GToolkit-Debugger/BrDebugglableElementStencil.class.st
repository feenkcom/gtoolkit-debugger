Class {
	#name : #BrDebugglableElementStencil,
	#superclass : #BrStencil,
	#instVars : [
		'exception'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #'api - instantiation' }
BrDebugglableElementStencil >> create [
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
BrDebugglableElementStencil >> createDebugButton [
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
BrDebugglableElementStencil >> exception [
	^ exception
]

{ #category : #accessing }
BrDebugglableElementStencil >> exception: anException [
	exception := anException
]

{ #category : #accessing }
BrDebugglableElementStencil >> freeze: anException [
	| anExceptionCopy |
	
	anExceptionCopy := anException copy.
	
	anExceptionCopy signalContext
		ifNotNil: [ anExceptionCopy freeze ].
	self exception: anExceptionCopy
]

{ #category : #'instance creation' }
BrDebugglableElementStencil >> newDebugAction [

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
BrDebugglableElementStencil >> newTextLabel [
	^ self exception printString asRopedText 
		glamorousCodeFontAndSmallSize;
		foreground: BrGlamorousColors linkWithErrorColor
]

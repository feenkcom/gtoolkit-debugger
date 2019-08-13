Class {
	#name : #GtMoldableDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggerElement',
		'debuggerContainer',
		'buttonsContainer'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #'building widgets' }
GtMoldableDebuggerElement >> actOnButtonSelected: aButtonElement forDebuggerOfType: aDebuggerClass [
	| newDebuggerElement |
	newDebuggerElement := self switchFrom: debuggerElement toDebuggerType: aDebuggerClass.
	self updateDebuggerElement: newDebuggerElement
	
]

{ #category : #'building widgets' }
GtMoldableDebuggerElement >> createButtonForSwitchingTo: aDebuggerClass [
	^ BrButton new
		look: BrGlamorousButtonWithLabelLook;
		label: aDebuggerClass defaultTitle;
		action: [ :buttonElement |
			self actOnButtonSelected: buttonElement forDebuggerOfType: aDebuggerClass ]
		
]

{ #category : #'building widgets' }
GtMoldableDebuggerElement >> createButtonsContainer [
	| container |
	container := BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent.
			c margin: (BlInsets top: -15 left: 0 bottom: 0 right: -10).
			c ignoreByLayout.
			c ignored horizontal alignCenter.
			c ignored vertical alignTop ].
	^ container
]

{ #category : #initialization }
GtMoldableDebuggerElement >> initialize [
	super initialize.
	self 
		layout: BlFrameLayout new;
		constraintsDo: [:c | 
			c horizontal matchParent.
			c vertical matchParent ];
		clipChildren: false.
	debuggerContainer := BlElement new
	 	layout: BlFrameLayout new;
		clipChildren: false;
		constraintsDo: [ :c |
			c margin: (BlInsets top: 20).
			c horizontal matchParent.
			c vertical matchParent ].
	buttonsContainer := self createButtonsContainer.
	debuggerContainer addChild: buttonsContainer.
	self addChild: debuggerContainer.
]

{ #category : #'adding elements' }
GtMoldableDebuggerElement >> initializeForSession: aDebuggingSession [
	| availableDebuggerTypes |
	"availableDebuggers := (Smalltalk tools debuggersForContext: aDebugggingSession interruptedContext) reversed."
	availableDebuggerTypes := { GtExpandableDebuggerElement . GtBytecodeDebugger . GtStackDebuggerElement }.
	availableDebuggerTypes ifNotEmpty: [ 
		self updateDebuggerElement: (availableDebuggerTypes first on: aDebuggingSession) ].
	(availableDebuggerTypes size >= 2) ifTrue: [ 
		availableDebuggerTypes copyWithoutFirst do: [ :aDebuggerClass |
			| switchButton |
			switchButton := self createButtonForSwitchingTo: aDebuggerClass.
	 		buttonsContainer addChild: switchButton ] ]
	
]

{ #category : #actions }
GtMoldableDebuggerElement >> switchFrom: currentDebugger toDebuggerType: aDebuggerClass [
	| currentSession newDebugger |
	
	currentSession := currentDebugger session.
	currentDebugger detachSession.
	newDebugger := aDebuggerClass on: (aDebuggerClass spanNewSessionFrom: currentSession).	
	^ newDebugger
]

{ #category : #private }
GtMoldableDebuggerElement >> updateDebuggerElement: aNewDebuggerElement [
	| previousDebuggerElement |
	previousDebuggerElement := debuggerElement.
	debuggerElement := aNewDebuggerElement.
	
	previousDebuggerElement ifNotNil: [ 
		debuggerContainer removeChild: previousDebuggerElement ].
	debuggerContainer addChildFirst: debuggerElement
]

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
	(debuggerElement notNil and: [ aDebuggerClass = debuggerElement class]) ifTrue: [
		"If selected debugger is already active do not switch to it again"
		^ self ].
	
	
	
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
			c linear horizontal alignCenter.].
		"constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent.
			c ignoreByLayout.
			c margin: (BlInsets top: -15 left: 0 bottom: 0 right: -10).
			c ignored horizontal alignCenter.
			c ignored vertical alignTop ]."
	^ container
]

{ #category : #'building widgets' }
GtMoldableDebuggerElement >> createSwitchButtonWithLabel: aLabel [
	^ GtInspectorConnectorSwitchStencil new asElement
			label: aLabel;
			constraintsDo: [ :c |
				c ignoreByLayout.
				c margin: (BlInsets top: -15 left: 0 bottom: 0 right: -10).
				c ignored horizontal alignCenter.
				c ignored vertical alignTop ]
]

{ #category : #initialization }
GtMoldableDebuggerElement >> initialize [
	super initialize.
	self 
		layout: BlLinearLayout vertical;
		constraintsDo: [:c | 
			"c padding: (BlInsets top: 0)."
			c horizontal matchParent.
			c vertical matchParent ];
		clipChildren: false.
	debuggerContainer := BlElement new
	 	layout: BlFrameLayout new;
		background: Color green;
		clipChildren: false;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	buttonsContainer := self createButtonsContainer.
	self addChild: buttonsContainer.
	self addChild: debuggerContainer.
	
	"Hardcode the two buttons here for now."
	"genericDebuggerButton := self createSwitchButtonWithLabel: 'Generic'.
	bytecodeDebuggerButton := self createSwitchButtonWithLabel: 'Bytecode'.
	genericDebuggerButton action: [ |currentSession|
		genericDebugger := self switchFrom: bytecodeDebugger toDebuggerType: GtStackDebuggerElement.
			
		debuggerContainer removeChildren.		
		debuggerContainer addChild: genericDebugger. 
		debuggerContainer addChild: bytecodeDebuggerButton 
	].
	bytecodeDebuggerButton action: [ |currentSession|
		bytecodeDebugger := self switchFrom: genericDebugger toDebuggerType: GtBytecodeDebugger.
		
		debuggerContainer removeChildren.		
		debuggerContainer addChild: bytecodeDebugger. 
		debuggerContainer addChild: genericDebuggerButton]."
]

{ #category : #'adding elements' }
GtMoldableDebuggerElement >> initializeForSession: aDebugggingSession [
	| availableDebuggers |
	availableDebuggers := (Smalltalk tools debuggersForContext: aDebugggingSession interruptedContext) reversed.
	availableDebuggers 
		do: [ :aDebuggerClass |
			| switchButton |
			switchButton := self createButtonForSwitchingTo: aDebuggerClass.
		 	buttonsContainer addChild: switchButton ].
	availableDebuggers ifNotEmpty: [ 
		debuggerElement := availableDebuggers first on: aDebugggingSession.
		debuggerContainer removeChildren.
		debuggerContainer addChild: debuggerElement ]
]

{ #category : #actions }
GtMoldableDebuggerElement >> switchFrom: currentDebugger toDebuggerType: aDebuggerClass [
	| currentSession newDebugger |
	
	currentSession := currentDebugger session.
	currentDebugger detachSession.
	newDebugger := aDebuggerClass new
		session: (aDebuggerClass spanNewSessionFrom: currentSession).	
	^ newDebugger
]

{ #category : #actions }
GtMoldableDebuggerElement >> switchToDebuggerType: aDebuggerClass [
	| currentSession newDebugger |
	
	currentSession := self session.
	self detachSession.
	self browser close.
	currentSession updateContextTo: nil.
	newDebugger := aDebuggerClass new
		session: (aDebuggerClass spanNewSessionFrom: currentSession).
	
		
]

Class {
	#name : #GtDebuggerSwitcher,
	#superclass : #BlElement,
	#instVars : [
		'debuggerContainer',
		'genericDebugger',
		'bytecodeDebugger',
		'genericDebuggerButton',
		'bytecodeDebuggerButton'
	],
	#category : 'GToolkit-Debugger'
}

{ #category : #'adding elements' }
GtDebuggerSwitcher >> addGenericDebugger: aGenericDebugger [
	genericDebugger := aGenericDebugger.
	debuggerContainer addChild: genericDebugger.
	debuggerContainer addChild: bytecodeDebuggerButton.			
]

{ #category : #'building widgets' }
GtDebuggerSwitcher >> createSwitchButtonWithLabel: aLabel [
	^ GtInspectorConnectorSwitchStencil new asElement
			label: aLabel;
			constraintsDo: [ :c |
				c ignoreByLayout.
				c margin: (BlInsets top: -15 left: 0 bottom: 0 right: -10).
				c ignored horizontal alignCenter.
				c ignored vertical alignTop ]
]

{ #category : #initialization }
GtDebuggerSwitcher >> initialize [
	super initialize.
	self 
		layout: BlFrameLayout new;
		constraintsDo: [:c | 
			c padding: (BlInsets top: 0)];
		clipChildren: false.
	debuggerContainer := BlElement new
	 	layout: BlFrameLayout new;
		background: Color white;
		clipChildren: false;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: debuggerContainer.
	
	"Hardcode the two buttons here for now."
	genericDebuggerButton := self createSwitchButtonWithLabel: 'Generic'.
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
		debuggerContainer addChild: genericDebuggerButton].
]

{ #category : #actions }
GtDebuggerSwitcher >> switchFrom: currentDebugger toDebuggerType: aDebuggerClass [
	| currentSession newDebugger |
	
	currentSession := currentDebugger session.
	currentDebugger detachSession.
	newDebugger := aDebuggerClass new
		session: (aDebuggerClass spanNewSessionFrom: currentSession).	
	^ newDebugger
]

{ #category : #actions }
GtDebuggerSwitcher >> switchToDebuggerType: aDebuggerClass [
	| currentSession newDebugger |
	
	currentSession := self session.
	self detachSession.
	self browser close.
	currentSession updateContextTo: nil.
	newDebugger := aDebuggerClass new
		session: (aDebuggerClass spanNewSessionFrom: currentSession).
	
		
]

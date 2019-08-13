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

{ #category : #'instance creation' }
GtMoldableDebuggerElement class >> on: aDebugSession [
	^ self new 
		initializeForSession: aDebugSession
]

{ #category : #opening }
GtMoldableDebuggerElement class >> openInspectorOn: aDebuggingSession [
	| aDebugger |

	aDebugger := self on: aDebuggingSession.
	^ aDebugger openInInspector
]

{ #category : #opening }
GtMoldableDebuggerElement class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	| aDebugger |

	aDebugger := self on: aDebugSession.
	^ aDebugger openWithFullView
]

{ #category : #callbacks }
GtMoldableDebuggerElement >> actOnButtonSelected: aButtonElement forDebuggerOfType: aDebuggerClass [
	| newDebuggerElement |
	newDebuggerElement := self switchFrom: debuggerElement toDebuggerType: aDebuggerClass.
	self updateSwitchButtonsFor: newDebuggerElement.
	self updateDebuggerElement: newDebuggerElement.
	
]

{ #category : #accessing }
GtMoldableDebuggerElement >> availableDebuggerTypesForContext: aContext excluding: aDebuggerType [ 
	^ ((Smalltalk tools debuggersForContext: aContext)
			select: [ :aDebuggerClass | aDebuggerClass inheritsFrom: GtDebuggerElement ]) reverse
		remove: aDebuggerType ifAbsent: [ ];
		yourself
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

{ #category : #initialization }
GtMoldableDebuggerElement >> initializeForSession: aDebuggingSession [
	| newDebuggerElement |
	newDebuggerElement := GtExpandableDebuggerElement on: aDebuggingSession.
	self updateSwitchButtonsFor: newDebuggerElement.
	self updateDebuggerElement: newDebuggerElement.
]

{ #category : #opening }
GtMoldableDebuggerElement >> openInInspector [
	| anInspector aSpace |
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	anInspector := GtInspector new.
	anInspector
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	anInspector addPageWithContent: self for: debuggerElement session.
	
	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: debuggerElement session name.
	aSpace extent: 1200 @ 600.
	aSpace addChild: anInspector.
	aSpace show
]

{ #category : #opening }
GtMoldableDebuggerElement >> openWithFullView [
	self openInInspector
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

{ #category : #initialization }
GtMoldableDebuggerElement >> updateSwitchButtonsFor: newDebuggerElement [
	| availableDebuggerTypes |
	availableDebuggerTypes := self 
		availableDebuggerTypesForContext: newDebuggerElement session interruptedContext 
		excluding: newDebuggerElement class.
	
	buttonsContainer removeChildren.
	availableDebuggerTypes do: [ :aDebuggerClass |
		| switchButton |
		switchButton := self createButtonForSwitchingTo: aDebuggerClass.
		buttonsContainer addChild: switchButton ]
]

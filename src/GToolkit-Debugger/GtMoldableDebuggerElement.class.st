Class {
	#name : #GtMoldableDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggerElement',
		'debuggerContainer',
		'buttonsContainer'
	],
	#classVars : [
		'AlwaysOpenFullDebugger',
		'ErrorRecursion',
		'FilterCommonMessageSends',
		'LogDebuggerStackToFile',
		'LogFileName'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> alwaysOpenFullDebugger [
	^ AlwaysOpenFullDebugger ifNil: [AlwaysOpenFullDebugger := false]
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> alwaysOpenFullDebugger: aBoolean [
	AlwaysOpenFullDebugger := aBoolean.
]

{ #category : #'utilities api' }
GtMoldableDebuggerElement class >> closeAllDebuggers [
	self flag: 'Take the new GT debuggers into account'.
	(SystemWindow allSubInstances select: [:w | 
		 w model isKindOf: GTGenericStackDebugger])
			do: [:w | w delete ].
	GTSpecPreDebugWindow allInstances do: #delete.
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> defaultLogFileName [
	^ 'PharoDebug.log'
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> filterCommonMessageSends [
	self flag: 'horrible hack not to break the setting browser'.
	^ false
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> filterCommonMessageSends: aBoolean [
	FilterCommonMessageSends := aBoolean
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> filterDoItSelectors [
	^ false
]

{ #category : #'accessing - ancient preference selectors' }
GtMoldableDebuggerElement class >> filterDoItSelectors: aBoolean [
	self flag: 'just for backward compatibility'
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> filterKernelClasses [
	^ false
]

{ #category : #'accessing - ancient preference selectors' }
GtMoldableDebuggerElement class >> filterKernelClasses: aBoolean [
	self flag: 'just for backward compatibility'
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> filterLinkSelectors [
	^ false
]

{ #category : #'accessing - ancient preference selectors' }
GtMoldableDebuggerElement class >> filterLinkSelectors: aBoolean [ 
	self flag: 'just for backward compatibility'
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> filterNilSelectors [
	^ false
]

{ #category : #'accessing - ancient preference selectors' }
GtMoldableDebuggerElement class >> filterNilSelectors: aBoolean [ 
	self flag: 'just for backward compatibility'
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> logDebuggerStackToFile [
	^ LogDebuggerStackToFile ifNil: [LogDebuggerStackToFile := true]
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> logDebuggerStackToFile: aBoolean [
	 LogDebuggerStackToFile := aBoolean
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> logFileName [
	^ LogFileName ifNil: [ self defaultLogFileName ] 
]

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

{ #category : #'opening api' }
GtMoldableDebuggerElement class >> openOn: aDebugSession withFullView: aBool [
	self openOn: aDebugSession withFullView: aBool andNotification: nil
]

{ #category : #opening }
GtMoldableDebuggerElement class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	| aDebugger |

	aDebugger := self on: aDebugSession.
	^ aDebugger openWithFullView
]

{ #category : #'tools registry' }
GtMoldableDebuggerElement class >> register [
	self registerToolsOn: Smalltalk tools.
]

{ #category : #'tools registry' }
GtMoldableDebuggerElement class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry register: self as: #debugger.
]

{ #category : #'settings api' }
GtMoldableDebuggerElement class >> stackWidgetClass [
	self flag: 'horrible hack not to break the setting browser'.
	^ self
]

{ #category : #icons }
GtMoldableDebuggerElement class >> taskbarIconName [
	^ #smallDebugIcon
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
		background: Color white;
		look: BrGlamorousButtonWithLabelLook  + BrShadowLook new;
		geometry: (BlRectangle cornerRadius: 10);
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

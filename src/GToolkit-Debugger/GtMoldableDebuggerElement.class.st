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
	^ self openOn: aDebugSession withFullView: aBool andNotification: nil
]

{ #category : #opening }
GtMoldableDebuggerElement class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	| aDebugger |

	aDebugger := self on: aDebugSession.
	^ aDebugger openInInspector
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

{ #category : #opening }
GtMoldableDebuggerElement >> aboutToOpen [
	self currentDebugger aboutToOpen
]

{ #category : #callbacks }
GtMoldableDebuggerElement >> actOnButtonSelected: aButtonElement forDebuggerOfType: aDebuggerClass [
	| newDebuggerElement |
	newDebuggerElement := self switchFrom: debuggerElement toDebuggerType: aDebuggerClass.
	self updateSwitchButtonsExcluding: newDebuggerElement.
	self updateDebuggerElement: newDebuggerElement.
	
]

{ #category : #callbacks }
GtMoldableDebuggerElement >> actOnDebugActionExecuted [
	self currentDebugger session ifNotNil: [ :aDebuggingSession | 
		aDebuggingSession interruptedContext ifNotNil: [ 
			self updateSwitchButtonsExcluding: self currentDebugger ] ]
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
		beSmall;
		background: Color white;
		look: BrGlamorousButtonRectangularLook new +
			BrGlamorousButtonLabelLook new + 
			BrShadowLook;
		geometry: (BlRectangle cornerRadius: 10);
		margin: (BlInsets left: 5);
		label: aDebuggerClass defaultTitle;
		when: BlMouseEnterEvent do: [ :anEvent | anEvent currentTarget background: Color veryVeryLightGray lighter ];
		when: BlMouseLeaveEvent do: [ :anEvent | anEvent currentTarget background: Color white ];
		action: [ :buttonElement |
			self actOnButtonSelected: buttonElement forDebuggerOfType: aDebuggerClass ]
		
]

{ #category : #'building widgets' }
GtMoldableDebuggerElement >> createButtonsContainer [
	| container |
	container := BlElement new
		layout: BlLinearLayout horizontal;
		clipChildren: false;
		constraintsDo: [ :c |
			c horizontal fitContent.
			c vertical fitContent.
			c margin: (BlInsets top: -10 left: 0 bottom: 0 right: -10).
			c ignoreByLayout.
			c ignored horizontal alignCenter.
			c ignored vertical alignTop ].
	^ container
]

{ #category : #accessing }
GtMoldableDebuggerElement >> currentDebugger [
	^ debuggerElement
]

{ #category : #accessing }
GtMoldableDebuggerElement >> inInspector [
	^ (GtPager createWrappedOn: self) maximized
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
	newDebuggerElement := self selectInitialDebuggerFor: aDebuggingSession.
	self updateSwitchButtonsExcluding: newDebuggerElement.
	self updateDebuggerElement: newDebuggerElement.
]

{ #category : #opening }
GtMoldableDebuggerElement >> open: anElement titled: aTitleString [
	| aSpace |
	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aTitleString.
	aSpace extent: 1200 @ 600.
	aSpace addChild: anElement.
	aSpace show
]

{ #category : #opening }
GtMoldableDebuggerElement >> openInInspector [
	| anInspector |
	self aboutToOpen.
	anInspector := self inInspector.
	self open: anInspector titled: debuggerElement session name.
]

{ #category : #initialization }
GtMoldableDebuggerElement >> selectInitialDebuggerFor: aDebugSession [ 
	| debuggerClass initialDebugger |
	debuggerClass := Smalltalk tools 
		debuggerDispatcherFor: aDebugSession interruptedContext
		matching: [ :aDebuggerClass | 
			"Only take into account GT debuggers."
			(aDebuggerClass includesBehavior: GtDebuggerElement) and: [ 
				aDebuggerClass availableAutomatically ] ].
	initialDebugger := debuggerClass
		ifNil: [ 
			"Use the main debugger"
			GtExpandableDebuggerElement on: aDebugSession ]
		ifNotNil: [ :aDebugger | 
			"Use a custom extension"
			aDebugger on: (aDebugger spanNewSessionFrom: aDebugSession) ].
	^ initialDebugger
]

{ #category : #private }
GtMoldableDebuggerElement >> subscribeToDebuggingEventsFor: aDebuggerElement [
	aDebuggerElement announcer 
		when: DebugActionExecuted 
		send: #actOnDebugActionExecuted 
		to: self
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
GtMoldableDebuggerElement >> unsubscribeFromDebuggingEventsFor: aDebuggerElement [
	aDebuggerElement announcer unsubscribe: self.
]

{ #category : #private }
GtMoldableDebuggerElement >> updateDebuggerElement: aNewDebuggerElement [
	| previousDebuggerElement |
	previousDebuggerElement := debuggerElement.
	debuggerElement := aNewDebuggerElement.
	
	previousDebuggerElement ifNotNil: [ 
		debuggerContainer removeChild: previousDebuggerElement.
		self unsubscribeFromDebuggingEventsFor: previousDebuggerElement ].
	debuggerContainer addChildFirst: debuggerElement.
	self subscribeToDebuggingEventsFor: debuggerElement.
]

{ #category : #private }
GtMoldableDebuggerElement >> updateSwitchButtonsExcluding: aDebuggerElement [
	| availableDebuggerTypes |
	availableDebuggerTypes := self 
		availableDebuggerTypesForContext: aDebuggerElement session interruptedContext 
		excluding: aDebuggerElement class.
	
	buttonsContainer removeChildren.
	availableDebuggerTypes do: [ :aDebuggerClass |
		| switchButton |
		switchButton := self createButtonForSwitchingTo: aDebuggerClass.
		buttonsContainer addChild: switchButton ]
]

Class {
	#name : #GtMoldableDebugger,
	#superclass : #BlElement,
	#traits : 'TGtPhlowToolDetailAdjustable',
	#classTraits : 'TGtPhlowToolDetailAdjustable classTrait',
	#instVars : [
		'debuggerElement',
		'debuggerContainer',
		'buttonsContainer'
	],
	#classVars : [
		'AlwaysOpenFullDebugger',
		'ErrorRecursion',
		'LogDebuggerStackToFile',
		'LogFileName'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #'settings api' }
GtMoldableDebugger class >> alwaysOpenFullDebugger [
	^ AlwaysOpenFullDebugger ifNil: [AlwaysOpenFullDebugger := false]
]

{ #category : #'settings api' }
GtMoldableDebugger class >> alwaysOpenFullDebugger: aBoolean [
	AlwaysOpenFullDebugger := aBoolean.
]

{ #category : #'utilities api' }
GtMoldableDebugger class >> closeAllDebuggers [
	self flag: 'Take the new GT debuggers into account'.
]

{ #category : #'settings api' }
GtMoldableDebugger class >> defaultLogFileName [
	^ 'PharoDebug.log'
]

{ #category : #'settings api' }
GtMoldableDebugger class >> logDebuggerStackToFile [
	^ LogDebuggerStackToFile ifNil: [LogDebuggerStackToFile := true]
]

{ #category : #'settings api' }
GtMoldableDebugger class >> logDebuggerStackToFile: aBoolean [
	 LogDebuggerStackToFile := aBoolean
]

{ #category : #'settings api' }
GtMoldableDebugger class >> logFileName [
	^ LogFileName ifNil: [ self defaultLogFileName ] 
]

{ #category : #accessing }
GtMoldableDebugger class >> logFileName: newName [

	LogFileName := newName
]

{ #category : #'instance creation' }
GtMoldableDebugger class >> on: aDebugSession [
	^ self new 
		initializeForSession: aDebugSession
]

{ #category : #opening }
GtMoldableDebugger class >> openInspectorOn: aDebuggingSession [
	| aDebugger |

	aDebugger := self on: aDebuggingSession.
	^ aDebugger openInPager
]

{ #category : #'opening api' }
GtMoldableDebugger class >> openOn: aDebugSession withFullView: aBool [
	^ self openOn: aDebugSession withFullView: aBool andNotification: nil
]

{ #category : #opening }
GtMoldableDebugger class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	| aDebugger |

	aDebugger := self on: aDebugSession.
	^ aDebugger openInPager
]

{ #category : #'tools registry' }
GtMoldableDebugger class >> register [
	self registerToolsOn: Smalltalk tools.
]

{ #category : #'tools registry' }
GtMoldableDebugger class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry register: self as: #debugger.
]

{ #category : #'settings api' }
GtMoldableDebugger class >> stackWidgetClass [
	self flag: 'horrible hack not to break the setting browser'.
	^ self
]

{ #category : #icons }
GtMoldableDebugger class >> taskbarIconName [
	^ #smallDebugIcon
]

{ #category : #opening }
GtMoldableDebugger >> aboutToOpen [
	self currentDebugger aboutToOpen
]

{ #category : #callbacks }
GtMoldableDebugger >> actOnButtonSelected: aButtonElement forDebuggerOfType: aDebuggerClass [
	| newDebuggerElement |
	newDebuggerElement := self switchFrom: debuggerElement toDebuggerType: aDebuggerClass.
	self updateSwitchButtonsExcluding: newDebuggerElement.
	self updateDebuggerElement: newDebuggerElement.
]

{ #category : #callbacks }
GtMoldableDebugger >> actOnDebugActionExecuted [
	self currentDebugger session ifNotNil: [ :aDebuggingSession | 
		aDebuggingSession interruptedContext ifNotNil: [ 
			self updateSwitchButtonsExcluding: self currentDebugger ].
		self currentDebugger actOnDebugActionExecuted. ]
]

{ #category : #accessing }
GtMoldableDebugger >> availableDebuggerTypesForDebugSession: aDebugSession excluding: aDebuggerType [ 
	^ ((Smalltalk tools debuggersForDebugSession: aDebugSession)
			select: [ :aDebuggerClass | aDebuggerClass inheritsFrom: GtDebuggerElement ]) reverse
		remove: aDebuggerType ifAbsent: [ ];
		yourself
]

{ #category : #'building widgets' }
GtMoldableDebugger >> createButtonForSwitchingTo: aDebuggerClass [
	^ BrButton new
		beSmallSize;
		background: Color white;
		aptitude: BrGlamorousButtonRectangularAptitude new +
			BrGlamorousButtonLabelAptitude new + 
			BrShadowAptitude;
		geometry: (BlRoundedRectangleGeometry cornerRadius: 10);
		margin: (BlInsets left: 5);
		label: aDebuggerClass defaultTitle;
		when: BlMouseEnterEvent do: [ :anEvent | anEvent currentTarget background: Color veryVeryLightGray lighter ];
		when: BlMouseLeaveEvent do: [ :anEvent | anEvent currentTarget background: Color white ];
		action: [ :buttonElement |
			self 
				actOnButtonSelected: buttonElement 
				forDebuggerOfType: aDebuggerClass ]
]

{ #category : #'building widgets' }
GtMoldableDebugger >> createButtonsContainer [
	| container |
	container := BlElement new
		id: GtMoldableDebuggerSwitchButtonsContainerElementId;
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
GtMoldableDebugger >> currentDebugger [
	^ debuggerElement
]

{ #category : #accessing }
GtMoldableDebugger >> debugSession [
	^ self currentDebugger debugSession
]

{ #category : #accessing }
GtMoldableDebugger >> inPager [
	^ (GtPager createWrappedOn: self) maximized
]

{ #category : #initialization }
GtMoldableDebugger >> initialize [
	super initialize.
	
	self 
		id: GtMoldableDebuggerMainElementId;
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
GtMoldableDebugger >> initializeForSession: aDebuggingSession [
	| newDebuggerElement |
	newDebuggerElement := self selectInitialDebuggerFor: aDebuggingSession.
	self updateSwitchButtonsExcluding: newDebuggerElement.
	self updateDebuggerElement: newDebuggerElement.
]

{ #category : #opening }
GtMoldableDebugger >> open: anElement titled: aTitleString [
	| aSpace |
	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace withSceneDriller.
	aSpace withScreenshotHandler.
	aSpace title: aTitleString.
	aSpace extent: 1200 @ 600.
	aSpace addChild: anElement.
	aSpace show
]

{ #category : #opening }
GtMoldableDebugger >> openInPager [
	| aPager |
	self aboutToOpen.
	aPager := self inPager.
	self open: aPager titled: debuggerElement session name.
]

{ #category : #initialization }
GtMoldableDebugger >> selectInitialDebuggerFor: aDebugSession [ 
	| debuggerClass initialDebugger |
	debuggerClass := Smalltalk tools 
		debuggerDispatcherForDebugSession: aDebugSession
		matching: [ :aDebuggerClass | 
			"Only take into account GT debuggers."
			(aDebuggerClass includesBehavior: GtDebuggerElement) and: [ 
				aDebuggerClass availableAutomatically ] ].
	initialDebugger := (debuggerClass ifNil: [ GtPharoDebuggerElement ])
			ifNotNil: [ :aDebugger | aDebugger on: (aDebugger spanNewSessionFrom: aDebugSession) ].
	^ initialDebugger
]

{ #category : #private }
GtMoldableDebugger >> subscribeToDebuggingEventsFor: aDebuggerElement [
	aDebuggerElement announcer 
		when: DebugActionExecuted 
		send: #actOnDebugActionExecuted 
		to: self
]

{ #category : #actions }
GtMoldableDebugger >> switchFrom: currentDebugger toDebuggerType: aDebuggerClass [
	| currentSession newDebugger |
	
	currentSession := currentDebugger session.
	currentDebugger detachSession.
	newDebugger := aDebuggerClass on: (aDebuggerClass spanNewSessionFrom: currentSession).	
	^ newDebugger
]

{ #category : #private }
GtMoldableDebugger >> unsubscribeFromDebuggingEventsFor: aDebuggerElement [
	aDebuggerElement announcer unsubscribe: self.
]

{ #category : #private }
GtMoldableDebugger >> updateDebuggerElement: aNewDebuggerElement [
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
GtMoldableDebugger >> updateSwitchButtonsExcluding: aDebuggerElement [
	| availableDebuggerTypes |
	availableDebuggerTypes := self 
		availableDebuggerTypesForDebugSession: aDebuggerElement session 
		excluding: aDebuggerElement class.
	
	buttonsContainer removeChildren.
	availableDebuggerTypes do: [ :aDebuggerClass |
		| switchButton |
		switchButton := self createButtonForSwitchingTo: aDebuggerClass.
		buttonsContainer addChild: switchButton ]
]

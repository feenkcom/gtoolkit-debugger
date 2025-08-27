Class {
	#name : #GtMoldableDebugger,
	#superclass : #BlElement,
	#traits : 'TGtPhlowToolDetailAdjustable',
	#classTraits : 'TGtPhlowToolDetailAdjustable classTrait',
	#instVars : [
		'debuggerElement',
		'debuggerContainer',
		'buttonsContainer',
		'isSwitchingEnabled'
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

{ #category : #accessing }
GtMoldableDebugger class >> defaultFutureExecutionConfiguration [
	^ AsyncFutureExecutionConfiguration new
		highPriority;
		customGroup: #DebuggerScrollingList
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
GtMoldableDebugger >> actOnButtonSelectedForDebuggerSpecification: aDebuggerSpecification [
	| newDebuggerElement |
	newDebuggerElement := self 
		switchFrom: debuggerElement 
		toDebuggerSpecification: aDebuggerSpecification.
	self updateDebuggerElement: newDebuggerElement.
]

{ #category : #callbacks }
GtMoldableDebugger >> actOnDebugActionExecuted [
	self currentDebugger session ifNotNil: [ :aDebuggingSession | 
		aDebuggingSession interruptedContext ifNotNil: [ 
			self updateSwitchButtonsForCurrentDebuggerElement: self currentDebugger ].
		self currentDebugger actOnDebugActionExecuted. ]
]

{ #category : #'initialization - debuggers' }
GtMoldableDebugger >> availableDebuggerTypesForDebugSession: aDebugSession [
	^ ((Smalltalk tools debuggersForDebugSession: aDebugSession)
			select: [ :aDebuggerClass | 
				aDebuggerClass inheritsFrom: GtDebuggerElement ]) 
		yourself
]

{ #category : #'building widgets' }
GtMoldableDebugger >> createButtonForSwitchingTo: aDebuggerSpecification [
	^ BrTab new
		aptitude: BrGlamorousTabSwitcherWithLabelAndIconAptitude new ;
		icon: aDebuggerSpecification icon;
		label: aDebuggerSpecification title;
		stencil: [ BrFrame new fitContent ];
		in: [ :aTab |
			aTab userData 
				at: #debuggerSpecification
				put: aDebuggerSpecification.
			aTab ]
]

{ #category : #'building widgets' }
GtMoldableDebugger >> createButtonsContainer [
	| container |
	container := BrTabGroup new
		fitContent;
		id: #'Composite Tool';
		aptitude: BrGlamorousTabGroupSwitcherAptitude;
		id: GtMoldableDebuggerSwitchButtonsContainerElementId;
		constraintsDo: [ :c |
			c ignoreByLayout.
			c ignored horizontal alignCenter.
			c ignored vertical alignTop ].
	container 
		when: BrTabSelectedEvent do: [ :anEvent | 
			(debuggerElement notNil and: [self isSwitchingEnabled]) ifTrue: [
				self 
					actOnButtonSelectedForDebuggerSpecification: (anEvent tab widget
						userData at: #debuggerSpecification) ] ] .
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
GtMoldableDebugger >> enableDebuggerSwitching [
	isSwitchingEnabled := true
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
	
	self phlow 
		accessTool: (GtPhlowToolClassType forClass: self class) 
		viewModel: #debugSession 
		object: #debugSession.
]

{ #category : #initialization }
GtMoldableDebugger >> initializeForSession: aDebuggingSession [
	| newDebuggerElement |
	newDebuggerElement := self selectInitialDebuggerFor: aDebuggingSession.
	self updateSwitchButtonsForCurrentDebuggerElement: newDebuggerElement.
	self updateDebuggerElement: newDebuggerElement.
	
	self enableDebuggerSwitching.
]

{ #category : #testing }
GtMoldableDebugger >> isSwitchingEnabled [
	^ isSwitchingEnabled ifNil: [ false ]
]

{ #category : #opening }
GtMoldableDebugger >> openInPager [
	| aSpace |
	self aboutToOpen.
	aSpace := BlSpace new
			withCommonSettings;
			title: debuggerElement session name;
			extent: 1200 @ 600.
	GtPagerSettings isAllowedForDebugTools
		ifTrue: [ aSpace inPager: self ]
		ifFalse: [ aSpace addChild: self inPager ].
	aSpace show
]

{ #category : #'initialization - debuggers' }
GtMoldableDebugger >> selectInitialDebuggerFor: aDebugSession [ 
	| automaticallyAvailableSpecifications debuggerSpecification |
	
	automaticallyAvailableSpecifications := aDebugSession 
		applicableDebuggerSpecifications 
			select: [ :aDebuggerSpecification | 
				aDebuggerSpecification availableAutomatically ].
		
	debuggerSpecification := automaticallyAvailableSpecifications 
		ifEmpty: [ 
			"In case something went wrong and we cannot find a specification"
			GtPharoDebuggerElement debuggerSpecification ]
		ifNotEmpty: [ :aCollection | aCollection first  ].
		
	^ debuggerSpecification createDebuggerStartingFrom: aDebugSession.
]

{ #category : #'initialization - debuggers' }
GtMoldableDebugger >> selectInitialDebuggerTypeFor: aDebugSession [ 
	| debuggerClass |
	debuggerClass := Smalltalk tools 
		debuggerDispatcherForDebugSession: aDebugSession
		matching: [ :aDebuggerClass | 
			"Only take into account GT debuggers."
			(aDebuggerClass includesBehavior: GtDebuggerElement) and: [ 
				aDebuggerClass availableAutomatically ] ].
	^debuggerClass ifNil: [ GtPharoDebuggerElement ]
]

{ #category : #private }
GtMoldableDebugger >> subscribeToDebuggingEventsFor: aDebuggerElement [
	aDebuggerElement announcer 
		when: DebugActionExecuted 
		send: #actOnDebugActionExecuted 
		to: self
]

{ #category : #actions }
GtMoldableDebugger >> switchFrom: currentDebugger toDebuggerSpecification: aDebuggerSpecification [
	| currentSession newDebugger |
	
	currentSession := currentDebugger session.
	currentDebugger detachSession.
	newDebugger := aDebuggerSpecification createDebuggerStartingFrom:  currentSession.	
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
GtMoldableDebugger >> updateSwitchButtonsForCurrentDebuggerElement: aDebuggerElement [
	| applicableDebuggerSpecifications |
	
	applicableDebuggerSpecifications := aDebuggerElement session
		applicableDebuggerSpecifications.
	
	self withTabSwitchingDisabledDo: [
		buttonsContainer tabs copy do: [ :aTab |
			buttonsContainer viewModel 
				removeTab: aTab ].
		
		applicableDebuggerSpecifications size > 1 ifFalse: [ 
			"We only show the toolbar for changing the debugger in case we have more then one debugger"
			^ self ].
	
		applicableDebuggerSpecifications do: [ :aDebuggerSpecification |
			| switchTab |
			switchTab := self createButtonForSwitchingTo: aDebuggerSpecification.
			buttonsContainer addTab: switchTab.
			
			aDebuggerSpecification debuggerClass = aDebuggerElement class ifTrue: [
				switchTab select ] ] ]
]

{ #category : #private }
GtMoldableDebugger >> withTabSwitchingDisabledDo: aBlockClosure [ 
	| previousState |
	previousState := isSwitchingEnabled.
	isSwitchingEnabled := false.
	^ aBlockClosure ensure: [
		isSwitchingEnabled := previousState ]
]

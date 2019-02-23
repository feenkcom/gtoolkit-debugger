Class {
	#name : #GtDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggingSession'
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
GtDebuggerElement class >> alwaysOpenFullDebugger [
	^ AlwaysOpenFullDebugger ifNil: [AlwaysOpenFullDebugger := false]
]

{ #category : #'settings api' }
GtDebuggerElement class >> alwaysOpenFullDebugger: aBoolean [
	AlwaysOpenFullDebugger := aBoolean.
]

{ #category : #testing }
GtDebuggerElement class >> availableAutomatically [
	"Should this debugger be taken into account when looking for a debugger to handle an exception."
	
	^ false
]

{ #category : #'utilities api' }
GtDebuggerElement class >> closeAllDebuggers [
	self flag: 'Take the new GT debuggers into account'.
	(SystemWindow allSubInstances select: [:w | 
		 w model isKindOf: GTGenericStackDebugger])
			do: [:w | w delete ].
	GTSpecPreDebugWindow allInstances do: #delete.
]

{ #category : #'settings api' }
GtDebuggerElement class >> defaultLogFileName [
	^ 'PharoDebug.log'
]

{ #category : #'settings api' }
GtDebuggerElement class >> filterCommonMessageSends [
	self flag: 'horrible hack not to break the setting browser'.
	^ false
]

{ #category : #'settings api' }
GtDebuggerElement class >> filterCommonMessageSends: aBoolean [
	FilterCommonMessageSends := aBoolean
]

{ #category : #'settings api' }
GtDebuggerElement class >> filterDoItSelectors [
	^ false
]

{ #category : #'accessing - ancient preference selectors' }
GtDebuggerElement class >> filterDoItSelectors: aBoolean [
	self flag: 'just for backward compatibility'
]

{ #category : #'settings api' }
GtDebuggerElement class >> filterKernelClasses [
	^ false
]

{ #category : #'accessing - ancient preference selectors' }
GtDebuggerElement class >> filterKernelClasses: aBoolean [
	self flag: 'just for backward compatibility'
]

{ #category : #'settings api' }
GtDebuggerElement class >> filterLinkSelectors [
	^ false
]

{ #category : #'accessing - ancient preference selectors' }
GtDebuggerElement class >> filterLinkSelectors: aBoolean [ 
	self flag: 'just for backward compatibility'
]

{ #category : #'settings api' }
GtDebuggerElement class >> filterNilSelectors [
	^ false
]

{ #category : #'accessing - ancient preference selectors' }
GtDebuggerElement class >> filterNilSelectors: aBoolean [ 
	self flag: 'just for backward compatibility'
]

{ #category : #testing }
GtDebuggerElement class >> handlesContext: aContext [

	^ true
]

{ #category : #'settings api' }
GtDebuggerElement class >> logDebuggerStackToFile [
	^ LogDebuggerStackToFile ifNil: [LogDebuggerStackToFile := true]
]

{ #category : #'settings api' }
GtDebuggerElement class >> logDebuggerStackToFile: aBoolean [
	 LogDebuggerStackToFile := aBoolean
]

{ #category : #'settings api' }
GtDebuggerElement class >> logFileName [
	^ LogFileName ifNil: [ self defaultLogFileName ] 
]

{ #category : #'instance creation' }
GtDebuggerElement class >> on: aDebugSession [

	^ self new 	
		session: aDebugSession
]

{ #category : #opening }
GtDebuggerElement class >> openInspectorOn: aDebuggingSession [
	| aDebugger |

	aDebugger := self on: aDebuggingSession.
	^ aDebugger openInInspector
]

{ #category : #opening }
GtDebuggerElement class >> openOn: aDebuggingSession [
	| aDebugger |

	aDebugger := self on: aDebuggingSession.
	^ aDebugger open.
]

{ #category : #'opening api' }
GtDebuggerElement class >> openOn: aDebugSession withFullView: aBool [
	self openOn: aDebugSession withFullView: aBool andNotification: nil
]

{ #category : #'opening api' }
GtDebuggerElement class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	| debugger debuggerClass |
	
	debuggerClass := Smalltalk tools 
		debuggerDispatcherFor: aDebugSession interruptedContext
		matching: [ :aDebuggerClass | 
			"Only take into account GT debuggers."
			(aDebuggerClass includesBehavior: GtDebuggerElement) and: [ 
				aDebuggerClass availableAutomatically ] ].
	debugger := debuggerClass
		ifNil: [ 
			"Use the current debugger"
			self on: aDebugSession ]
		ifNotNil: [ :aDebugger | 
			"Use a custom extension"
			aDebugger on: (aDebugger spanNewSessionFrom: aDebugSession) ].
	
	"For now allways open the full debugger"
	debugger openWithFullView 
	
	"aBool | self alwaysOpenFullDebugger
		ifTrue: [ debugger openWithFullView ]
		ifFalse: [ debugger openWithNotification: aString]"
]

{ #category : #'tools registry' }
GtDebuggerElement class >> register [
	self registerToolsOn: Smalltalk tools.

]

{ #category : #'tools registry' }
GtDebuggerElement class >> registerToolsOn: registry [
	registry register: self as: #debugger.
]

{ #category : #accessing }
GtDebuggerElement class >> sessionClass [
	self subclassResponsibility
]

{ #category : #accessing }
GtDebuggerElement class >> spanNewSessionFrom: anotherSession [

	^ (self sessionClass 
		named: anotherSession name 
		on: anotherSession interruptedProcess 
		startedAt: anotherSession interruptedContext)
			errorWasInUIProcess: anotherSession errorWasInUIProcess;
			yourself
]

{ #category : #'settings api' }
GtDebuggerElement class >> stackWidgetClass [
	self flag: 'horrible hack not to break the setting browser'.
	^ self
]

{ #category : #icons }
GtDebuggerElement class >> taskbarIconName [
	^ #smallDebugIcon
]

{ #category : #callbacks }
GtDebuggerElement >> actOnBrowserClosing: ann [
	self session ifNotNil: [ :aSession | 
		aSession terminate.
		debuggingSession := nil ]
]

{ #category : #callbacks }
GtDebuggerElement >> actOnDebugSessionChanged [
	self subclassResponsibility
]

{ #category : #'building actions' }
GtDebuggerElement >> actionsForPragmas: aSymbolsCollection [
	^ (self session class
		debuggingActionsForPragmas: aSymbolsCollection 
		for: self)
	
]

{ #category : #announce }
GtDebuggerElement >> announce: something [
	"Needed by the debugger actions"
]

{ #category : #actions }
GtDebuggerElement >> close [
	self space close
]

{ #category : #actions }
GtDebuggerElement >> detachSession [
	debuggingSession := nil
]

{ #category : #accessing }
GtDebuggerElement >> interruptedContext [
	^ self session interruptedContext
]

{ #category : #callbacks }
GtDebuggerElement >> onAddedToSceneGraph [ 
	self space when: BlSpaceClosedEvent do: [ :event | self actOnBrowserClosing: event ]
]

{ #category : #opening }
GtDebuggerElement >> open [
	| aSpace |
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: self session name.
	aSpace extent: 1200@600.
	aSpace addChild: self.
	^ aSpace show
]

{ #category : #opening }
GtDebuggerElement >> openInInspector [
	| anInspector aSpace |

	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	
	anInspector := GtInspector new.
	anInspector constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	anInspector addPageWithContent: self for: self session.

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: self session name.
	aSpace extent: 1200@600.
	aSpace addChild: anInspector.
	aSpace show.
]

{ #category : #opening }
GtDebuggerElement >> openWithFullView [
	"Create and open a full debugger. Do not terminate the current active process."

	self openInInspector
]

{ #category : #accessing }
GtDebuggerElement >> session [
	^ debuggingSession
]

{ #category : #accessing }
GtDebuggerElement >> session: aDebuggingSession [
	debuggingSession := aDebuggingSession.
	self actOnDebugSessionChanged.
]

Class {
	#name : #GtDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggingSession'
	],
	#category : #'GToolkit-Debugger'
}

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

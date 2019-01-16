Class {
	#name : #GtDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggingSession'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #opening }
GtDebuggerElement class >> openInspectorOn: aDebuggingSession [
	| aDebugger anInspector aSpace |

	aDebugger := self new.
	aDebugger constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	aDebugger session: aDebuggingSession.
	
	anInspector := GtInspector new.
	anInspector constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	anInspector addPageWithContent: aDebugger for: aDebuggingSession.

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aDebuggingSession name.
	aSpace extent: 1200@600.
	aSpace addChild: anInspector.
	aSpace show.
	
	^ aDebugger
]

{ #category : #opening }
GtDebuggerElement class >> openOn: aDebuggingSession [
	| aDebugger aSpace |

	aDebugger := self new.
	aDebugger constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	aDebugger session: aDebuggingSession.

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aDebuggingSession name.
	aSpace extent: 1200@600.
	aSpace addChild: aDebugger.
	aSpace show.
	
	^ aDebugger
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

{ #category : #updating }
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

{ #category : #accessing }
GtDebuggerElement >> session [
	^ debuggingSession
]

{ #category : #accessing }
GtDebuggerElement >> session: aDebuggingSession [
	debuggingSession := aDebuggingSession.
	self actOnDebugSessionChanged.
]

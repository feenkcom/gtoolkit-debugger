Class {
	#name : #GtDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggingSession'
	],
	#category : #'GToolkit-Debugger'
}

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

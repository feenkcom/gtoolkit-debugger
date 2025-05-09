Class {
	#name : #GtDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggingSession',
		'announcer',
		'browserClosingHandler'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #testing }
GtDebuggerElement class >> availableAutomatically [
	"Should this debugger be taken into account when looking for a debugger to handle an exception."
	
	^ false
]

{ #category : #initialization }
GtDebuggerElement class >> debuggerSpecification [
	^ GtMoldableExceptionStandaloneDebuggerSpecification new 
		debuggerClass: self
]

{ #category : #initialization }
GtDebuggerElement class >> defaultIcon [
	^ BrGlamorousVectorIcons debug
]

{ #category : #initialization }
GtDebuggerElement class >> defaultTitle [
	^ 'Gt'
]

{ #category : #testing }
GtDebuggerElement class >> handlesContext: aContext [

	^ true
]

{ #category : #testing }
GtDebuggerElement class >> handlesDebugSession: aDebugSession [
	^ self handlesContext: aDebugSession interruptedContext
]

{ #category : #'instance creation' }
GtDebuggerElement class >> on: aDebugSession [

	^ self new 	
		session: aDebugSession
]

{ #category : #'tools registry' }
GtDebuggerElement class >> register [
	self registerToolsOn: Smalltalk tools.
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
			exception: anotherSession exception;
			errorWasInUIProcess: anotherSession errorWasInUIProcess;
			yourself
]

{ #category : #opening }
GtDebuggerElement >> aboutToOpen [
	"Perform any action or update before the debugger is opened in the UI."
]

{ #category : #callbacks }
GtDebuggerElement >> actOnBrowserClosing: ann [
	"Terminate the session when the debugger is closed. This can be called when 
	manually closing the debugger or when resuming."
	self terminateSession
]

{ #category : #callbacks }
GtDebuggerElement >> actOnDebugActionExecuted [
	
]

{ #category : #callbacks }
GtDebuggerElement >> actOnDebugSessionChanged [
	self subclassResponsibility
]

{ #category : #'building actions' }
GtDebuggerElement >> actionsForPragmas: aSymbolsCollection [
	<return: #Collection of: #DebugAction>
	^ self session class
		debuggingActionsForPragmas: aSymbolsCollection 
		for: self
]

{ #category : #announce }
GtDebuggerElement >> announce: anAnnouncement [

	self announcer announce: anAnnouncement
]

{ #category : #accessing }
GtDebuggerElement >> announcer [
	^ announcer
]

{ #category : #actions }
GtDebuggerElement >> close [
	browserClosingHandler ifNotNil: [ 
		"Remove the event handler so that closing the space will not terminate the session one more time"
		self space removeEventHandler: browserClosingHandler ].
	self space close.
	
	"Closing a window is an asyncronous operation in Bloc. It will not actually close the debugger imediately, 
	but add a defer action for doing that. Because of this terminate the debugging session imediately, without
	waiting for the debugger to do this when the close action is executed. This close operation needs to run
	in the UI process."
	self terminateSession.
]

{ #category : #accessing }
GtDebuggerElement >> debugSession [
	^ debuggingSession
]

{ #category : #actions }
GtDebuggerElement >> detachSession [
	debuggingSession := nil
]

{ #category : #querying }
GtDebuggerElement >> findLimitedFullActiveContextForMethod: aCompiledMethod  ifFound: aFoundBlock ifNone: aNoneBlock [
	^ debuggingSession findLimitedFullActiveContextForMethod: aCompiledMethod  ifFound: aFoundBlock ifNone: aNoneBlock
]

{ #category : #initialization }
GtDebuggerElement >> initialize [
	super initialize.
	announcer := Announcer new.
]

{ #category : #accessing }
GtDebuggerElement >> interruptedContext [
	^ self session interruptedContext
]

{ #category : #callbacks }
GtDebuggerElement >> onAddedToSceneGraph [
	super onAddedToSceneGraph.

	browserClosingHandler ifNotNil: [ 
		self space removeEventHandler: browserClosingHandler ].
	browserClosingHandler := BlEventHandler 
		on: BlSpaceDestroyedEvent 
		do: [ :event | self actOnBrowserClosing: event ].
	
	self space addEventHandler: browserClosingHandler
]

{ #category : #accessing }
GtDebuggerElement >> prepareDebugSession: aDebuggingSession [ 
	"aDebuggingSession ensureStepOverBreakpointTrigger"
]

{ #category : #actions }
GtDebuggerElement >> restart: aContext [
	self session restart: aContext
]

{ #category : #actions }
GtDebuggerElement >> resumeAndCloseDebugger [
	self session
		resume;
		clear.
	self close
]

{ #category : #accessing }
GtDebuggerElement >> session [
	^ debuggingSession
]

{ #category : #accessing }
GtDebuggerElement >> session: aDebuggingSession [
	debuggingSession := aDebuggingSession.
	self prepareDebugSession: aDebuggingSession.
	
	self actOnDebugSessionChanged.
]

{ #category : #'accessing - settings' }
GtDebuggerElement >> settings [
	^ self userData 
		at: #settingsCache
		ifAbsentPut: [ SmallDictionary new ]
]

{ #category : #'building actions' }
GtDebuggerElement >> stackDebuggingActionsPragmas [
	^ #( gt2StackDebuggingAction )
]

{ #category : #actions }
GtDebuggerElement >> terminateSession [
	self session ifNotNil: [ :aSession | 
		"This method can be called more times from the UI process when closing the debugger.
		Set the debugging session to nil so that only the first call terminates the session."
		self detachSession.
		aSession terminate ]
]

Class {
	#name : #GtDebuggerElement,
	#superclass : #BlElement,
	#instVars : [
		'debuggingSession',
		'announcer'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #testing }
GtDebuggerElement class >> availableAutomatically [
	"Should this debugger be taken into account when looking for a debugger to handle an exception."
	
	^ false
]

{ #category : #initialization }
GtDebuggerElement class >> defaultTitle [
	^ 'GT'
]

{ #category : #testing }
GtDebuggerElement class >> handlesContext: aContext [

	^ true
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

{ #category : #opening }
GtDebuggerElement class >> openOn: aDebugSession withFullView: aBool [
	^ self openOn: aDebugSession withFullView: aBool andNotification: nil
]

{ #category : #opening }
GtDebuggerElement class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	^self openInspectorOn:aDebugSession
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
			errorWasInUIProcess: anotherSession errorWasInUIProcess;
			yourself
]

{ #category : #opening }
GtDebuggerElement >> aboutToOpen [
	"Perform any action or update before the debugger is opened in the UI."
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
GtDebuggerElement >> announce: anAnnouncement [
	self announcer announce: anAnnouncement
]

{ #category : #accessing }
GtDebuggerElement >> announcer [
	^ announcer
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
GtDebuggerElement >> inInspector [
	| anInspector |
	anInspector := GtInspector new.
	anInspector
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	anInspector addPageWithContent: self for: self session.
	^ anInspector
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
	self space when: BlSpaceClosedEvent do: [ :event | self actOnBrowserClosing: event ]
]

{ #category : #opening }
GtDebuggerElement >> open [
	self aboutToOpen.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	^ self open: self withTitle: self session name.
]

{ #category : #opening }
GtDebuggerElement >> open: anElement withTitle: aTitleString [
	| aSpace |
	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aTitleString.
	aSpace extent: 1200 @ 600.
	aSpace addChild: anElement.
	^ aSpace show
]

{ #category : #opening }
GtDebuggerElement >> openInInspector [
	| anInspector |
	self aboutToOpen.
	self constraintsDo: [ :c | 
		c horizontal matchParent.
		c vertical matchParent ].
	anInspector := self inInspector.
	^ self open: anInspector withTitle: self session name.
]

{ #category : #opening }
GtDebuggerElement >> openInSpace: anElement titled: aTitleString [
	| aSpace |
	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aTitleString.
	aSpace extent: 1200 @ 600.
	aSpace addChild: anElement.
	^ aSpace show
]

{ #category : #'accessing - settings' }
GtDebuggerElement >> selectedDetailesTabName [
	^ self settings 
		at: #selectedDetailedTabName 
		ifAbsent: [ nil ]
]

{ #category : #'accessing - settings' }
GtDebuggerElement >> selectedDetailesTabName: aString [
	self settings 
		at: #selectedDetailedTabName 
		put: aString
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

{ #category : #'accessing - settings' }
GtDebuggerElement >> settings [
	^ self userData 
		at: #settingsCache
		ifAbsentPut: [ SmallDictionary new ]
]

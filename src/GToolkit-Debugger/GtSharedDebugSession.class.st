Class {
	#name : 'GtSharedDebugSession',
	#superclass : 'GtAnnouncingDebugSession',
	#instVars : [
		'mutex',
		'session'
	],
	#category : 'GToolkit-Debugger-Session'
}

{ #category : 'private - asserting' }
GtSharedDebugSession >> assertSession: aDebugSession [
	self
		assert: [ aDebugSession isNotNil ] 
		description: [ 'Debug session must be non-nil' ].
	self
		assert: [ session isNil ] 
		description: [ 'Debug session can be initialized only once' ]
]

{ #category : 'api - actions' }
GtSharedDebugSession >> debug [
	<return: #GtMoldableDebugger>
	self releasedSessionDo: [ :aSession |
		| aDebugger |
		aDebugger := Smalltalk tools debugger 
			openOn: aSession 
			withFullView: true 
			andNotification: nil.
		self notifyDebugged.
		^ aDebugger ].
	^ nil
]

{ #category : 'gt-extensions' }
GtSharedDebugSession >> gtViewInterruptedContextFor: aView [
	<gtView>
	self session ifNil: [ ^ aView empty ].
	^ (self session gtViewInterruptedContextFor: aView)
		priority: 10
]

{ #category : 'gt-extensions' }
GtSharedDebugSession >> gtViewInterruptedStackFor: aView [
	<gtView>
	self session ifNil: [ ^ aView empty ].
	^ (self session gtViewInterruptedStackFor: aView)
		priority: 12
]

{ #category : 'gt-extensions' }
GtSharedDebugSession >> gtViewLiveDebuggerFor: aView [
	<gtView>
	self session ifNil: [ ^ aView empty ].
	^ (self session gtViewLiveDebuggerFor: aView)
		priority: 21
]

{ #category : 'gt-extensions' }
GtSharedDebugSession >> gtViewSuspendedStackFor: aView [
	<gtView>
	self session ifNil: [ ^ aView empty ].
	^ (self session gtViewSuspendedStackFor: aView)
		priority: 14
]

{ #category : 'initialization' }
GtSharedDebugSession >> initialize [
	super initialize.
	mutex := Mutex new.
]

{ #category : 'api - accessing' }
GtSharedDebugSession >> interruptedContext [
	self sessionDo: [ :aSession | 
		^ aSession interruptedContext ].
	^ nil
]

{ #category : 'api - accessing' }
GtSharedDebugSession >> interruptedProcess [
	self sessionDo: [ :aSession | 
		^ aSession interruptedProcess ].
	^ nil
]

{ #category : 'api - accessing' }
GtSharedDebugSession >> name [
	self sessionDo: [ :aSession | 
		^ aSession name ].
	^ '<detached>'
]

{ #category : 'private - notifying' }
GtSharedDebugSession >> notifyDebugged [
	self announce: (GtSharedDebugSessionDebuggedAnnouncement new session: self)
]

{ #category : 'private - notifying' }
GtSharedDebugSession >> notifyTerminated [
	self announce: (GtSharedDebugSessionTerminatedAnnouncement new session: self)
]

{ #category : 'printing' }
GtSharedDebugSession >> printOn: aStream [
	aStream
		nextPutAll: 'Shared Debug Session: ';
		print: self name
]

{ #category : 'private - actions' }
GtSharedDebugSession >> releasedSessionDo: aBlock [
	| aSession |
	mutex critical: [ 
		aSession := self session.
		session := nil ].
	aSession ifNotNil: aBlock.
]

{ #category : 'private - accessing' }
GtSharedDebugSession >> session [
	<return: #DebugSession>
	^ session
]

{ #category : 'api - initialization' }
GtSharedDebugSession >> session: aDebugSession [
	self assertSession: aDebugSession.
	session := aDebugSession
]

{ #category : 'private - accessing' }
GtSharedDebugSession >> sessionDo: aBlock [
	self session ifNotNil: aBlock
]

{ #category : 'api - actions' }
GtSharedDebugSession >> terminate [
	self releasedSessionDo: [ :aSession |
		aSession terminate.
		self notifyTerminated ].
]

Class {
	#name : #GtSharedDebugSessionExamples,
	#superclass : #Object,
	#instVars : [
		'sessions'
	],
	#category : #'GToolkit-Debugger-Session'
}

{ #category : #'private - adding / removing' }
GtSharedDebugSessionExamples >> addSession: aSession [
	self sessions add: aSession.
]

{ #category : #'private - asserting' }
GtSharedDebugSessionExamples >> assertTerminatedSession: aSession [
	self assert: aSession interruptedContext isNil.
	self assert: aSession interruptedProcess isNil
]

{ #category : #'examples - shared session' }
GtSharedDebugSessionExamples >> basicSharedDebugSession [
	<gtExample>
	| aSession |
	aSession := GtSharedDebugSession new.
	self assert: aSession session isNil.
	^ aSession
]

{ #category : #'examples - session' }
GtSharedDebugSessionExamples >> debugSession [
	<gtExample>
	<after: #terminateSessions>
	| aContext aProcess aSession |
	aContext := [ 1 + 1 ] asContext.
	aProcess := Process 
	    forContext: aContext 
	    priority: Processor userInterruptPriority.
	aSession := aProcess 
		newDebugSessionNamed: 'Example session' 
		startedAt: aContext.
		
	self addSession: aSession.

	self assert: aSession interruptedContext isNotNil.
	self assert: aSession interruptedProcess isNotNil.
		
	^ aSession 
]

{ #category : #'examples - shared session' }
GtSharedDebugSessionExamples >> debugSharedSession [
	<gtExample>
	| aSession aCollection aDebugger |
	aSession := self sharedDebugSession.
	aCollection := OrderedCollection new.
	
	aSession 
		when: GtSharedDebugSessionDebuggedAnnouncement 
		do: [ :anAnnouncement | 
			self assert: aSession interruptedContext isNil.
			self assert: aSession interruptedProcess isNil.
			self assert: aSession session isNil.
			aCollection add: anAnnouncement ].
	
	aDebugger := aSession debug.
	self assert: aDebugger space isNotNil.
	aDebugger enqueueTask: (BlTaskAction new 
		action: [ aDebugger space close]).

	self assert: aSession session isNil.
	self assert: aSession interruptedContext isNil.
	self assert: aSession interruptedProcess isNil.
	self assert: aCollection size equals: 1.
	self assert: aCollection first session equals: aSession.
	
	^ aSession
]

{ #category : #'private - accessing' }
GtSharedDebugSessionExamples >> sessions [
	^ sessions ifNil: [ sessions := OrderedCollection new ]
]

{ #category : #'examples - shared session' }
GtSharedDebugSessionExamples >> sharedDebugSession [
	<gtExample>
	| aSession aPharoSession |
	aSession := self basicSharedDebugSession.
	aPharoSession := self debugSession.
	aSession session: aPharoSession.
	self assert: aSession session equals: aPharoSession.
	^ aSession
]

{ #category : #accessing }
GtSharedDebugSessionExamples >> terminateSessions [
	self sessions do: [ :eachSession | 
		eachSession terminate ]
]

{ #category : #'examples - shared session' }
GtSharedDebugSessionExamples >> terminateSharedSession [
	<gtExample>
	| aSession aCollection |
	aSession := self sharedDebugSession.
	aCollection := OrderedCollection new.
	
	aSession 
		when: GtSharedDebugSessionTerminatedAnnouncement 
		do: [ :anAnnouncement | 
			self assert: aSession interruptedContext isNil.
			self assert: aSession interruptedProcess isNil.
			self assert: aSession session isNil.
			aCollection add: anAnnouncement ].
	
	aSession terminate.

	self assert: aSession session isNil.
	self assert: aSession interruptedContext isNil.
	self assert: aSession interruptedProcess isNil.
	self assert: aCollection size equals: 1.
	self assert: aCollection first session equals: aSession.
	
	^ aSession
]

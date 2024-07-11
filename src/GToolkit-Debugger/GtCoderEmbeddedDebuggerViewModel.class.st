Class {
	#name : #GtCoderEmbeddedDebuggerViewModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'signaledException',
		'isTerminationDisabled',
		'debugSession',
		'mutex',
		'announcer',
		'isDropdownDisplayed'
	],
	#category : #'GToolkit-Debugger-Embedded - Models'
}

{ #category : #announcer }
GtCoderEmbeddedDebuggerViewModel >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerViewModel >> debugSession [
	^ debugSession
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerViewModel >> debugSession: anObject [
	debugSession := anObject
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerViewModel >> debugSessionDo: aBlock [
	^ mutex critical: [ self debugSession ifNotNil: aBlock ]
]

{ #category : #configuration }
GtCoderEmbeddedDebuggerViewModel >> disableTermination [
	isTerminationDisabled := true
]

{ #category : #configuration }
GtCoderEmbeddedDebuggerViewModel >> enableTermination [
	isTerminationDisabled := false
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerViewModel >> gtExceptionEmbeddedDebuggerSpecification [
	<return: #GtDebuggerSpecification>
	^ self signaledException gtExceptionEmbeddedDebuggerSpecification
]

{ #category : #initialization }
GtCoderEmbeddedDebuggerViewModel >> initialize [
	super initialize.
	self enableTermination.
	mutex := Mutex new.
	announcer := Announcer new
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerViewModel >> isDropdownDisplayed [
	"True value means, that embedded debugger dropdown is shown, 
	false value means it is hidden."

	<return: #Boolean>
	^ isDropdownDisplayed ifNil: [ isDropdownDisplayed := true ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerViewModel >> isDropdownDisplayed: aBoolean [
	isDropdownDisplayed := aBoolean
]

{ #category : #'private - subscriptions' }
GtCoderEmbeddedDebuggerViewModel >> onSharedDebugSessionAnnouncement: anAnnouncement [
	self announce: anAnnouncement
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerViewModel >> releasedDebugSessionDo: aBlock [
	^ mutex critical: [ 
		self debugSessionDo: [ :aSession | 
			self unsubscribeFromDebugSession.
			debugSession := nil.
			aBlock value: aSession ] ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerViewModel >> signaledException [
	^ signaledException
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerViewModel >> signaledException: anObject [
	signaledException := anObject
]

{ #category : #'private - subscriptions' }
GtCoderEmbeddedDebuggerViewModel >> subscribeToDebugSession [
	self debugSession weak
		when: GtSharedDebugSessionAnnouncement
		send: #onSharedDebugSessionAnnouncement:
		to: self
]

{ #category : #actions }
GtCoderEmbeddedDebuggerViewModel >> switchToSystemDebugger [
	"Directly open the registered debugger on the given session."

	^ self releasedDebugSessionDo: [ :aSession | aSession debug ]
]

{ #category : #actions }
GtCoderEmbeddedDebuggerViewModel >> terminateDebugSession [
	isTerminationDisabled ifFalse: [ 
		self releasedDebugSessionDo: [ :aSession | 
			aSession terminate ] ]
]

{ #category : #'private - subscriptions' }
GtCoderEmbeddedDebuggerViewModel >> unsubscribeFromDebugSession [
	self debugSession unsubscribe: self
]

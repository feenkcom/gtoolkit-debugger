Class {
	#name : #GtDebuggerAbstractStackModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'filters',
		'coderViewModelCache',
		'lock',
		'session',
		'context',
		'coderViewModelStream',
		'contextStream'
	],
	#category : #'GToolkit-Debugger-Models'
}

{ #category : #accessing }
GtDebuggerAbstractStackModel class >> onSession: debuggingSession [
	^self new session: debuggingSession
]

{ #category : #announcer }
GtDebuggerAbstractStackModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> cachedCodersDo: aBlock [
	coderViewModelCache do: [ :each | aBlock value: each first ]
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> coderViewModelStream [
	^ coderViewModelStream asyncSimilarCopy
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> context: aContext [
	self subclassResponsibility
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> contextStream [
	| allContexts |
	allContexts := GtPharoStackStream onContext: context.
	^ (filters isNil or: [ filters isEmpty ])
		ifTrue: [ allContexts ]
		ifFalse: [ allContexts
				select: [ :each | 
					each sender isNil
						or: [ filters anySatisfy: [ :filter | filter matches: each method method ] ] ] ]
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> filters [
	^ filters ifNil: [ #() ]
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> filters: aCollection [
	filters := Set withAll: aCollection.
	self updateContextStreams
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> forceRefreshStack [
	| aContext |
	
	aContext := context.
	context := nil.
	self context: aContext.
	
	self announce: GtCoderRefreshStackAnnouncement new
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> getCoderViewModelForContext: aContext [
	self subclassResponsibility
]

{ #category : #initialization }
GtDebuggerAbstractStackModel >> initialize [
	super initialize.
	
	coderViewModelCache := IdentityDictionary new.
	lock := Semaphore forMutualExclusion
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> session [
	^ session
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> session: debuggingSession [
	session := debuggingSession.
	self updateContent
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> updateContent [
	self context: session context
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> updateContextStreams [
	coderViewModelStream := (self contextStream
		collect: [ :each | 
			self getCoderViewModelForContext: each ]) cached.
	
	self announce: GtDebuggerStackChanged new
]

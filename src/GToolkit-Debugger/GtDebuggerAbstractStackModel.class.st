Class {
	#name : #GtDebuggerAbstractStackModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'filters',
		'coderViewModelCache',
		'session',
		'currentContext'
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
	"Evaluate a given block with all currently cached coder view models in
	an arbitrary order."
	coderViewModelCache do: [ :eachCoder | aBlock value: eachCoder ]
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> coderViewModelStream [
	^ self contextStream
		map: [ :eachContext | 
			(self createCoderFor: eachContext in: session) asCoderViewModel ]
		cache: coderViewModelCache
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> context: aContext [
	self
		deprecated: 'Please use updateBasedOnCurentContext: instead.'
		transformWith:
			'`@receiver context: `@statements1'
				-> '`@receiver updateBasedOnCurentContext: `@statements1'.

	self updateBasedOnCurentContext: aContext
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> contextStream [
	| allContexts |

	allContexts := GtPharoStackStream onContext: currentContext.
	
	filters
		ifEmpty: [ ^ allContexts ].

	^ allContexts
		select: [ :each | 
			each sender isNil
				or: [ filters anySatisfy: [ :filter | filter matches: each method method ] ] ]
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> createCoderFor: aContext in: aSession [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> currentContextMethodIndicator [
	^ nil
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> filters [
	<return: #Set>

	^ filters
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> filters: aCollection [
	filters := Set withAll: aCollection.
	self notifyDebuggerStackChanged
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> forceRefreshStack [
	| aContext |
	aContext := currentContext.
	currentContext := nil.
	
	self updateBasedOnCurentContext: aContext.
	self announce: GtCoderRefreshStackAnnouncement new
]

{ #category : #initialization }
GtDebuggerAbstractStackModel >> initialize [
	super initialize.
	
	filters := Set new.
	coderViewModelCache := AsyncSharedDictionary new
]

{ #category : #announcer }
GtDebuggerAbstractStackModel >> notifyDebuggerStackChanged [
	self announce: GtDebuggerStackChanged new
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> session [
	^ session
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> session: aDebuggingSession [
	session := aDebuggingSession.
	self updateBasedOnCurentSession
]

{ #category : #accessing }
GtDebuggerAbstractStackModel >> updateBasedOnCurentContext: aContext [
	self subclassResponsibility
]

{ #category : #updating }
GtDebuggerAbstractStackModel >> updateBasedOnCurentSession [
	self updateBasedOnCurentContext: session context
]

{ #category : #updating }
GtDebuggerAbstractStackModel >> updateContent [
	self
		deprecated: 'Please use updateBasedOnCurentSession: instead.'
		transformWith:
			'`@receiver updateContent'
				-> '`@receiver updateBasedOnCurentSession'.

	self updateBasedOnCurentSession
]

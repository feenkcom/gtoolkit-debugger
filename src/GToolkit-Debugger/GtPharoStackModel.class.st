Class {
	#name : #GtPharoStackModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'contextStream',
		'coderViewModelStream',
		'session',
		'lock',
		'announcer',
		'context',
		'filters',
		'coderViewModelCache'
	],
	#category : #'GToolkit-Debugger-GToolkit-Debugger'
}

{ #category : #accessing }
GtPharoStackModel class >> onSession: debuggingSession [
	^self new session: debuggingSession
]

{ #category : #announcer }
GtPharoStackModel >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
GtPharoStackModel >> coderViewModelStream [
	^ coderViewModelStream asyncSimilarCopy
]

{ #category : #accessing }
GtPharoStackModel >> context: aContext [
	context ~~ aContext
		ifTrue: [ (context notNil and: [ context isDead ])
				ifTrue: [ self resetCoderViewModelCache ].
			context := aContext.
			self updateContextStreams ]
]

{ #category : #accessing }
GtPharoStackModel >> contextStream [
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
GtPharoStackModel >> createCoderFor: aContext in: aSession [
	| coder |
	coder := GtPharoMethodContextCoder forContext: aContext session: aSession.
	coder announcer weak when: GtCoderRefreshStackAnnouncement send: #forceRefreshStack to: self.
	coder announcer weak when: DebugActionExecuted send: #forceRefreshStack to: self.
	^ coder
]

{ #category : #accessing }
GtPharoStackModel >> filters [
	^ filters ifNil: [ #() ]
]

{ #category : #accessing }
GtPharoStackModel >> filters: aCollection [
	filters := Set withAll: aCollection.
	self updateContextStreams
]

{ #category : #accessing }
GtPharoStackModel >> forceRefreshStack [
	| aContext |
	aContext := context.
	context := nil.
	self context: aContext.
	self announce: GtCoderRefreshStackAnnouncement new
]

{ #category : #accessing }
GtPharoStackModel >> getCoderViewModelForContext: aContext [
	^ lock
		critical: [ coderViewModelCache
				at: aContext
				ifAbsentPut: [ (self createCoderFor: aContext in: session) asCoderViewModel ] ]
		ifError: [ nil ]
]

{ #category : #accessing }
GtPharoStackModel >> hideVariableValueAnnotations [
	coderViewModelCache
		do: [ :viewModel | 
			viewModel
				stylers: (viewModel stylers
						reject: [ :each | each isKindOf: GtStackContextVariableValueStyler ]).
			viewModel requestUpdateAddOns ]
]

{ #category : #accessing }
GtPharoStackModel >> initialize [
	super initialize.
	coderViewModelCache := IdentityDictionary new.
	lock := Semaphore forMutualExclusion
]

{ #category : #accessing }
GtPharoStackModel >> resetCoderViewModelCache [
	lock
		critical: [ coderViewModelCache keys
				do: [ :each | each isDead ifTrue: [ coderViewModelCache removeKey: each ifAbsent: [  ] ] ] ]
		ifError: [  ]
]

{ #category : #accessing }
GtPharoStackModel >> session [
	^ session
]

{ #category : #accessing }
GtPharoStackModel >> session: debuggingSession [
	session := debuggingSession.
	self updateContent
]

{ #category : #accessing }
GtPharoStackModel >> showVariableValueAnnotations [
	coderViewModelCache
		do: [ :viewModel | 
			viewModel
				addStyler: (GtStackContextVariableValueStyler new coderViewModel: viewModel).
			viewModel requestUpdateAddOns ]
]

{ #category : #accessing }
GtPharoStackModel >> stackChanged [
	self announce: GtDebuggerStackChanged new
]

{ #category : #accessing }
GtPharoStackModel >> updateContent [
	self context: session context
]

{ #category : #accessing }
GtPharoStackModel >> updateContextStreams [
	coderViewModelStream := (self contextStream
			collect: [ :each | self getCoderViewModelForContext: each ]) cached.
	self announce: GtDebuggerStackChanged new
]

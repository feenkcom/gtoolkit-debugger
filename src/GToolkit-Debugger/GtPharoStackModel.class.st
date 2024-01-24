Class {
	#name : #GtPharoStackModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'session',
		'lock',
		'announcer',
		'filters',
		'coderViewModelCache',
		'currentContext'
	],
	#category : #'GToolkit-Debugger-Models'
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
GtPharoStackModel >> cachedCodersDo: aBlock [
	"Evaluate a given block with all currently cached coder view models in
	an arbitrary order."
	coderViewModelCache do: [ :eachCoder | aBlock value: eachCoder ]
]

{ #category : #accessing }
GtPharoStackModel >> coderViewModelStream [
	^ self contextStream
		map: [ :eachContext | (self createCoderFor: eachContext in: session) asCoderViewModel]
		cache: coderViewModelCache
]

{ #category : #accessing }
GtPharoStackModel >> context: aContext [
	self
		deprecated: 'Please use updateBasedOnCurentContext: instead.'
		transformWith:
			'`@receiver context: `@statements1'
				-> '`@receiver updateBasedOnCurentContext: `@statements1'.

	self updateBasedOnCurentContext: aContext
]

{ #category : #accessing }
GtPharoStackModel >> contextStream [
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
GtPharoStackModel >> createCoderFor: aContext in: aSession [
	| coder |
	coder := GtPharoMethodContextCoder forContext: aContext session: aSession.
	coder announcer weak when: GtCoderRefreshStackAnnouncement send: #forceRefreshStack to: self.
	coder announcer weak when: DebugActionExecuted send: #forceRefreshStack to: self.
	^ coder
]

{ #category : #accessing }
GtPharoStackModel >> filters [
	<return: #Set>

	^ filters
]

{ #category : #accessing }
GtPharoStackModel >> filters: aCollection [
	filters := Set withAll: aCollection.
	self notifyDebuggerStackChanged
]

{ #category : #accessing }
GtPharoStackModel >> forceRefreshStack [
	| aContext |
	aContext := currentContext.
	currentContext := nil.
	self updateBasedOnCurentContext: aContext.
	self announce: GtCoderRefreshStackAnnouncement new
]

{ #category : #accessing }
GtPharoStackModel >> getCoderViewModelForContext: aContext [
	^ lock
		critical: [ | method entry |
			method := aContext isBlockContext ifFalse: [ aContext compiledCode ].
			entry := coderViewModelCache
					at: aContext
					ifAbsentPut: [ {(self createCoderFor: aContext in: session) asCoderViewModel.
							method} ].
			(entry at: 2) ~~ method
				ifTrue: [ entry first coder forMethod: method.
					entry at: 2 put: method ].
			entry at: 1 ]
		ifError: [ nil ]
]

{ #category : #accessing }
GtPharoStackModel >> gtCachedCoders: aView [
	<gtView>
	
	^ aView list
		title: 'Cached coders';
		priority: 5;
		items: [ Array streamContents: [ :aStream | self cachedCodersDo: [ :eachCoder | aStream nextPut: eachCoder ] ] ];
		actionUpdateButton
]

{ #category : #accessing }
GtPharoStackModel >> gtContextCoderViewModelsFor: aView [
	<gtView>
	
	^ aView list
		title: 'Context coders';
		priority: 4;
		items: [ self coderViewModelStream ];
		actionUpdateButton
]

{ #category : #accessing }
GtPharoStackModel >> gtContextsFor: aView [
	<gtView>
	
	^ aView list
		title: 'Contexts';
		priority: 3;
		items: [ self contextStream ];
		actionUpdateButton
]

{ #category : #accessing }
GtPharoStackModel >> hideVariableValueAnnotations [
	self
		cachedCodersDo: [ :each | 
			each removeStylersOfClass: GtStackContextVariableValueStyler.
			each requestUpdateAddOns ]
]

{ #category : #accessing }
GtPharoStackModel >> initialize [
	super initialize.

	filters := Set new.
	coderViewModelCache := AsyncSharedIdentityDictionary new.
	lock := Semaphore forMutualExclusion
]

{ #category : #accessing }
GtPharoStackModel >> notifyDebuggerStackChanged [
	self announce: GtDebuggerStackChanged new
]

{ #category : #accessing }
GtPharoStackModel >> resetCoderViewModelCache [
	coderViewModelCache keys
		do: [ :each | each isDead ifTrue: [ coderViewModelCache removeKey: each ifAbsent: [  ] ] ]
]

{ #category : #accessing }
GtPharoStackModel >> session [
	^ session
]

{ #category : #accessing }
GtPharoStackModel >> session: aDebuggingSession [
	session := aDebuggingSession.
	self updateBasedOnCurentSession
]

{ #category : #accessing }
GtPharoStackModel >> showVariableValueAnnotations [
	self
		cachedCodersDo: [ :viewModel | 
			viewModel
				addStyler: (GtStackContextVariableValueStyler new coderViewModel: viewModel).
			viewModel requestUpdateAddOns ]
]

{ #category : #accessing }
GtPharoStackModel >> updateBasedOnCurentContext: aContext [
	"Changes the Context to a given one trying to preserve
	cached coders for each stack frame"
	currentContext == aContext
		ifTrue: [ ^ self ].

	(currentContext notNil and: [ currentContext isDead ])
		ifTrue: [ self resetCoderViewModelCache ].

	currentContext := aContext.
	self notifyDebuggerStackChanged
]

{ #category : #accessing }
GtPharoStackModel >> updateBasedOnCurentSession [
	self updateBasedOnCurentContext: session context
]

{ #category : #accessing }
GtPharoStackModel >> updateContent [
	self
		deprecated: 'Please use updateBasedOnCurentSession: instead.'
		transformWith:
			'`@receiver updateContent'
				-> '`@receiver updateBasedOnCurentSession'.

	self updateBasedOnCurentSession
]

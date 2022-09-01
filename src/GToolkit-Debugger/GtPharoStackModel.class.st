Class {
	#name : #GtPharoStackModel,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'contextStream',
		'currentCoderViewModels',
		'futureCoderViewModels',
		'coderViewModelStream',
		'session',
		'lock',
		'announcer',
		'context'
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
		ifTrue: [ context := aContext.
			self resetCoderViewModelCache.
			coderViewModelStream := (self contextStream
					collect: [ :each | self getCoderViewModelForContext: each ]) cached.
			self announce: GtDebuggerStackChanged new ]
]

{ #category : #accessing }
GtPharoStackModel >> contextStream [
	^ GtPharoStackStream onContext: context
]

{ #category : #accessing }
GtPharoStackModel >> createCoderFor: aContext in: aSession [
	| coder |
	coder := GtPharoMethodContextCoder forContext: aContext session: aSession.
	coder announcer weak when: GtCoderRefreshStackAnnouncement send: #updateDebugger to: self.
	coder announcer weak when: DebugActionExecuted send: #updateDebugger to: self.
	^ coder
]

{ #category : #accessing }
GtPharoStackModel >> getCoderViewModelForContext: aContext [
	^ lock
		critical: [ self removeFutureDeadContexts.
			currentCoderViewModels
				push: ((futureCoderViewModels notEmpty
						and: [ futureCoderViewModels top coder context == aContext ])
						ifTrue: [ futureCoderViewModels pop ]
						ifFalse: [ (self createCoderFor: aContext in: session) asCoderViewModel ]) ]
		ifError: [ nil ]
]

{ #category : #accessing }
GtPharoStackModel >> initialize [
	super initialize.
	currentCoderViewModels := Stack new.
	futureCoderViewModels := Stack new.
	lock := Semaphore forMutualExclusion
]

{ #category : #accessing }
GtPharoStackModel >> moveCurrentContextsToFuture [
	[ currentCoderViewModels notEmpty ]
		whileTrue: [ | coderViewModel |
			coderViewModel := currentCoderViewModels pop.
			coderViewModel context isDead ifFalse: [ futureCoderViewModels push: coderViewModel ] ]
]

{ #category : #accessing }
GtPharoStackModel >> removeFutureDeadContexts [
	[ futureCoderViewModels notEmpty and: [ futureCoderViewModels top context isDead ] ]
		whileTrue: [ futureCoderViewModels pop ]
]

{ #category : #accessing }
GtPharoStackModel >> resetCoderViewModelCache [
	lock
		critical: [ self removeFutureDeadContexts.
			self moveCurrentContextsToFuture ]
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
GtPharoStackModel >> updateContent [
	self context: session context
]

Class {
	#name : #GtDebuggerExpandableStackElement,
	#superclass : #GtAbstractExpandableStackElement,
	#instVars : [
		'stackModel'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #accessing }
GtDebuggerExpandableStackElement >> initializeStackModelFor: aDebuggingSession [
	stackModel := GtPharoStackModel onSession: aDebuggingSession.
	stackModel announcer weak
		when: GtDebuggerStackChanged
			send: #onStackChanged
			to: self;
		when: GtCoderRefreshStackAnnouncement
			send: #updateDebugger
			to: self.

	self onStackChanged
]

{ #category : #accessing }
GtDebuggerExpandableStackElement >> onStackChanged [
	self stackFramesList stream: stackModel coderViewModelStream.
	self stackFramesList scrollToIndex: 1 
]

{ #category : #accessing }
GtDebuggerExpandableStackElement >> openFirstNonFilteredContextFrom: stream [
	(stream next
		then: [ :item | 
			item isSome
				ifTrue: [ (item value coder context method hasPragmaNamed: #debuggerCompleteToSender)
						ifTrue: [ self openFirstNonFilteredContextFrom: stream ]
						ifFalse: [ self enqueueTask: [ self selectCoderUIModel: item value ] asBlTask ] ] ])
		await
]

{ #category : #accessing }
GtDebuggerExpandableStackElement >> updateForSession: aDebuggingSession [
	stackModel
		ifNil: [ self initializeStackModelFor: aDebuggingSession ]
		ifNotNil: [ stackModel updateContent ].
	self openFirstNonFilteredContextFrom: stackModel coderViewModelStream
]

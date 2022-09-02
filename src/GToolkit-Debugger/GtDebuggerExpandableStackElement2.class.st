Class {
	#name : #GtDebuggerExpandableStackElement2,
	#superclass : #GtAbstractExpandableStackElement,
	#instVars : [
		'stackModel'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #accessing }
GtDebuggerExpandableStackElement2 >> initializeStackModelFor: aDebuggingSession [
	stackModel := GtPharoStackModel onSession: aDebuggingSession.
	stackModel announcer weak
		when: GtDebuggerStackChanged
		send: #onStackChanged
		to: self.
	self onStackChanged
]

{ #category : #accessing }
GtDebuggerExpandableStackElement2 >> onStackChanged [
	self stackFramesList stream: stackModel coderViewModelStream.
	self stackFramesList scrollToIndex: 1 
]

{ #category : #accessing }
GtDebuggerExpandableStackElement2 >> openFirstNonFilteredContextFrom: stream [
	(stream next
		then: [ :item | 
			item isSome
				ifTrue: [ (item value coder context method hasPragmaNamed: #debuggerCompleteToSender)
						ifTrue: [ self openFirstNonFilteredContextFrom: stream ]
						ifFalse: [ self enqueueTask: [ self selectCoderUIModel: item value ] asBlTask ] ] ])
		await
]

{ #category : #accessing }
GtDebuggerExpandableStackElement2 >> updateForSession: aDebuggingSession [
	stackModel
		ifNil: [ self initializeStackModelFor: aDebuggingSession ]
		ifNotNil: [ stackModel updateContent ].
	self openFirstNonFilteredContextFrom: stackModel coderViewModelStream
]

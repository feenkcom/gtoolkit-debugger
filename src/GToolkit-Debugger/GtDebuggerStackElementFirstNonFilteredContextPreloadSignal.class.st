Class {
	#name : #GtDebuggerStackElementFirstNonFilteredContextPreloadSignal,
	#superclass : #GtDebuggerSignal,
	#instVars : [
		'promise'
	],
	#category : #'GToolkit-Debugger-Logging'
}

{ #category : #'as yet unclassified' }
GtDebuggerStackElementFirstNonFilteredContextPreloadSignal >> printOneLineContentsOn: aStream [
	| anIndex |
	self promise ifNil: [ ^ super printOneLineContentsOn: aStream ].

	anIndex := self promise isFulfilled
			ifTrue: [ self promise state value ]
			ifFalse: [ nil ].

	anIndex
		ifNotNil: [ aStream
				nextPutAll: 'Scroll index: ';
				print: anIndex ]
		ifNil: [ aStream nextPutAll: 'Unknown scroll index' ]
]

{ #category : #accessing }
GtDebuggerStackElementFirstNonFilteredContextPreloadSignal >> promise [
	^ promise
]

{ #category : #accessing }
GtDebuggerStackElementFirstNonFilteredContextPreloadSignal >> promise: aPromise [
	promise := aPromise
]

Class {
	#name : #GtPharoStackStream,
	#superclass : #Object,
	#traits : 'TAsyncStream',
	#classTraits : 'TAsyncStream classTrait',
	#instVars : [
		'currentContext',
		'topContext'
	],
	#category : #'GToolkit-Debugger-GToolkit-Debugger'
}

{ #category : #'instance creation' }
GtPharoStackStream class >> onContext: aContext [
	^ self new context: aContext
]

{ #category : #accessing }
GtPharoStackStream >> context: aContext [
	topContext := aContext.
	currentContext := topContext
]

{ #category : #'api - stream' }
GtPharoStackStream >> pollNext: anAsynchronousContext [
	| value |
	currentContext
		ifNil: [ value := AsyncOptionalValue none ]
		ifNotNil: [ value := AsyncOptionalValue some: currentContext.
			currentContext := currentContext sender ].
	^ AsyncPoll ready: value
]

{ #category : #'api - stream copy' }
GtPharoStackStream >> postSimilarCopy [
	currentContext := topContext
]

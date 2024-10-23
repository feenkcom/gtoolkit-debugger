Class {
	#name : #GtDebuggerPharoMethodIndicatorSignal,
	#superclass : #GtDebuggerSignal,
	#instVars : [
		'indicator',
		'previousContext',
		'newContext'
	],
	#category : #'GToolkit-Debugger-Models'
}

{ #category : #'gt - extensions' }
GtDebuggerPharoMethodIndicatorSignal >> gtOverviewFor: aView [
	<gtView>
	indicator ifNil: [ ^ aView empty ].

	^ (indicator gtOverviewFor: aView)
		priority: 1
]

{ #category : #accessing }
GtDebuggerPharoMethodIndicatorSignal >> indicator [
	<return: #GtDebuggerPharoMethodIndicator>
	^ indicator
]

{ #category : #accessing }
GtDebuggerPharoMethodIndicatorSignal >> indicator: anObject [
	indicator := anObject
]

{ #category : #accessing }
GtDebuggerPharoMethodIndicatorSignal >> newContext [
	^ newContext
]

{ #category : #accessing }
GtDebuggerPharoMethodIndicatorSignal >> newContext: anObject [
	newContext := anObject
]

{ #category : #accessing }
GtDebuggerPharoMethodIndicatorSignal >> previousContext [
	^ previousContext
]

{ #category : #accessing }
GtDebuggerPharoMethodIndicatorSignal >> previousContext: anObject [
	previousContext := anObject
]

{ #category : #printing }
GtDebuggerPharoMethodIndicatorSignal >> printOneLineContentsOn: aStream [
	(self indicator ifNotNil: #wantsToKeepScrollPosition)
		ifNotNil: [ :aBoolean | 
			aBoolean
				ifTrue: [ aStream nextPutAll: 'Keep scroll position' ]
				ifFalse: [ aStream nextPutAll: 'Scroll to new position' ] ]
		ifNil: [ super printOneLineContentsOn: aStream ]
]

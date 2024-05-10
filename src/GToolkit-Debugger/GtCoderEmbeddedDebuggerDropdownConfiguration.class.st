Class {
	#name : #GtCoderEmbeddedDebuggerDropdownConfiguration,
	#superclass : #Object,
	#classInstVars : [
		'userExtent'
	],
	#category : #'GToolkit-Debugger-Embedded - Support'
}

{ #category : #accessing }
GtCoderEmbeddedDebuggerDropdownConfiguration class >> contentExtent [
	^ self userExtent > (600 @ 400)
		ifFalse: [ self userExtent * 1.5 ]
		ifTrue: [ self userExtent * 1.2 ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDropdownConfiguration class >> contentExtentForContainerExtent: aContainerExtent [
	^ aContainerExtent > (600 @ 400)
		ifFalse: [ aContainerExtent * 1.5 ]
		ifTrue: [ aContainerExtent * 1.2 ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDropdownConfiguration class >> defaultExtent [
	^ 400 @ 250
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDropdownConfiguration class >> userExtent [
	^ userExtent ifNil: [ userExtent := self defaultExtent ]
]

{ #category : #accessing }
GtCoderEmbeddedDebuggerDropdownConfiguration class >> userExtent: aPoint [
	userExtent := aPoint
]

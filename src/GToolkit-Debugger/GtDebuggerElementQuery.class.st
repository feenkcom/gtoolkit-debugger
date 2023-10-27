Class {
	#name : #GtDebuggerElementQuery,
	#superclass : #BlElementQueryWrapper,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #queries }
GtDebuggerElementQuery >> playground [
	^ self ensureOne:  targetQuery // GtDebuggerPlaygroundElement
]

{ #category : #elements }
GtDebuggerElementQuery >> playgroundElement [
	^ self playground anyOne
]

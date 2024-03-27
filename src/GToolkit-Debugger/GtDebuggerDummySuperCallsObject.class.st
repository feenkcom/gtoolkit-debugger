Class {
	#name : #GtDebuggerDummySuperCallsObject,
	#superclass : #GtDebuggerDummySelfCallsObject,
	#category : #'GToolkit-Debugger-Dummies'
}

{ #category : #accessing }
GtDebuggerDummySuperCallsObject >> one [
	^ super one + 1
]

{ #category : #accessing }
GtDebuggerDummySuperCallsObject >> printString [
	^ super printString
]

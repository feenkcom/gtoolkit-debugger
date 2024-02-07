Class {
	#name : #GtDebuggerDummySelfCallsObject,
	#superclass : #Object,
	#instVars : [
		'instA'
	],
	#category : #'GToolkit-Debugger-Dummies'
}

{ #category : #initialization }
GtDebuggerDummySelfCallsObject >> initialize [
	super initialize.
	instA := 42
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> instAPlusOne [
	^ self sumA: instA b: instA
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> one [
	^ 1
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> sum39 [
	| a b |
	a := 3.
	b := 9.
	^ self sumA: a b: b
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> sum42 [
	| a b |
	a := 4.
	b := 2.
	^ self sumC: a d: b
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> sumA: valueA b: valueB [
	^ valueA + valueB
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> sumC: tempA d: tempB [
	^ self sumA: tempA b: tempB
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> three [
	^ self two + self one
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> two [
	^ self one + self one
]

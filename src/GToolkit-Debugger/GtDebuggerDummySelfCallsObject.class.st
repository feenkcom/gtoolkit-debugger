Class {
	#name : #GtDebuggerDummySelfCallsObject,
	#superclass : #Object,
	#instVars : [
		'instA'
	],
	#category : #'GToolkit-Debugger-Dummies'
}

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> * anObject [
	self shouldNotImplement
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> enumerate [
	^ #(3 6 9) inject: 1 into: [ :result :value | result raisedTo: value ]
]

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
GtDebuggerDummySelfCallsObject >> instAReceiver [
	| a |
	a := 3.
	^ instA raisedTo: a
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> one [
	self printString.
	^ 1
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> sum21 [
	| a |
	a := 2.
	^ self sumC: a d: 1
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
GtDebuggerDummySelfCallsObject >> tempReceiver [
	| a b |
	a := 3.
	b := 9.
	^ a raisedTo: b
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> three [
	^ self two + self one
]

{ #category : #accessing }
GtDebuggerDummySelfCallsObject >> two [
	^ self one + self one
]

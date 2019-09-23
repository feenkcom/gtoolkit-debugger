Class {
	#name : #GtEmbeddedDebuggerAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'debugSession',
		'signaledException',
		'debuggerElement'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #accessing }
GtEmbeddedDebuggerAttribute >> debugSession [
	^ debugSession
]

{ #category : #accessing }
GtEmbeddedDebuggerAttribute >> debugSession: aDebugSession [
	debugSession := aDebugSession
]

{ #category : #initialization }
GtEmbeddedDebuggerAttribute >> initialize [
	super initialize.
	
	self beAppend
]

{ #category : #accessing }
GtEmbeddedDebuggerAttribute >> signaledException [
	^ signaledException
]

{ #category : #accessing }
GtEmbeddedDebuggerAttribute >> signaledException: anException [
	signaledException := anException
]

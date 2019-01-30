Class {
	#name : #GtEmbeddedDebuggerAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'debugSession',
		'signaledException'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #initialization }
GtEmbeddedDebuggerAttribute >> affect: aBrText in: anEditorElement [
	| debuggerElement |
	debuggerElement := GtEmbeddedDebuggerElement new
		signaledException: self signaledException;
		session: self debugSession. 
	^ debuggerElement
]

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

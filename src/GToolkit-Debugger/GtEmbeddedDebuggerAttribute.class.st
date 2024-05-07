Class {
	#name : #GtEmbeddedDebuggerAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'debugSession',
		'signaledException',
		'debuggerViewModel'
	],
	#category : #'GToolkit-Debugger-Embedded - Text'
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
GtEmbeddedDebuggerAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	debuggerViewModel ifNil: [ 
		debuggerViewModel := GtCoderEmbeddedDebuggerViewModel new
			signaledException: self signaledException;
			debugSession: self debugSession ].

	^ GtCoderEmbeddedDebuggerElement new
		debuggerViewModel: debuggerViewModel
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

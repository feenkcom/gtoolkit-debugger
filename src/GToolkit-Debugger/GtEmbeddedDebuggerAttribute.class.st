Class {
	#name : #GtEmbeddedDebuggerAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'debuggerViewModel'
	],
	#category : #'GToolkit-Debugger-Embedded - Text'
}

{ #category : #accessing }
GtEmbeddedDebuggerAttribute >> debuggerViewModel [
	<return: #GtCoderEmbeddedDebuggerViewModel>
	^ debuggerViewModel
]

{ #category : #accessing }
GtEmbeddedDebuggerAttribute >> debuggerViewModel: aGtCoderEmbeddedDebuggerViewModel [
	debuggerViewModel := aGtCoderEmbeddedDebuggerViewModel
]

{ #category : #initialization }
GtEmbeddedDebuggerAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	debuggerViewModel ifNil: [ ^ #() ].

	^ GtCoderEmbeddedDebuggerElement new
		debuggerViewModel: debuggerViewModel
]

{ #category : #initialization }
GtEmbeddedDebuggerAttribute >> initialize [
	super initialize.
	
	self beAppend
]

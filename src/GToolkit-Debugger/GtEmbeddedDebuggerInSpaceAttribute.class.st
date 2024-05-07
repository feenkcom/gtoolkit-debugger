Class {
	#name : #GtEmbeddedDebuggerInSpaceAttribute,
	#superclass : #BrTextAdornmentAttribute,
	#instVars : [
		'evaluationStatus',
		'coderViewModel'
	],
	#category : #'GToolkit-Debugger-Embedded - Text'
}

{ #category : #accessing }
GtEmbeddedDebuggerInSpaceAttribute >> coderViewModel [
	^ coderViewModel
]

{ #category : #accessing }
GtEmbeddedDebuggerInSpaceAttribute >> coderViewModel: anObject [
	coderViewModel := anObject
]

{ #category : #initialization }
GtEmbeddedDebuggerInSpaceAttribute >> doAffect: aTBrTextEditorTextualPiece in: anEditorElement [
	^ GtCoderEmbeddedDebuggerInSpaceElement new 
		evaluationStatus: evaluationStatus;
		coderViewModel: coderViewModel
]

{ #category : #accessing }
GtEmbeddedDebuggerInSpaceAttribute >> evaluationStatus [
	<return: #GtCoderDebugSessionInSpaceEvaluationStatus>
	^ evaluationStatus
]

{ #category : #accessing }
GtEmbeddedDebuggerInSpaceAttribute >> evaluationStatus: anEvaluationStatus [
	evaluationStatus := anEvaluationStatus
]

{ #category : #initialization }
GtEmbeddedDebuggerInSpaceAttribute >> initialize [
	super initialize.
	
	self beAppend
]

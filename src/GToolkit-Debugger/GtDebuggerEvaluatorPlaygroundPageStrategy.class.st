Class {
	#name : #GtDebuggerEvaluatorPlaygroundPageStrategy,
	#superclass : #LeInspectorPlaygroundPageStrategy,
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #accessing }
GtDebuggerEvaluatorPlaygroundPageStrategy >> createNewPageForObject: anObject [
	| page |
	page := LePage unnamedPage.
	page addSnippet: LePharoSnippet new.
	^ page
]

{ #category : #accessing }
GtDebuggerEvaluatorPlaygroundPageStrategy >> playgroundPageType [
	^ LeUnnamedPageType
]

Class {
	#name : #GtExpandableDebuggerElement,
	#superclass : #GtAbstractExpandableDebuggerElement,
	#category : #'GToolkit-Debugger'
}

{ #category : #'tools registry' }
GtExpandableDebuggerElement class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry registerDebugger: self withRank: 1000.
]

{ #category : #'building widgets' }
GtExpandableDebuggerElement >> buildStackElement [
	| newStackElement |
	newStackElement := GtDebuggerExpandableStackElement new.
	newStackElement containerName: #stackElement.
	^ newStackElement
]

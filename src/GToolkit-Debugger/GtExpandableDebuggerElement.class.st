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

{ #category : #opening }
GtExpandableDebuggerElement >> aboutToOpen [
	"Select the first non filtered context. This mean that we will ignore some methods 
	like halts or debug method to select the first interesting stack frame in the debugger."
	self setDebuggerToFirstNonFilteredContext.
]

{ #category : #'building widgets' }
GtExpandableDebuggerElement >> buildStackElement [
	| newStackElement |
	newStackElement := GtDebuggerExpandableStackElement new.
	newStackElement containerName: #stackElement.
	^ newStackElement
]

Class {
	#name : #GtExpandableDebuggerElement2,
	#superclass : #GtExpandableDebuggerElement,
	#category : #'GToolkit-Debugger-GToolkit-Debugger'
}

{ #category : #accessing }
GtExpandableDebuggerElement2 class >> availableAutomatically [
	"Should this debugger be taken into account when looking for a debugger to handle an exception."
	
	^ false
]

{ #category : #accessing }
GtExpandableDebuggerElement2 class >> defaultTitle [
	^ 'Async Debugger'
]

{ #category : #accessing }
GtExpandableDebuggerElement2 class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry registerDebugger: self withRank: 1010.
]

{ #category : #accessing }
GtExpandableDebuggerElement2 >> aboutToOpen [
	
]

{ #category : #accessing }
GtExpandableDebuggerElement2 >> buildStackElement [
	| newStackElement |
	newStackElement := GtDebuggerExpandableStackElement2 new.
	newStackElement containerName: #stackElement.
	^ newStackElement
]

Class {
	#name : #GtPharoDebuggerElement,
	#superclass : #GtExpandableDebuggerElement,
	#category : #'GToolkit-Debugger-GToolkit-Debugger'
}

{ #category : #accessing }
GtPharoDebuggerElement >> buildStackElement [
	| newStackElement |
	newStackElement := GtPharoStackElement new.
	newStackElement containerName: #stackElement.
	^ newStackElement
]

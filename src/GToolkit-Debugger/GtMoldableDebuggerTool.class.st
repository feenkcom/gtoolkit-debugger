Class {
	#name : #GtMoldableDebuggerTool,
	#superclass : #GtPhlowTool,
	#instVars : [
		'debuggerElement'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #'api - converting' }
GtMoldableDebuggerTool >> asElementDo: aOneArgBlock [
	"Create a tool element and execute the block."
	^ aOneArgBlock cull: self debuggerElement
]

{ #category : #'api - converting' }
GtMoldableDebuggerTool >> canRecreateToolElement [
	^ false
]

{ #category : #accessing }
GtMoldableDebuggerTool >> debuggerElement [
	^ debuggerElement
]

{ #category : #accessing }
GtMoldableDebuggerTool >> debuggerElement: anObject [
	debuggerElement := anObject
]

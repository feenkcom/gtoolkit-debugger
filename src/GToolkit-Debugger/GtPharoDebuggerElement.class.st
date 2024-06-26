Class {
	#name : #GtPharoDebuggerElement,
	#superclass : #GtAbstractExpandableDebuggerElement,
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #accessing }
GtPharoDebuggerElement class >> debuggerSpecification [
	^ GtMoldableExceptionDefaultDebuggerSpecification new 
		debuggerClass: self
]

{ #category : #accessing }
GtPharoDebuggerElement class >> defaultTitle [
	^ 'GT'
]

{ #category : #'tools registry' }
GtPharoDebuggerElement class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry registerDebugger: self withRank: 1000.
]

{ #category : #accessing }
GtPharoDebuggerElement class >> sessionClass [
	^ GtFilteredDebugSession
]

{ #category : #accessing }
GtPharoDebuggerElement >> aboutToOpen [
	"Select the first non filtered context. This mean that we will ignore some methods 
	like halts or debug method to select the first interesting stack frame in the debugger."
	self setDebuggerToFirstNonFilteredContext.
]

{ #category : #'building widgets' }
GtPharoDebuggerElement >> buildStackElement [
	| newStackElement |
	newStackElement := GtPharoStackElement new.
	newStackElement id: #stackElement.
	^ newStackElement
]

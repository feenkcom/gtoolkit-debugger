Class {
	#name : #GtDebuggerSpecification,
	#superclass : #Object,
	#instVars : [
		'debuggerClass'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'api - testing' }
GtDebuggerSpecification >> availableAutomatically [
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> debuggerClass [
	^ debuggerClass
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> debuggerClass: aDebuggerClass [
	debuggerClass := aDebuggerClass
]

{ #category : #'api - testing' }
GtDebuggerSpecification >> handlesDebugSession: aDebugSession [
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> icon [
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> priority [
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> sessionClass [
	^ self debuggerClass sessionClass
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> title [
	self subclassResponsibility
]

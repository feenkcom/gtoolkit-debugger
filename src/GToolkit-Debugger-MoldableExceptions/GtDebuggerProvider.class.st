Class {
	#name : #GtDebuggerProvider,
	#superclass : #Object,
	#instVars : [
		'debuggerConfiguration'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'api - testing' }
GtDebuggerProvider >> availableAutomatically [
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerProvider >> debuggerConfiguration [
	^ debuggerConfiguration
]

{ #category : #'api - accessing' }
GtDebuggerProvider >> debuggerConfiguration: aDebuggerConfiguration [
	debuggerConfiguration := aDebuggerConfiguration
]

{ #category : #'api - testing' }
GtDebuggerProvider >> handlesDebugSession: aDebugSession [
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerProvider >> icon [
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerProvider >> sessionClass [
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerProvider >> title [
	self subclassResponsibility
]

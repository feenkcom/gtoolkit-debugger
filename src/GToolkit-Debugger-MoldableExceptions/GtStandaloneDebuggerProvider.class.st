Class {
	#name : #GtStandaloneDebuggerProvider,
	#superclass : #GtDebuggerProvider,
	#instVars : [
		'debuggerClass'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'api - testing' }
GtStandaloneDebuggerProvider >> availableAutomatically [
	^ debuggerClass availableAutomatically
]

{ #category : #initalization }
GtStandaloneDebuggerProvider >> debuggerClass: aDebuggerClass [
	debuggerClass := aDebuggerClass
]

{ #category : #'api - testing' }
GtStandaloneDebuggerProvider >> handlesDebugSession: aDebugSession [
	^ debuggerClass handlesDebugSession: aDebugSession
]

{ #category : #accessing }
GtStandaloneDebuggerProvider >> icon [
	^ debuggerClass defaultIcon
]

{ #category : #'api - accessing' }
GtStandaloneDebuggerProvider >> sessionClass [
	^ debuggerClass sessionClass
]

{ #category : #accessing }
GtStandaloneDebuggerProvider >> title [
	^ debuggerClass defaultTitle
]

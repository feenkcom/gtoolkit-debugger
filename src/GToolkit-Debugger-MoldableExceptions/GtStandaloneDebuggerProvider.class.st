Class {
	#name : #GtStandaloneDebuggerProvider,
	#superclass : #GtDebuggerProvider,
	#instVars : [
		'debuggerClass',
		'priority'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'api - testing' }
GtStandaloneDebuggerProvider >> availableAutomatically [
	^ debuggerClass availableAutomatically
]

{ #category : #initalization }
GtStandaloneDebuggerProvider >> debuggerClass [
	^ debuggerClass
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

{ #category : #accessing }
GtStandaloneDebuggerProvider >> priority [
	^ priority 
]

{ #category : #accessing }
GtStandaloneDebuggerProvider >> priority: aPriority [
	priority := aPriority
]

{ #category : #'api - accessing' }
GtStandaloneDebuggerProvider >> sessionClass [
	^ debuggerClass sessionClass
]

{ #category : #accessing }
GtStandaloneDebuggerProvider >> title [
	^ debuggerClass defaultTitle
]

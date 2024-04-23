Class {
	#name : #GtMoldableExceptionDebuggerProvider,
	#superclass : #GtDebuggerProvider,
	#instVars : [
		'availableAutomatically',
		'sessionClass'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'api - testing' }
GtMoldableExceptionDebuggerProvider >> availableAutomatically [
	^ debuggerConfiguration availableAutomatically
]

{ #category : #'api - testing' }
GtMoldableExceptionDebuggerProvider >> handlesDebugSession: aDebugSession [
	| targetException |
	
	targetException := aDebugSession exception.
	targetException ifNil: [ ^ false ].
	
	debuggerConfiguration targetException == targetException ifFalse: [ ^ false ].
	
	^ debuggerConfiguration canShowDebuggingExtension
]

{ #category : #'api - accessing' }
GtMoldableExceptionDebuggerProvider >> icon [
	^ debuggerConfiguration debuggerIcon  
]

{ #category : #'api - accessing' }
GtMoldableExceptionDebuggerProvider >> sessionClass [
	^ debuggerConfiguration sessionClass
]

{ #category : #'api - accessing' }
GtMoldableExceptionDebuggerProvider >> title [
	^ debuggerConfiguration debuggerTitle 
]

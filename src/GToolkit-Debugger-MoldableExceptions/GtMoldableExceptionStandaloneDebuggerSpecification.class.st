Class {
	#name : #GtMoldableExceptionStandaloneDebuggerSpecification,
	#superclass : #GtMoldableExceptionDebuggerSpecification,
	#instVars : [
		'debuggerPriority'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'api - testing' }
GtMoldableExceptionStandaloneDebuggerSpecification >> availableAutomatically [
	^ debuggerClass availableAutomatically
]

{ #category : #'api - debugger creation' }
GtMoldableExceptionStandaloneDebuggerSpecification >> createDebuggerWithSession: aDebuggingSession [
	^ self debuggerClass on: aDebuggingSession.
]

{ #category : #'api - testing' }
GtMoldableExceptionStandaloneDebuggerSpecification >> handlesDebugSession: aDebugSession [
	^ debuggerClass handlesDebugSession: aDebugSession
]

{ #category : #accessing }
GtMoldableExceptionStandaloneDebuggerSpecification >> icon [
	^ debuggerClass defaultIcon
]

{ #category : #accessing }
GtMoldableExceptionStandaloneDebuggerSpecification >> priority [
	^ debuggerPriority 
]

{ #category : #accessing }
GtMoldableExceptionStandaloneDebuggerSpecification >> priority: aPriority [
	debuggerPriority := aPriority
]

{ #category : #'api - accessing' }
GtMoldableExceptionStandaloneDebuggerSpecification >> sessionClass [
	^ debuggerClass sessionClass
]

{ #category : #accessing }
GtMoldableExceptionStandaloneDebuggerSpecification >> title [
	^ debuggerClass defaultTitle
]

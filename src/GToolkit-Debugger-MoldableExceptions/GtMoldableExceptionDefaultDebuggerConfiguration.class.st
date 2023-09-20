Class {
	#name : #GtMoldableExceptionDefaultDebuggerConfiguration,
	#superclass : #GtMoldableExceptionDebuggerConfiguration,
	#instVars : [
		'globalDebuggingActionPragmaNames'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'accessing - defaults' }
GtMoldableExceptionDefaultDebuggerConfiguration >> defaultGlobalDebuggingActionPragmas [
	^ #()
]

{ #category : #'accessing - configurarion' }
GtMoldableExceptionDefaultDebuggerConfiguration >> globalDebuggingActionPragmas [
	^ globalDebuggingActionPragmaNames ifNil: [
		self defaultGlobalDebuggingActionPragmas ]
]

{ #category : #configuration }
GtMoldableExceptionDefaultDebuggerConfiguration >> globalDebuggingActionPragmas: aCollection [
	"Configure the pragmas used to look for global debugging actions. These actions are specific to the exception, even in the default debugger."
	globalDebuggingActionPragmaNames := aCollection
]

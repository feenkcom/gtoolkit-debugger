Class {
	#name : #GtMoldableExceptionDebuggerConfiguration,
	#superclass : #Object,
	#instVars : [
		'globalDebuggingActionPragmaNames',
		'targetObjectDebuggingActionPragmaNames',
		'debuggingTargets',
		'targetException'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'instance creation' }
GtMoldableExceptionDebuggerConfiguration class >> forException: anException [
	^ self new
		 initializeForException: anException
]

{ #category : #configuration }
GtMoldableExceptionDebuggerConfiguration >> addDebuggingTargetFor: anObject [
	"Add a debugging target used to look for debugging views. It is possible to register multiple target objects, apart from the exception object."
	debuggingTargets addDebuggingTargetFor: anObject
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggerConfiguration >> collectTargetDebuggingActionsForDebugger: aDebuggerElement [
	^ debuggingTargets 
		collectTargetDebuggingActionsForPragmaNames: self targetObjectDebuggingActionPragmas
		forDebugger: aDebuggerElement
]

{ #category : #configuration }
GtMoldableExceptionDebuggerConfiguration >> debuggingActionPragmas: aCollection [
	"A utility method for configuring the same pragma for global and target-specific debugging actions."
	
	self globalDebuggingActionPragmas: aCollection.
	self targetObjectDebuggingActionPragmas: aCollection.
]

{ #category : #'accessing - defaults' }
GtMoldableExceptionDebuggerConfiguration >> defaultGlobalDebuggingActionPragmas [
	^ #()
]

{ #category : #'accessing - defaults' }
GtMoldableExceptionDebuggerConfiguration >> defaultTargetObjectDebuggingActionPragmas [
	^ #()
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggerConfiguration >> globalDebuggingActionPragmas [
	^ globalDebuggingActionPragmaNames ifNil: [
		self defaultGlobalDebuggingActionPragmas ]
]

{ #category : #configuration }
GtMoldableExceptionDebuggerConfiguration >> globalDebuggingActionPragmas: aCollection [
	"Configure the pragmas used to look for global debugging actions. These actions are specific to the exception."
	globalDebuggingActionPragmaNames := aCollection
]

{ #category : #initialization }
GtMoldableExceptionDebuggerConfiguration >> initialize [
	super initialize.
	
	debuggingTargets := GtMoldableExceptionDebuggingViewTargets new
]

{ #category : #initialization }
GtMoldableExceptionDebuggerConfiguration >> initializeForException: anException [
	targetException := anException.
	
	self withDebuggingExceptionTargetFor: anException
]

{ #category : #accessing }
GtMoldableExceptionDebuggerConfiguration >> targetException [
	^ targetException
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggerConfiguration >> targetObjectDebuggingActionPragmas [
	^ targetObjectDebuggingActionPragmaNames ifNil: [
		self defaultTargetObjectDebuggingActionPragmas ]
]

{ #category : #configuration }
GtMoldableExceptionDebuggerConfiguration >> targetObjectDebuggingActionPragmas: aCollection [
	"Configure the pragmas used to look for phlow debugging actions attached to target objects. These actions are specific to this exception."
	targetObjectDebuggingActionPragmaNames := aCollection
]

{ #category : #configuration }
GtMoldableExceptionDebuggerConfiguration >> withDebuggingExceptionTargetFor: aTargetException [
	"Use the given exception to look for debugging views"
	debuggingTargets withDebuggingExceptionTargetFor: aTargetException
]

{ #category : #configuration }
GtMoldableExceptionDebuggerConfiguration >> withoutDebuggingExceptionTarget [
	"Indicate that the current exception should not be used for looking for debugging views"
	debuggingTargets withoutDebuggingExceptionTarget
]

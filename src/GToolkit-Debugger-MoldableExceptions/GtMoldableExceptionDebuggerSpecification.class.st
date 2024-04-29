Class {
	#name : #GtMoldableExceptionDebuggerSpecification,
	#superclass : #GtDebuggerSpecification,
	#instVars : [
		'globalDebuggingActionPragmaNames',
		'targetObjectDebuggingActionPragmaNames',
		'debuggingTargets',
		'targetException'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'instance creation' }
GtMoldableExceptionDebuggerSpecification class >> forException: anException [
	^ self new
		 initializeForException: anException
]

{ #category : #configuration }
GtMoldableExceptionDebuggerSpecification >> addDebuggingTargetFor: anObject [
	"Add a debugging target used to look for debugging views. It is possible to register multiple target objects, apart from the exception object."
	debuggingTargets addDebuggingTargetFor: anObject
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggerSpecification >> collectTargetDebuggingActionsForDebugger: aDebuggerElement [
	^ debuggingTargets 
		collectTargetDebuggingActionsForPragmaNames: self targetObjectDebuggingActionPragmas
		forDebugger: aDebuggerElement
]

{ #category : #configuration }
GtMoldableExceptionDebuggerSpecification >> debuggingActionPragmas: aCollection [
	"A utility method for configuring the same pragma for global and target-specific debugging actions."
	
	self globalDebuggingActionPragmas: aCollection.
	self targetObjectDebuggingActionPragmas: aCollection.
]

{ #category : #'accessing - defaults' }
GtMoldableExceptionDebuggerSpecification >> defaultGlobalDebuggingActionPragmas [
	^ #()
]

{ #category : #'accessing - defaults' }
GtMoldableExceptionDebuggerSpecification >> defaultTargetObjectDebuggingActionPragmas [
	^ #()
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggerSpecification >> globalDebuggingActionPragmas [
	^ globalDebuggingActionPragmaNames ifNil: [
		self defaultGlobalDebuggingActionPragmas ]
]

{ #category : #configuration }
GtMoldableExceptionDebuggerSpecification >> globalDebuggingActionPragmas: aCollection [
	"Configure the pragmas used to look for global debugging actions. These actions are specific to the exception."
	globalDebuggingActionPragmaNames := aCollection
]

{ #category : #initialization }
GtMoldableExceptionDebuggerSpecification >> initialize [
	super initialize.
	
	debuggingTargets := GtMoldableExceptionDebuggingViewTargets new
]

{ #category : #initialization }
GtMoldableExceptionDebuggerSpecification >> initializeForException: anException [
	targetException := anException.
	
	self withDebuggingExceptionTargetFor: anException
]

{ #category : #accessing }
GtMoldableExceptionDebuggerSpecification >> specificationProperties [
	^ super specificationProperties, {
		{'Debugging Targets' . debuggingTargets. debuggingTargets description}.
		{'Action Pragmas' . self targetObjectDebuggingActionPragmas}.
		{'Global Action Pragmas' . self globalDebuggingActionPragmas}
	}
]

{ #category : #accessing }
GtMoldableExceptionDebuggerSpecification >> targetException [
	^ targetException
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggerSpecification >> targetObjectDebuggingActionPragmas [
	^ targetObjectDebuggingActionPragmaNames ifNil: [
		self defaultTargetObjectDebuggingActionPragmas ]
]

{ #category : #configuration }
GtMoldableExceptionDebuggerSpecification >> targetObjectDebuggingActionPragmas: aCollection [
	"Configure the pragmas used to look for phlow debugging actions attached to target objects. These actions are specific to this exception."
	targetObjectDebuggingActionPragmaNames := aCollection
]

{ #category : #configuration }
GtMoldableExceptionDebuggerSpecification >> withDebuggingExceptionTargetFor: aTargetException [
	"Use the given exception to look for debugging views"
	debuggingTargets withDebuggingExceptionTargetFor: aTargetException
]

{ #category : #configuration }
GtMoldableExceptionDebuggerSpecification >> withoutDebuggingExceptionTarget [
	"Indicate that the current exception should not be used for looking for debugging views"
	debuggingTargets withoutDebuggingExceptionTarget
]

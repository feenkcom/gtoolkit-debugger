Class {
	#name : #GtMoldableExceptionDebuggingToolConfiguration,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'instance creation' }
GtMoldableExceptionDebuggingToolConfiguration class >> forException: anException [
	^ self new
		 initializeForException: anException
]

{ #category : #initialization }
GtMoldableExceptionDebuggingToolConfiguration >> initializeForException: anException [
	"Perform an initialization of the configuration based on the given extension."
]

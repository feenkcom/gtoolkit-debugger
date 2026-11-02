Class {
	#name : #GtMoldableExceptionBasicTransformation,
	#superclass : #Object,
	#instVars : [
		'targetException'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'instance creation' }
GtMoldableExceptionBasicTransformation class >> forException: anException [ 
	^ self new
		targetException: anException
]

{ #category : #action }
GtMoldableExceptionBasicTransformation >> performTransformation [
	"Apply the changes through a recorded change, so that they can be undone and keep the undo history"

	^ GtRefactoryChangeManager instance performChange: self transformationNamespace changes
]

{ #category : #testing }
GtMoldableExceptionBasicTransformation >> shouldTransform [
	self subclassResponsibility
]

{ #category : #'instance creation' }
GtMoldableExceptionBasicTransformation >> targetException [
	^ targetException
]

{ #category : #'instance creation' }
GtMoldableExceptionBasicTransformation >> targetException: anException [ 
	targetException := anException 
]

{ #category : #accessing }
GtMoldableExceptionBasicTransformation >> transformationNamespace [
	self subclassResponsibility
]

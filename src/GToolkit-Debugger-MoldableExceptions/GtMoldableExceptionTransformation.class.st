Class {
	#name : #GtMoldableExceptionTransformation,
	#superclass : #GtMoldableExceptionBasicTransformation,
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #testing }
GtMoldableExceptionTransformation >> shouldTransform [
	^ self targetException shouldTransform
]

{ #category : #accessing }
GtMoldableExceptionTransformation >> transformationNamespace [
	^ self targetException transformationNamespace
]

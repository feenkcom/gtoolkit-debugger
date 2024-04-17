Trait {
	#name : #TGtMoldableExceptionSignalWithTransformation,
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #accessing }
TGtMoldableExceptionSignalWithTransformation >> gtMoldableExceptionTransformation [
	^ GtMoldableExceptionTransformation forException: self
]

{ #category : #signaling }
TGtMoldableExceptionSignalWithTransformation >> signal [
	| transformation |
	(self gtDebuggingTransformationsSettings 
		canApplyAutomaticTransformationForException: self) ifFalse: [ 
			^ super signal ].
	
	transformation := self gtMoldableExceptionTransformation.
	transformation shouldTransform ifFalse: [ ^ self signal].
	transformation performTransformation
]

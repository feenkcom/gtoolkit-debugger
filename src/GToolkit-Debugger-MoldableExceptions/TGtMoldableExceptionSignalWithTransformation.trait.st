Trait {
	#name : #TGtMoldableExceptionSignalWithTransformation,
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #accessing }
TGtMoldableExceptionSignalWithTransformation >> canApplyAutomaticTransformation [
	^ (self gtDebuggingTransformationsSettings 
		canApplyAutomaticTransformationForException: self)
]

{ #category : #accessing }
TGtMoldableExceptionSignalWithTransformation >> gtMoldableExceptionTransformation [
	^ GtMoldableExceptionTransformation forException: self
]

{ #category : #signaling }
TGtMoldableExceptionSignalWithTransformation >> signal [
	<debuggerCompleteToSender>
	| transformation |
	self canApplyAutomaticTransformation ifFalse: [ 
		^ super signal ].
	
	transformation := self gtMoldableExceptionTransformation.
	transformation shouldTransform ifFalse: [ ^ super signal ].
	transformation performTransformation
]

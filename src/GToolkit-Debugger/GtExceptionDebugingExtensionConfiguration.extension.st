Extension { #name : #GtExceptionDebugingExtensionConfiguration }

{ #category : #'*GToolkit-Debugger' }
GtExceptionDebugingExtensionConfiguration class >> forException: anException [
	^ self new
		 withDebuggingExceptionTargetFor: anException
]

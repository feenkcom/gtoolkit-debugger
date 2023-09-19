Extension { #name : #Exception }

{ #category : #'*GToolkit-Debugger' }
Exception >> asDebuggableElement [
	^ BrDebuggableElementStencil new
		freeze: self;
		asElement
]

{ #category : #'*GToolkit-Debugger' }
Exception >> gtDebuggingExtensionConfiguration [
	"Return a debugging configuration with default values."
	
	^ GtMoldableExceptionDebugingExtensionConfiguration forException: self
]

{ #category : #'*GToolkit-Debugger' }
Exception >> gtDebuggingTransformationsSettings [
	"Return the current settings for transformations."
	
	^ GtMoldableExceptionTransformationsSettings defaultInstance
]

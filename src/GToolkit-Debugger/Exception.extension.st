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

{ #category : #'*GToolkit-Debugger' }
Exception >> gtDefaultDebuggerExtensionConfiguration [
	"Return a debugging configuration used to customize the default debugger."
	
	^ GtMoldableExceptionDefaultDebuggerConfiguration forException: self
]

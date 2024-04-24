Extension { #name : #Exception }

{ #category : #'*GToolkit-Debugger' }
Exception >> asDebuggableElement [
	^ BrDebuggableElementStencil new
		freeze: self;
		asElement
]

{ #category : #'*GToolkit-Debugger' }
Exception >> gtDebuggingTransformationsSettings [
	"Return the current settings for transformations."
	
	^ GtMoldableExceptionTransformationsSettings defaultInstance
]

{ #category : #'*GToolkit-Debugger' }
Exception >> gtDefaultDebuggerSpecification [
	"Return a debugger specification used to customize the default debugger."
	
	^ GtPharoDebuggerElement debuggerSpecification
		initializeForException: self
]

{ #category : #'*GToolkit-Debugger' }
Exception >> gtExceptionDebuggerSpecification [
	<gtDebuggerSpecification>
	"Return a debugger specification with default values."
	
	^ GtMoldableExceptionSpecificDebuggerSpecification forException: self
]

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

{ #category : #'*GToolkit-Debugger' }
Exception >> gtExceptionEmbeddedDebuggerSpecification [
	"Return a debugger specification with default values."

	"<gtDebuggerSpecification>"
	^ self gtExceptionDebuggerSpecification
		title: 'Embedded debugger';
		priority: 1500;
		availableAutomatically: false;
		debuggingViewPragmas: #(gtEmbeddedDebuggerView);
		targetObjectDebuggingActionPragmas: #(gtEmbeddedDebuggerAction)
]

{ #category : #'*GToolkit-Debugger' }
Exception >> logStackToFile [
	[ [ Smalltalk 
		logError: 'logStackToFile: ', self messageText asString 
		inContext: self signalerContext ] onErrorDo: [ :anError |
			Smalltalk  logErrorMessage: anError messageText ] ]
	valueWithin: 1000 milliSeconds onTimeout: [  
		Smalltalk  logErrorMessage: 'Timeout while logging exception to stack' ]
]

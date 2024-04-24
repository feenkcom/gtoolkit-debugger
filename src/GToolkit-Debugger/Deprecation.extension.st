Extension { #name : #Deprecation }

{ #category : #'*GToolkit-Debugger' }
Deprecation >> context [
	^ context
]

{ #category : #'*GToolkit-Debugger' }
Deprecation >> gtExceptionDebuggerSpecification [
	^ super gtExceptionDebuggerSpecification
		title: 'Deprecation'
]

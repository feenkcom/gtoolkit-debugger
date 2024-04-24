Extension { #name : #Warning }

{ #category : #'*GToolkit-Debugger' }
Warning >> gtExceptionDebuggerSpecification [
	^ super gtExceptionDebuggerSpecification
		title: 'Warning';
		globalDebuggingActionPragmas: #(gtExceptionWarningActions)
]

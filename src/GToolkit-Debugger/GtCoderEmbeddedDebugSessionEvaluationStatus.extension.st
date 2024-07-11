Extension { #name : #GtCoderEmbeddedDebugSessionEvaluationStatus }

{ #category : #'*GToolkit-Debugger' }
GtCoderEmbeddedDebugSessionEvaluationStatus >> debuggerViewModel [
	<return: #GtCoderEmbeddedDebuggerViewModel>
	^ self
		optionAt: GtCoderEmbeddedDebuggerViewModel
		ifAbsentPut: [ GtCoderEmbeddedDebuggerViewModel new
					signaledException: self exception;
					debugSession: self sharedDebugSession ]
]

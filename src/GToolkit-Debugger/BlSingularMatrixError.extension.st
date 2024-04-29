Extension { #name : #BlSingularMatrixError }

{ #category : #'*GToolkit-Debugger' }
BlSingularMatrixError >> gtDefaultDebuggerSpecification [
	^ super gtDefaultDebuggerSpecification
		receiverViewPragmaNames: #(gtSingularMatrixErrorView)
]

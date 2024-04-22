Extension { #name : #BlSingularMatrixError }

{ #category : #'*GToolkit-Debugger' }
BlSingularMatrixError >> gtDefaultDebuggerExtensionConfiguration [
	^ super gtDefaultDebuggerExtensionConfiguration
		receiverViewPragmaNames: #(gtSingularMatrixErrorView)
]

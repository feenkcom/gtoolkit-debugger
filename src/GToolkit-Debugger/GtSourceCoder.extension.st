Extension { #name : #GtSourceCoder }

{ #category : #'*GToolkit-Debugger' }
GtSourceCoder >> embeddedDebuggerAddOnFor: anAST into: coderAddOns [
	<gtAstCoderAddOns: 80>
	coderAddOns addStyler: GtEmbeddedDebuggerStyler new.
	coderAddOns addStyler: GtEmbeddedDebuggerInSpaceStyler new.
]

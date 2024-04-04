Extension { #name : #Object }

{ #category : #'*GToolkit-DebuggerExtensions' }
Object >> gtDebuggerPrintForComparison [
	^ String streamContents: [ :aStream |
		self gtDebuggerPrintForComparisonOn: aStream ]
]

{ #category : #'*GToolkit-DebuggerExtensions' }
Object >> gtDebuggerPrintForComparisonOn: aStream [
	self printOn: aStream
]

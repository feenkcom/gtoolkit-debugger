Extension { #name : #Collection }

{ #category : #'*GToolkit-DebuggerExtensions' }
Collection >> gtDebuggerPrintForComparisonOn: aStream [
	GtDebuggerComparatorCollectionPrinter printWithSorting: self on: aStream
]

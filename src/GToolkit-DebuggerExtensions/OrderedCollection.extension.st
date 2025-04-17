Extension { #name : #OrderedCollection }

{ #category : #'*GToolkit-DebuggerExtensions' }
OrderedCollection >> gtDebuggerPrintForComparisonOn: aStream [
	GtDebuggerComparatorCollectionPrinter printWithoutSorting: self on: aStream
]

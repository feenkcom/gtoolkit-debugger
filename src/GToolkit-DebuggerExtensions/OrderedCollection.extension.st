Extension { #name : #OrderedCollection }

{ #category : #'*GToolkit-DebuggerExtensions' }
OrderedCollection >> gtDebuggerPrintForComparisonOn: aStream [
	GtDebuggerComparatorDictionaryPrinter printWithoutSorting: self on: aStream
]

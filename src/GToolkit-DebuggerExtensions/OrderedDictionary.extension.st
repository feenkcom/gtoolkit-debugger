Extension { #name : #OrderedDictionary }

{ #category : #'*GToolkit-DebuggerExtensions' }
OrderedDictionary >> gtDebuggerPrintForComparisonOn: aStream [
	GtDebuggerComparatorDictionaryPrinter printWithoutSorting: self on: aStream
]

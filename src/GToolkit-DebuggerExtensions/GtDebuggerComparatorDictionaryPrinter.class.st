Class {
	#name : #GtDebuggerComparatorDictionaryPrinter,
	#superclass : #GtDebuggerComparatorCollectionPrinter,
	#category : #'GToolkit-DebuggerExtensions-TextualComparison'
}

{ #category : #accessing }
GtDebuggerComparatorDictionaryPrinter >> printItem: anAssociation on: aStream [ 
	aStream << anAssociation key asString.
	aStream << ' -> '.
	aStream << anAssociation value asString.
]

{ #category : #accessing }
GtDebuggerComparatorDictionaryPrinter >> targetCollectionFrom: aDictionary [ 
	^ self shouldSort 
		ifTrue: [ aDictionary associations 
			sorted: [ :assocA :assocB | assocA key asString <= assocB key asString ] ] 
		ifFalse: [ aDictionary associations ]
]

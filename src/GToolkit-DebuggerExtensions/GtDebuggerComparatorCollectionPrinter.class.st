Class {
	#name : #GtDebuggerComparatorCollectionPrinter,
	#superclass : #Object,
	#instVars : [
		'shouldSort'
	],
	#category : #'GToolkit-DebuggerExtensions-TextualComparison'
}

{ #category : #accessing }
GtDebuggerComparatorCollectionPrinter class >> print: aCollection on: aStream [ 
	^ self new 
		print: aCollection on: aStream 
]

{ #category : #accessing }
GtDebuggerComparatorCollectionPrinter class >> printWithSorting: aCollection on: aStream [
	self new 
		enableSorting;
		print: aCollection on: aStream 
]

{ #category : #accessing }
GtDebuggerComparatorCollectionPrinter class >> printWithoutSorting: aCollection on: aStream [
	self new 
		print: aCollection on: aStream 
]

{ #category : #accessing }
GtDebuggerComparatorCollectionPrinter >> enableSorting [
	shouldSort := true
]

{ #category : #printing }
GtDebuggerComparatorCollectionPrinter >> print: aCollection on: aStream [
	| targetCollection currentIterationIndex |
	
	targetCollection := self targetCollectionFrom: aCollection.
	currentIterationIndex := 0.
	
	targetCollection 
		do: [ :anObject |
			currentIterationIndex := currentIterationIndex + 1.
			self printItem: anObject on: aStream.
			
			currentIterationIndex >= aCollection gtCollectionSizeThreshold ifTrue: [ 
				"Avoid printing large collections"
				aStream 
					cr;
					<< 'Collection too large. Increase the threshold to include more elements'.
				^ self ] ] 
		separatedBy: [ 
			aStream cr ]
]

{ #category : #printing }
GtDebuggerComparatorCollectionPrinter >> printItem: anObject on: aStream [ 
	aStream << anObject asString
]

{ #category : #testing }
GtDebuggerComparatorCollectionPrinter >> shouldSort [
	^ shouldSort ifNil: [ false ]
]

{ #category : #accessing }
GtDebuggerComparatorCollectionPrinter >> targetCollectionFrom: aCollection [ 
	^ self shouldSort 
		ifTrue: [ aCollection sorted: [ :a :b | a asString <= b asString ] ] 
		ifFalse: [ aCollection ]
]

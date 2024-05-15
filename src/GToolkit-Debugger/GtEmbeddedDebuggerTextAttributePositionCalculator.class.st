Class {
	#name : #GtEmbeddedDebuggerTextAttributePositionCalculator,
	#superclass : #Object,
	#instVars : [
		'sourceString',
		'sourceInterval',
		'evaluatedCodeInterval',
		'targetText',
		'sourceEndInText',
		'sourceStartInText',
		'attributeIndex',
		'isSourceFound'
	],
	#category : #'GToolkit-Debugger-Embedded - Text'
}

{ #category : #'accessing - computed' }
GtEmbeddedDebuggerTextAttributePositionCalculator >> attributeIndex [
	<return: #Integer or: nil>
	^ attributeIndex
]

{ #category : #computing }
GtEmbeddedDebuggerTextAttributePositionCalculator >> compute [
	<return: #Integer or: nil>
	isSourceFound := false.
	sourceStartInText := targetText finder
			caseSensitiveSubstring: sourceString;
			startAtPosition: sourceInterval first;
			searchClosest.	
			
	"what did we evaluate?"
	sourceStartInText isZero ifTrue: [ ^ nil ].
	isSourceFound := true.
	sourceEndInText := sourceStartInText + sourceString size - 1 min: targetText size.
			
	attributeIndex := evaluatedCodeInterval value
		ifNil: [ sourceEndInText ] 
		ifNotNil: [ :aContextInterval | (aContextInterval last + sourceStartInText - 1) min: targetText size ].
		
	^ attributeIndex
]

{ #category : #accessing }
GtEmbeddedDebuggerTextAttributePositionCalculator >> evaluatedCodeInterval [
	<return: #Interval or: #BlockClosure>
	^ evaluatedCodeInterval
]

{ #category : #accessing }
GtEmbeddedDebuggerTextAttributePositionCalculator >> evaluatedCodeInterval: anObject [
	evaluatedCodeInterval := anObject
]

{ #category : #'accessing - computed' }
GtEmbeddedDebuggerTextAttributePositionCalculator >> isSourceFound [
	^ isSourceFound
]

{ #category : #'accessing - computed' }
GtEmbeddedDebuggerTextAttributePositionCalculator >> sourceEndInText [
	<return: #Integer or: nil>
	^ sourceEndInText
]

{ #category : #accessing }
GtEmbeddedDebuggerTextAttributePositionCalculator >> sourceInterval [
	"Return evaluated source interval"

	<return: #Interval>
	^ sourceInterval
]

{ #category : #accessing }
GtEmbeddedDebuggerTextAttributePositionCalculator >> sourceInterval: anObject [
	sourceInterval := anObject
]

{ #category : #'accessing - computed' }
GtEmbeddedDebuggerTextAttributePositionCalculator >> sourceStartInText [
	<return: #Integer or: nil>
	^ sourceStartInText
]

{ #category : #accessing }
GtEmbeddedDebuggerTextAttributePositionCalculator >> sourceString [
	"Return evaluated source string"

	<return: #String>
	^ sourceString
]

{ #category : #accessing }
GtEmbeddedDebuggerTextAttributePositionCalculator >> sourceString: anObject [
	sourceString := anObject
]

{ #category : #accessing }
GtEmbeddedDebuggerTextAttributePositionCalculator >> targetText [
	<return: #BlRope>
	^ targetText
]

{ #category : #accessing }
GtEmbeddedDebuggerTextAttributePositionCalculator >> targetText: anObject [
	targetText := anObject
]

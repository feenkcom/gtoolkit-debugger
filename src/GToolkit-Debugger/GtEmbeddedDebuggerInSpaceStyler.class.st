Class {
	#name : #GtEmbeddedDebuggerInSpaceStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'GToolkit-Debugger'
}

{ #category : #'api - styling' }
GtEmbeddedDebuggerInSpaceStyler >> extraStyle: aText ast: theAst [
	| aStatus anEvaluatedSource anEvaluatedInterval theSourceStartInText theSourceEndInText anAttribute |
	super extraStyle: aText ast: theAst.

	self coderViewModel ifNil: [ ^ self ].
	aStatus := self coderViewModel evaluationStatus.
	aStatus ifNil: [ ^ self ].
	aStatus hasDebugSessionInSpace ifFalse: [ ^ self ].

	anEvaluatedSource := aStatus sourceString.
	anEvaluatedInterval := aStatus sourceInterval.
	theSourceStartInText := aText finder
			caseSensitiveSubstring: anEvaluatedSource;
			startAtPosition: anEvaluatedInterval first;
			searchClosest.
			
	"what did we evaluate?"
	theSourceStartInText isZero ifTrue: [ ^ self ].
	theSourceEndInText := theSourceStartInText + anEvaluatedSource size - 1
			min: aText size.

	aText
		clearAttributes: [ :each | {GtEmbeddedDebuggerInSpaceAttribute} anySatisfy: [ :cls | each isKindOf: cls ] ].
	anAttribute := GtEmbeddedDebuggerInSpaceAttribute new
		evaluationStatus: aStatus;
		coderViewModel: self coderViewModel.
	aText
		attribute: anAttribute
		from: theSourceEndInText
		to: theSourceEndInText
]

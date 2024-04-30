Class {
	#name : #GtEmbeddedDebuggerStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'GToolkit-Debugger'
}

{ #category : #'api - styling' }
GtEmbeddedDebuggerStyler >> extraStyle: aText ast: theAst [
	| aStatus anEvaluatedSource anEvaluatedInterval theSourceStartInText theSourceEndInText anAttribute |
	super extraStyle: aText ast: theAst.

	self coderViewModel ifNil: [ ^ self ].
	aStatus := self coderViewModel evaluationStatus.
	aStatus ifNil: [ ^ self ].
	aStatus hasSharedDebugSession ifFalse: [ ^ self ].

	anEvaluatedSource := aStatus sourceString.
	anEvaluatedInterval := aStatus sourceInterval.
	theSourceStartInText := aText finder
			caseSensitiveSubstring: anEvaluatedSource;
			startAtPosition: anEvaluatedInterval first;
			searchClosest.	"what did we evaluate?"
	theSourceStartInText isZero ifTrue: [ ^ self ].
	theSourceEndInText := theSourceStartInText + anEvaluatedSource size - 1
			min: aText size.

	aText
		clearAttributes: [ :each | {GtEmbeddedDebuggerAttribute} anySatisfy: [ :cls | each isKindOf: cls ] ].
	anAttribute := GtEmbeddedDebuggerAttribute new
			signaledException: aStatus exception;
			debugSession: aStatus sharedDebugSession.
	aText
		attribute: anAttribute
		from: theSourceEndInText
		to: theSourceEndInText
]

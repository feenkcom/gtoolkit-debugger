Class {
	#name : #GtEmbeddedDebuggerInSpaceStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'GToolkit-Debugger-Embedded - Text'
}

{ #category : #'api - styling' }
GtEmbeddedDebuggerInSpaceStyler >> extraStyle: aText ast: theAst [
	| aStatus anAttribute anAttributeIndex |
	super extraStyle: aText ast: theAst.

	self coderViewModel ifNil: [ ^ self ].
	aStatus := self coderViewModel evaluationStatus.
	aStatus ifNil: [ ^ self ].
	aStatus hasDebugSessionInSpace ifFalse: [ ^ self ].

	anAttributeIndex := GtEmbeddedDebuggerTextAttributePositionCalculator new
		sourceString: aStatus sourceString;
		sourceInterval: aStatus sourceInterval;
		evaluatedCodeInterval: [ aStatus evaluatedCodeInterval ];
		targetText: aText;
		compute.

	anAttributeIndex ifNil: [ ^ self ].

	anAttribute := GtEmbeddedDebuggerInSpaceAttribute new
		evaluationStatus: aStatus;
		coderViewModel: self coderViewModel.
	aText
		attribute: anAttribute
		from: anAttributeIndex
		to: anAttributeIndex
]

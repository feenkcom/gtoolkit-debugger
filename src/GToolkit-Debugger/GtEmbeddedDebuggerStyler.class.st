Class {
	#name : #GtEmbeddedDebuggerStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'GToolkit-Debugger-Embedded - Text'
}

{ #category : #'api - styling' }
GtEmbeddedDebuggerStyler >> extraStyle: aText ast: theAst [
	| aStatus anAttribute anAttributeIndex |
	super extraStyle: aText ast: theAst.

	self coderViewModel ifNil: [ ^ self ].
	aStatus := self coderViewModel evaluationStatus.
	aStatus ifNil: [ ^ self ].
	aStatus hasSharedDebugSession ifFalse: [ ^ self ].

	anAttributeIndex := GtEmbeddedDebuggerTextAttributePositionCalculator new
		sourceString: aStatus sourceString;
		sourceInterval: aStatus sourceInterval;
		evaluatedCodeInterval: [ aStatus evaluatedCodeInterval ];
		targetText: aText;
		compute.

	anAttributeIndex ifNil: [ ^ self ].
		
	anAttribute := GtEmbeddedDebuggerAttribute new
			debuggerViewModel: aStatus debuggerViewModel.
	
	aText
		attribute: anAttribute
		from: anAttributeIndex
		to: anAttributeIndex
]

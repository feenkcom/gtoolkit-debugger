Class {
	#name : #GtEmbeddedDebuggerStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'GToolkit-Debugger-Embedded - Text'
}

{ #category : #comparing }
GtEmbeddedDebuggerStyler >> = anObject [
	self class ~~ anObject class ifTrue: [ ^ false ].
	(self coderViewModel isNil or: [ anObject coderViewModel isNil ])
		ifTrue: [ ^ true ].
	self coderViewModel ~= anObject coderViewModel ifTrue: [ ^ false ].


	^ self coderViewModel evaluationStatus
		= anObject coderViewModel evaluationStatus
]

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

{ #category : #comparing }
GtEmbeddedDebuggerStyler >> hash [
	^super hash
]

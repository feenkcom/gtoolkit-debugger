Class {
	#name : #GtEmbeddedDebuggerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #examples }
GtEmbeddedDebuggerExamples >> coderWithDivideByZeroError [
	<gtExample>
	<noTest>
	| sourceCode coder debuggerAttributes |
	sourceCode := '1/0'.
	coder := GtPharoSnippetCoder new
	 source: sourceCode.
	coder doItAll.
	debuggerAttributes := self debuggerAttributesIn: coder at: sourceCode size.
	self assert: coder sourceEditor text asString equals: sourceCode.
	self assert: debuggerAttributes size equals: 1.
	^ coder
]

{ #category : #examples }
GtEmbeddedDebuggerExamples >> debuggerAttributeDivideByZero [
	<gtExample>
	<noTest>
	| debuggerAttribute coder  |
	coder := self coderWithDivideByZeroError.
	debuggerAttribute := (self debuggerAttributesIn: coder at: 3) first.
	self assert: debuggerAttribute signaledException class equals: ZeroDivide.
	^ debuggerAttribute
]

{ #category : #accessing }
GtEmbeddedDebuggerExamples >> debuggerAttributesIn: aCoder at: anIndex [
	^ ((aCoder sourceText attributesAt: anIndex) select: [ :each | 
		each isKindOf: GtEmbeddedDebuggerAttribute ])
]

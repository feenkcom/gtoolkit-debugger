Class {
	#name : #GtEmbeddedDebuggerExamples,
	#superclass : #Object,
	#instVars : [
		'coderProcess'
	],
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #examples }
GtEmbeddedDebuggerExamples >> coderWithDivideByZeroError [
	<gtExample>
	<after: #terminateCoderProcess>
	<noTest>
	| sourceCode coder debuggerAttributes debuggerAttribute |
	sourceCode := '1/0'.
	coderProcess := [
		coder := GtPharoSnippetCoder forSource: sourceCode.
		coder doItAll ] newProcess.
	coderProcess resume.
	
	self waitUntilSuspendedFor: coderProcess.
	self assert: coderProcess isSuspended.
	
	debuggerAttributes := self debuggerAttributesIn: coder at: sourceCode size.
	self assert: coder sourceEditor text asString equals: sourceCode.
	self assert: debuggerAttributes size equals: 1.
	
	debuggerAttribute := debuggerAttributes first.
	self assert: debuggerAttribute signaledException class equals: ZeroDivide.
	self assert: debuggerAttribute debugSession notNil.
	self assert: debuggerAttribute debugSession interruptedProcess equals: coderProcess.
	^ coder
]

{ #category : #private }
GtEmbeddedDebuggerExamples >> debuggerAttributesIn: aCoder at: anIndex [
	^ (aCoder currentSourceText attributesAt: anIndex)
		select: [ :each | each isKindOf: GtEmbeddedDebuggerAttribute ]
]

{ #category : #private }
GtEmbeddedDebuggerExamples >> terminateCoderProcess [
	(coderProcess isNotNil and: [ coderProcess isTerminated not ])
		ifTrue: [ ('terminate ' , coderProcess asString) traceCr.
			coderProcess terminate ]
]

{ #category : #private }
GtEmbeddedDebuggerExamples >> waitUntilSuspendedFor: aProcess [.
	"Wait at most a second for the given process to become suspended."
	10 timesRepeat: [ 
		100 milliSeconds wait.
		aProcess isSuspended ifTrue: [ ^ self ] ]
]

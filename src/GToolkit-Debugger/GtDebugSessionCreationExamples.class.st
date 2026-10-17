Class {
	#name : #GtDebugSessionCreationExamples,
	#superclass : #Object,
	#traits : 'TGtScripterDebuggerExamples',
	#classTraits : 'TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'examples - debugSessionOn:' }
GtDebugSessionCreationExamples >> debugSessionOnBlock [
	<gtExample>
	| debugSession |
	debugSession := self debugSessionOn: [ 1 + 2 ].
	self assert: debugSession isNotNil.
	self assert: (debugSession isKindOf: GtDebugSession).
	self assert: debugSession interruptedProcess isNotNil.
	self assert: debugSession interruptedProcess isSuspended.
	self assert: debugSession interruptedContext isNotNil.
	^ debugSession
]

{ #category : #'examples - debugSessionOn:withException:' }
GtDebugSessionCreationExamples >> debugSessionOnException [
	<gtExample>
	| debugSession |
	debugSession := self
		debugSessionOn: [ Halt signal ]
		withException: Halt.
	self assert: debugSession isNotNil.
	self assert: (debugSession isKindOf: GtDebugSession).
	self assert: debugSession interruptedProcess isNotNil.
	self assert: debugSession exception isNotNil.
	^ debugSession
]

{ #category : #'examples - debugSessionOn:withException:' }
GtDebugSessionCreationExamples >> debugSessionOnNoException [
	<gtExample>
	| debugSession |
	debugSession := self
		debugSessionOn: [ 1 + 2 ]
		withException: Halt.
	self assert: debugSession isNil.
	^ debugSession
]

{ #category : #'examples - debugSessionOn:stoppingAt:' }
GtDebugSessionCreationExamples >> debugSessionStoppingAtMethod [
	<gtExample>
	| debugSession |
	debugSession := self
		debugSessionOn: [ self helperReturnValue ]
		stoppingAt: [ :ctx | ctx selector = #helperReturnValue ].
	self assert: debugSession isNotNil.
	self assert: (debugSession isKindOf: GtDebugSession).
	self assert: debugSession interruptedContext isNotNil.
	self assert: debugSession interruptedContext selector equals: #helperReturnValue.
	^ debugSession
]

{ #category : #'examples - forkedDebugSessionOn:withException:' }
GtDebugSessionCreationExamples >> forkedDebugSessionOnException [
	<gtExample>
	| debugSession |
	debugSession := self
		forkedDebugSessionOn: [ Halt signal ]
		withException: Halt.
	self assert: debugSession isNotNil.
	self assert: (debugSession isKindOf: GtDebugSession).
	self assert: debugSession interruptedProcess isNotNil.
	self assert: debugSession interruptedProcess isSuspended.
	self assert: debugSession exception isNotNil.
	^ debugSession
]

{ #category : #'examples - forkedDebugSessionOn:withException:' }
GtDebugSessionCreationExamples >> forkedDebugSessionOnNoException [
	<gtExample>
	| debugSession |
	debugSession := self
		forkedDebugSessionOn: [ 1 + 2 ]
		withException: Halt.
	self assert: debugSession isNil.
	^ debugSession
]

{ #category : #'examples - forkedDebugSessionOn:withException:' }
GtDebugSessionCreationExamples >> forkedDebugSessionTerminate [
	<gtExample>
	| debugSession targetProcess hasError |
	debugSession := self forkedDebugSessionOnException.
	targetProcess := debugSession interruptedProcess.
	self assert: targetProcess isSuspended.
	hasError := false.
	[ debugSession terminate ] on: Error do: [ hasError := true ].
	self assert: hasError not.
	self assert: debugSession interruptedProcess isNil.
	self assert: targetProcess isTerminated.
	^ debugSession
]

{ #category : #helpers }
GtDebugSessionCreationExamples >> helperReturnValue [
	^ 42
]

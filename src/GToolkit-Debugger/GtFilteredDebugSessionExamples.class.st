Class {
	#name : #GtFilteredDebugSessionExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'sample methods' }
GtFilteredDebugSessionExamples >> anotherMethod: oc [
	^ oc sum: [ :each | each * 2 ]
]

{ #category : #private }
GtFilteredDebugSessionExamples >> debugSessionFor: aSymbol [
	| process session |
	process := [ self perform: aSymbol ] newProcess.
	session := GtFilteredDebugSession
			named: 'Debugger on ' , aSymbol
			on: process
			startedAt: process suspendedContext.
	session filters: #().
	[ self stepInto: session.
	session interruptedContext selector = aSymbol ] whileFalse.
	^ session
]

{ #category : #examples }
GtFilteredDebugSessionExamples >> filteredDebugSessionFor: aSymbol [
	| session |
	session := self debugSessionFor: aSymbol.
	session
		filters: {GtSearchMethodsWithClassPatternFilter pattern: self class name}.
	^ session
]

{ #category : #examples }
GtFilteredDebugSessionExamples >> filteredStepFromInitialContext [
	<gtExample>
	<return: #GtFilteredDebugSession>
	| filteredSession initialContext |
	filteredSession := self debugSessionFor: #simpleMethod.
	filteredSession
		filters: {GtSearchMethodsWithClassPatternFilter pattern: 'Collection'}.
	initialContext := filteredSession interruptedContext.
	[ initialContext sender isNil ]
		whileFalse: [ initialContext := initialContext sender ].
	filteredSession stepInto: initialContext.
	self
		assert: filteredSession interruptedContext selector
		equals: #asOrderedCollection.
	^ filteredSession
]

{ #category : #examples }
GtFilteredDebugSessionExamples >> filteredStepping [
	<gtExample>
	<return: #GtFilteredDebugSession>
	| session filteredSession |
	session := self debugSessionFor: #simpleMethod.
	filteredSession := self filteredDebugSessionFor: #simpleMethod.
	self
		assert: filteredSession interruptedContext pc
		equals: session interruptedContext pc.
	self stepInto: session.
	self stepInto: filteredSession.
	self
		assert: filteredSession interruptedContext pc ~= session interruptedContext pc.
	self assert: filteredSession interruptedContext selector equals: #simpleMethod.
	[ filteredSession interruptedContext selector = #simpleMethod ]
		whileTrue: [ self stepInto: filteredSession ].
	self
		assert: filteredSession interruptedContext selector
		equals: #anotherMethod:.
	[ self stepInto: filteredSession.
	filteredSession interruptedContext isBlockContext ] whileFalse.
	self
		assert: filteredSession interruptedContext selector
		equals: #anotherMethod:.
	^ filteredSession
]

{ #category : #'sample methods' }
GtFilteredDebugSessionExamples >> simpleMethod [
	| oc |
	oc := (1 to: 10) asOrderedCollection.
	self anotherMethod: oc
]

{ #category : #private }
GtFilteredDebugSessionExamples >> stepInto: session [
	session stepInto: session interruptedContext
]

Class {
	#name : #GtDebuggerSessionForTestsExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #examples }
GtDebuggerSessionForTestsExamples >> testExplicitSessionTerminationNotNeeded [
	"For testing the debugger we need to create debugging sessions. Currently to create a debugging session we trigger an exception in the process running the example, we freeze the stack and assign it to a new process. If we terminate that session the ensure blocks will be executed for all contexts on the stack. However that can affect the current running process, as the frozen frames where takes from the process."

	<gtExample>
	<return: #GtDebuggerSessionForTestsExamples>
	| fileReference resultsStream debugSession contextWeakReferences processWeakReferences wasClosedArray |
	wasClosedArray := OrderedCollection new.
	fileReference := FileSystem memory / 'data-test.txt'.
	resultsStream := ZnCharacterWriteStream
			on: (fileReference writeStream
					setToEnd;
					yourself)
			encoding: 'utf8'.

	[ resultsStream
		nextPutAll: 'Line before';
		cr.

	[ 1 / 0 ]
		on: ZeroDivide
		do: [ :anException | debugSession := DebugSession forExceptionFromExampleFor: anException ].

	processWeakReferences := debugSession interruptedProcess asWeakReference.
	contextWeakReferences := debugSession interruptedContext asWeakReference.

	resultsStream
		nextPutAll: 'Line after';
		cr ]
		ensure: [ resultsStream close.
			wasClosedArray add: true ].

	debugSession := nil.

	Smalltalk garbageCollect.
	Smalltalk garbageCollect.

	self assert: (processWeakReferences at: 1) isNil.
	self assert: (contextWeakReferences at: 1) isNil.
	self assert: wasClosedArray asArray equals: #(true).
	self
		assert: fileReference contents trimBoth lines
		equals: #('Line before' 'Line after')
]

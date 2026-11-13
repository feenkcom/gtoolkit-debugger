"
I am a fixture for {{gtClass:GtDebuggerStepOverSignalExamples}}.
My only method fails an assertion. I have no test selectors, so test runners do not run me.
"
Class {
	#name : #GtDebuggerSteppingFailingTestCase,
	#superclass : #TestCase,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #fixtures }
GtDebuggerSteppingFailingTestCase >> failingEqualityAssertion [
	self assert: 1 = 2
]

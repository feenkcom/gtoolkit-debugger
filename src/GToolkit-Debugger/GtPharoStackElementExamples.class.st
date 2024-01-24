Class {
	#name : #GtPharoStackElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtPharoStackElementExamples >> createPharoStackElementScripter [
	<gtExample>
	| context debuggingSession process stackElement |
	context := [ self testMethod1 ] asContext.
	process := Process
			forContext: context
			priority: Processor userInterruptPriority.
	debuggingSession := DebugSession
			named: 'Debug'
			on: process
			startedAt: process suspendedContext.
	4 timesRepeat: [ debuggingSession stepInto ].
	
	stackElement := GtPharoStackElement new
		updateForSession: debuggingSession;
		beDetailedLevel.
	
	^ BlScripter new element: stackElement
]

{ #category : #accessing }
GtPharoStackElementExamples >> testMethod1 [
	self testMethod2
]

{ #category : #accessing }
GtPharoStackElementExamples >> testMethod2 [
	self testMethod3
]

{ #category : #accessing }
GtPharoStackElementExamples >> testMethod3 [
	^42
]

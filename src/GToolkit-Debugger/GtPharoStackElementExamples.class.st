Class {
	#name : #GtPharoStackElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtPharoStackElementExamples >> createPharoStackElement [
	| context debuggingSession process stackElement |
	context := [ self testMethod1 ] asContext.
	process := Process
			forContext: context
			priority: Processor userInterruptPriority.
	debuggingSession := GtDebugSession
			named: 'Debug'
			on: process
			startedAt: process suspendedContext.
	4 timesRepeat: [ debuggingSession stepInto ].
	
	stackElement := GtPharoStackElement new
		updateForSession: debuggingSession;
		beDetailedLevel.
	
	^ stackElement
]

{ #category : #accessing }
GtPharoStackElementExamples >> createPharoStackElementScripter [
	<gtExample>
	<return: #BlScripter>
	^ BlScripter new element: self createPharoStackElement
]

{ #category : #examples }
GtPharoStackElementExamples >> jumpToStackBottomButton [
	<gtExample>
	<return: #BrButton>
	| stackElement button |
	stackElement := GtPharoStackElement new.
	button := stackElement newJumpToStackBottomButton.
	self assert: button id asSymbol equals: #jumpToStackBottomButton.
	self assert: button label asString equals: 'Jump to the bottom of the stack'.
	^ button
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

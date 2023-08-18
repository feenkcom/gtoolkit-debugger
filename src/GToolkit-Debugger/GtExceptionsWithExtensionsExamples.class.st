Class {
	#name : #GtExceptionsWithExtensionsExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> createDebuggingSessionForException: anException [ 
	| exception context process session |
	exception := anException.
	exception freezeUpTo: nil.
	context := exception signalerContext.
	process := Process
		forContext: context
		priority: Processor userInterruptPriority.
	session := DebugSession
		named: exception description
		on: process
		startedAt: context.
	session exception: exception.
	
	^ session
]

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> debuggerExtensionOn_exampleExceptionWithDebuggingView [
	<gtExample>
	| session debugger |
	
	session := self debugingSession_exampleExceptionWithDebuggingView.
	debugger := GtExceptionDebuggingElement on: session.
	
	^ debugger
]

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> debugingSession_exampleComparisonExceptionWithDebuggingViews [
	<gtExample>
	
	[ self exampleComparisonExceptionWithDebuggingViews signal ] 
		on: GtExampleComparisonExceptionWithDebuggingViews
		do: [ :anException | 
			^ self createDebuggingSessionForException: anException ].
	  
	^ nil
]

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> debugingSession_exampleExceptionWithDebuggingView [
	<gtExample>
	
	[ self exampleExceptionWithDebuggingView signal ] 
		on: GtExampleExceptionWithDebuggingView
		do: [ :anException | 
			^ self createDebuggingSessionForException: anException ].
	  
	^ nil
]

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> exampleComparisonExceptionWithDebuggingViews [
	<gtExample>
	
	^ GtExampleComparisonExceptionWithDebuggingViews new
		expectedString: GtExampleComparisonExceptionWithDebuggingViews new
			expectedStringForTest;
		actualString: GtExampleComparisonExceptionWithDebuggingViews new
			computedStringForTest;
		targetClass: GtExampleComparisonExceptionWithDebuggingViews; 
		targetSelector: #expectedStringForTest.
]

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> exampleExceptionWithDebuggingView [
	<gtExample>
	
	^ GtExampleExceptionWithDebuggingView new
		expectedString: GtExampleComparisonExceptionWithDebuggingViews new
			expectedShortStringForTest;
		actualString: GtExampleComparisonExceptionWithDebuggingViews new
			computedShortStringForTest
]

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> exampleExceptionWithForwardedDebuggingViews [
	<gtExample>
	
	^ GtExampleExceptionWithForwardedDebuggingView new
		initializeWithDomainData
]

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> fullDebuggerOn_exampleComparisonExceptionWithDebuggingViews [
	<gtExample>
	| session debugger |
	
	session := self debugingSession_exampleComparisonExceptionWithDebuggingViews.
	debugger := GtMoldableDebugger on: session.
	
	^ debugger
]

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> fullDebuggerOn_exampleExceptionWithDebuggingView [
	<gtExample>
	| session debugger |
	
	session := self debugingSession_exampleExceptionWithDebuggingView.
	debugger := GtMoldableDebugger on: session.
	
	^ debugger
]

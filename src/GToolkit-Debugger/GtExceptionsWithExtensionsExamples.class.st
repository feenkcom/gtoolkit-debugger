Class {
	#name : #GtExceptionsWithExtensionsExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #asserting }
GtExceptionsWithExtensionsExamples >> assertDebuggingConfigurationEnabledFor: anException [ 
	| extensionConfiguration |
	extensionConfiguration := anException gtExceptionDebuggerSpecification.
	
	self assert: extensionConfiguration notNil.
	self assert: extensionConfiguration canEnableDebugger value.
]

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> createDebuggingSessionForException: anException [ 
	^ DebugSession forExceptionFromExampleFor: anException
]

{ #category : #'examples - debuggers' }
GtExceptionsWithExtensionsExamples >> debuggerExtensionOn_exampleExceptionWithDebuggingView [
	<gtExample>
	<return: #GtMoldableExceptionDebuggingElement>
	| session debugger |
	session := self debugingSession_exampleExceptionWithDebuggingView.
	debugger := GtMoldableExceptionDebuggingElement on: session.

	^ debugger
]

{ #category : #'examples - debug session' }
GtExceptionsWithExtensionsExamples >> debugingSession_exampleComparisonExceptionWithDebuggingViews [
	<gtExample>
	<return: #DebugSession>
	[ self exampleComparisonExceptionWithDebuggingViews signal ]
		on: GtExampleComparisonExceptionWithDebuggingViews
		do: [ :anException | ^ self createDebuggingSessionForException: anException ].

	^ nil
]

{ #category : #'examples - debug session' }
GtExceptionsWithExtensionsExamples >> debugingSession_exampleExceptionWithDebuggingView [
	<gtExample>
	<return: #DebugSession>
	[ self exampleExceptionWithDebuggingView signal ]
		on: GtExampleExceptionWithDebuggingView
		do: [ :anException | ^ self createDebuggingSessionForException: anException ].

	^ nil
]

{ #category : #'examples - exceptions' }
GtExceptionsWithExtensionsExamples >> exampleComparisonExceptionWithDebuggingViews [
	<gtExample>
	<return: #GtExampleComparisonExceptionWithDebuggingViews>
	| exception |
	exception := GtExampleComparisonExceptionWithDebuggingViews new
			expectedString: GtExampleComparisonExceptionWithDebuggingViews new expectedStringForTest;
			actualString: GtExampleComparisonExceptionWithDebuggingViews new computedStringForTest;
			targetClass: GtExampleComparisonExceptionWithDebuggingViews;
			targetSelector: #expectedStringForTest.

	self assertDebuggingConfigurationEnabledFor: exception.

	^ exception
]

{ #category : #'examples - exceptions' }
GtExceptionsWithExtensionsExamples >> exampleExceptionWithDebuggingView [
	<gtExample>
	<return: #GtExampleExceptionWithDebuggingView>
	| exception |
	exception := GtExampleExceptionWithDebuggingView new
			expectedString: GtExampleComparisonExceptionWithDebuggingViews new expectedShortStringForTest;
			actualString: GtExampleComparisonExceptionWithDebuggingViews new computedShortStringForTest.

	self assertDebuggingConfigurationEnabledFor: exception.

	^ exception
]

{ #category : #'examples - exceptions' }
GtExceptionsWithExtensionsExamples >> exampleExceptionWithForwardedDebuggingViews [
	<gtExample>
	<return: #GtExampleExceptionWithForwardedDebuggingView>
	| exception |
	exception := GtExampleExceptionWithForwardedDebuggingView new
			initializeWithDomainData.

	self assertDebuggingConfigurationEnabledFor: exception.

	^ exception
]

{ #category : #'examples - debuggers' }
GtExceptionsWithExtensionsExamples >> fullDebuggerOn_exampleComparisonExceptionWithDebuggingViews [
	<gtExample>
	<return: #GtMoldableDebugger>
	| session debugger |
	session := self debugingSession_exampleComparisonExceptionWithDebuggingViews.
	debugger := GtMoldableDebugger on: session.

	^ debugger
]

{ #category : #'examples - debuggers' }
GtExceptionsWithExtensionsExamples >> fullDebuggerOn_exampleExceptionWithDebuggingView [
	<gtExample>
	<return: #GtMoldableDebugger>
	| session debugger |
	session := self debugingSession_exampleExceptionWithDebuggingView.
	debugger := GtMoldableDebugger on: session.

	^ debugger
]

{ #category : #'examples - debuggers' }
GtExceptionsWithExtensionsExamples >> fullDebuggerOn_exampleExceptionWithDebuggingView_scripterRendering [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := BlScripter new.
	scripter element: self fullDebuggerOn_exampleExceptionWithDebuggingView.

	scripter debugger
		assertIsMainDebuggerElement;
		assertDebuggerSwitchButtonsWithLabels: {GtMoldableExceptionDebuggingElement defaultTitle.
				GtPharoDebuggerElement defaultTitle};
		assertSelectedDebuggerOfType: GtMoldableExceptionDebuggingElement;
		switchToDebuggerOfType: GtPharoDebuggerElement;
		assertDebuggerSwitchButtonsWithLabels: {GtMoldableExceptionDebuggingElement defaultTitle.
				GtPharoDebuggerElement defaultTitle};
		switchToDebuggerOfType: GtMoldableExceptionDebuggingElement.

	^ scripter
]

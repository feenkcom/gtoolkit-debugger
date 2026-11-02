Class {
	#name : #GtExceptionsWithExtensionsExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'examples - exceptions' }
GtExceptionsWithExtensionsExamples >> acceptingObtainedValueCanBeUndone [
	"Accepting the obtained value of a failed comparison compiles it as the expected value through
	a recorded change: one undo restores the previous expected value and keeps the changes recorded before it"

	<gtExample>
	<return: #GtExampleComparisonExceptionWithDebuggingViews>
	^ GtRefactoryChangeManager
		isolatedInstanceDuring: [ :aChangeManager |
			| environment realClass exception |
			environment := GtPharoDummiesGenerator withPackages: 1 classes: 1.
			[ realClass := environment anyDummyClass realClass.
			(RBAddMethodChange
				compile: 'expectedValue
	^ ''old'''
				in: realClass
				classified: 'data') gtExecuteWithUndo.
			exception := GtExampleComparisonExceptionWithDebuggingViews new
					expectedString: 'old';
					actualString: 'new';
					targetClass: realClass;
					targetSelector: #expectedValue.

			exception compileObtainedAsExpected.
			self assert: realClass new expectedValue equals: 'new'.

			aChangeManager undoChange.
			self assert: realClass new expectedValue equals: 'old'.
			self assert: aChangeManager hasUndoableOperations.
			exception ] ensure: [ environment removeFromSystem ] ]
]

{ #category : #asserting }
GtExceptionsWithExtensionsExamples >> assertDebuggingConfigurationEnabledFor: anException [ 
	| extensionConfiguration |
	extensionConfiguration := anException gtExceptionDebuggerSpecification.
	
	self assert: extensionConfiguration notNil.
	self assert: extensionConfiguration canEnableDebugger value.
]

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> createDebuggingSessionForException: anException [ 
	^ GtDebugSession forExceptionFromExampleFor: anException
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
	<return: #GtDebugSession>
	[ self exampleComparisonExceptionWithDebuggingViews signal ]
		on: GtExampleComparisonExceptionWithDebuggingViews
		do: [ :anException | ^ self createDebuggingSessionForException: anException ].

	^ nil
]

{ #category : #'examples - debug session' }
GtExceptionsWithExtensionsExamples >> debugingSession_exampleExceptionWithDebuggingView [
	<gtExample>
	<return: #GtDebugSession>
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
	scripter space root 
		padding: (BlInsets top: 15); 
		layout: BlFrameLayout new.
	scripter element: self fullDebuggerOn_exampleExceptionWithDebuggingView.

	scripter debugger
		assertIsMainDebuggerElement;
		assertDebuggerSwitchButtonsWithLabels: {GtMoldableExceptionDebuggingElement defaultTitle.
				GtPharoDebuggerElement defaultTitle};
		assertSelectedDebuggerOfType: GtMoldableExceptionDebuggingElement;
		switchToDebuggerOfType: GtPharoDebuggerElement;
		assertDebuggerSwitchButtonsWithLabels: {GtMoldableExceptionDebuggingElement defaultTitle.
				GtPharoDebuggerElement defaultTitle};
		switchToDebuggerOfType: GtMoldableExceptionDebuggingElement;
		play.

	^ scripter
]

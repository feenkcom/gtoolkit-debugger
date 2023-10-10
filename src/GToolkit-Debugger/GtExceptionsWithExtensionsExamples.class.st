Class {
	#name : #GtExceptionsWithExtensionsExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #asserting }
GtExceptionsWithExtensionsExamples >> assertDebuggingConfigurationEnabledFor: anException [ 
	| extensionConfiguration |
	extensionConfiguration := anException gtDebuggingExtensionConfiguration.
	
	self assert: extensionConfiguration notNil.
	self assert: extensionConfiguration enableDebuggingViewExtension value.
]

{ #category : #'examples - debuggers' }
GtExceptionsWithExtensionsExamples >> assertIsMainDebuggerElementFor: aScripter [ 
	self 
		assert: aScripter element id
		equals: GtMoldableDebuggerMainElementId new.
]

{ #category : #asserting }
GtExceptionsWithExtensionsExamples >> assertOneDebuggerSwitchButtonLabeled: aDebuggerLabel for: aScripter [
	<gtExample>
	| buttonsContainer |
	
	buttonsContainer := aScripter element query // GtMoldableDebuggerSwitchButtonsContainerElementId.
	
	self
		assert: buttonsContainer all size
		equals: 1.
		
	self
		assert: buttonsContainer anyOne children first label asString
		equals: aDebuggerLabel.
]

{ #category : #asserting }
GtExceptionsWithExtensionsExamples >> assertSwitchToDebuggerLabeled: aDebuggerLabel ofType: aDebuggerType for: aScripter [
	<gtExample>
	self assertOneDebuggerSwitchButtonLabeled: aDebuggerLabel for: aScripter.

	aScripter
		clickStep: [ :s | 
			s
				// GtMoldableDebuggerSwitchButtonsContainerElementId;
				// BrButton ].

	self assert: (aScripter element query // aDebuggerType) all size equals: 1
]

{ #category : #accessing }
GtExceptionsWithExtensionsExamples >> createDebuggingSessionForException: anException [ 
	^ DebugSession forExceptionFromExampleFor: anException
]

{ #category : #'examples - debuggers' }
GtExceptionsWithExtensionsExamples >> debuggerExtensionOn_exampleExceptionWithDebuggingView [
	<gtExample>
	| session debugger |
	
	session := self debugingSession_exampleExceptionWithDebuggingView.
	debugger := GtMoldableExceptionDebuggingElement on: session.
	
	^ debugger
]

{ #category : #'examples - debug session' }
GtExceptionsWithExtensionsExamples >> debugingSession_exampleComparisonExceptionWithDebuggingViews [
	<gtExample>
	
	[ self exampleComparisonExceptionWithDebuggingViews signal ] 
		on: GtExampleComparisonExceptionWithDebuggingViews
		do: [ :anException | 
			^ self createDebuggingSessionForException: anException ].
	  
	^ nil
]

{ #category : #'examples - debug session' }
GtExceptionsWithExtensionsExamples >> debugingSession_exampleExceptionWithDebuggingView [
	<gtExample>
	
	[ self exampleExceptionWithDebuggingView signal ] 
		on: GtExampleExceptionWithDebuggingView
		do: [ :anException | 
			^ self createDebuggingSessionForException: anException ].
	  
	^ nil
]

{ #category : #'examples - exceptions' }
GtExceptionsWithExtensionsExamples >> exampleComparisonExceptionWithDebuggingViews [
	<gtExample>
	| exception |
	
	exception:= GtExampleComparisonExceptionWithDebuggingViews new
		expectedString: GtExampleComparisonExceptionWithDebuggingViews new
			expectedStringForTest;
		actualString: GtExampleComparisonExceptionWithDebuggingViews new
			computedStringForTest;
		targetClass: GtExampleComparisonExceptionWithDebuggingViews; 
		targetSelector: #expectedStringForTest.
	
	self assertDebuggingConfigurationEnabledFor: exception.
	
	^ exception
]

{ #category : #'examples - exceptions' }
GtExceptionsWithExtensionsExamples >> exampleExceptionWithDebuggingView [
	<gtExample>
	| exception |
	
	exception := GtExampleExceptionWithDebuggingView new
		expectedString: GtExampleComparisonExceptionWithDebuggingViews new
			expectedShortStringForTest;
		actualString: GtExampleComparisonExceptionWithDebuggingViews new
			computedShortStringForTest.

	self assertDebuggingConfigurationEnabledFor: exception.
			
	^ exception
]

{ #category : #'examples - exceptions' }
GtExceptionsWithExtensionsExamples >> exampleExceptionWithForwardedDebuggingViews [
	<gtExample>
	|exception|
	
	exception := GtExampleExceptionWithForwardedDebuggingView new
		initializeWithDomainData.
		
	self assertDebuggingConfigurationEnabledFor: exception.
	
	^ exception
]

{ #category : #'examples - debuggers' }
GtExceptionsWithExtensionsExamples >> fullDebuggerOn_exampleComparisonExceptionWithDebuggingViews [
	<gtExample>
	| session debugger |
	
	session := self debugingSession_exampleComparisonExceptionWithDebuggingViews.
	debugger := GtMoldableDebugger on: session.
	
	^ debugger
]

{ #category : #'examples - debuggers' }
GtExceptionsWithExtensionsExamples >> fullDebuggerOn_exampleExceptionWithDebuggingView [
	<gtExample>
	| session debugger |
	
	session := self debugingSession_exampleExceptionWithDebuggingView.
	debugger := GtMoldableDebugger on: session.
	 
	^ debugger
]

{ #category : #'examples - debuggers' }
GtExceptionsWithExtensionsExamples >> fullDebuggerOn_exampleExceptionWithDebuggingView_scripterRendering [
	"<gtExample>"
	| scripter |
	
	scripter := BlScripter new.
	scripter element: self fullDebuggerOn_exampleExceptionWithDebuggingView.
	
	self assertIsMainDebuggerElementFor: scripter.
	
	self 
		assertOneDebuggerSwitchButtonLabeled: GtPharoDebuggerElement defaultTitle 
		for: scripter.
	self 
		assertSwitchToDebuggerLabeled: GtPharoDebuggerElement defaultTitle 
		ofType: GtPharoDebuggerElement 
		for: scripter.
		
	self 
		assertOneDebuggerSwitchButtonLabeled: GtMoldableExceptionDebuggingElement defaultTitle 
		for: scripter.
	self 
		assertSwitchToDebuggerLabeled: GtMoldableExceptionDebuggingElement defaultTitle 
		ofType: GtMoldableExceptionDebuggingElement 
		for: scripter.

	^ scripter
]

{ #category : #'examples - debuggers' }
GtExceptionsWithExtensionsExamples >> fullDebuggerOn_exampleExceptionWithDebuggingView_scripterRendering2 [
	"<gtExample>"
	| scripter |
	
	scripter := BlScripter new.
	scripter element: self fullDebuggerOn_exampleExceptionWithDebuggingView.
	
	scripter debugger
		assertIsMainDebuggerElement;
		assertOneDebuggerSwitchButtonLabeled: GtPharoDebuggerElement defaultTitle;
		assertSwitchToDebuggerLabeled: GtPharoDebuggerElement defaultTitle 
			ofType: GtPharoDebuggerElement;
		assertOneDebuggerSwitchButtonLabeled: GtMoldableExceptionDebuggingElement defaultTitle;
		assertSwitchToDebuggerLabeled: GtMoldableExceptionDebuggingElement defaultTitle 
			ofType: GtMoldableExceptionDebuggingElement.

	^ scripter
]

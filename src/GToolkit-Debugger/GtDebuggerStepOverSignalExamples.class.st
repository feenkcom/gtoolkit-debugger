"
I show that stepping over a send that signals an exception captured while stepping (a test failure, or a notification that opens a debugger when unhandled) stops the debugger at the signal, and that stepping over a resumable notification simply continues.
Each example first opens a debug session on the unhandled exception in a forked process, as the debugger does, then restarts the method and steps over the signalling send again.
"
Class {
	#name : #GtDebuggerStepOverSignalExamples,
	#superclass : #Object,
	#traits : 'TGtScripterDebuggerExamples',
	#classTraits : 'TGtScripterDebuggerExamples classTrait',
	#instVars : [
		'debugSessions'
	],
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'private - scripter' }
GtDebuggerStepOverSignalExamples >> assertStackOf: aScripter includes: aMethod [
	self assert: (aScripter element debugSession interruptedContext stack
				anySatisfy: [:each | each method == aMethod])
]

{ #category : #accessing }
GtDebuggerStepOverSignalExamples >> capturedNotificationMethod [
	^self class >> #targetMethod_signalSteppingCapturedNotification
]

{ #category : #'private - debug sessions' }
GtDebuggerStepOverSignalExamples >> contextOf: aMethod in: aDebugSession [
	^aDebugSession interruptedContext
		findContextSuchThat: [:each | each method == aMethod]
]

{ #category : #'examples - notification' }
GtDebuggerStepOverSignalExamples >> debugSessionOnSteppingCapturedNotification [
	<gtExample>
	<after: #terminateDebugSessions>
	<return: #GtDebugSession>
	| debugSession |
	debugSession := self forkedDebugSessionOnUnhandledExceptionIn: 
					[self targetMethod_signalSteppingCapturedNotification].
	self assert: (debugSession exception
				isKindOf: GtDebuggerSteppingCapturedNotification).
	self assert: debugSession interruptedProcess isSuspended.
	self assert: debugSession interruptedContext method
		equals: self capturedNotificationMethod.
	^debugSession
]

{ #category : #'examples - test case' }
GtDebuggerStepOverSignalExamples >> debugSessionOnTestCaseFailure [
	<gtExample>
	<after: #terminateDebugSessions>
	<return: #GtDebugSession>
	| debugSession |
	debugSession := self forkedDebugSessionOnUnhandledExceptionIn: 
					[(GtDebuggerSteppingFailingTestCase selector: #failingEqualityAssertion)
						debug].
	self assert: (debugSession exception isKindOf: TestFailure).
	self assert: debugSession interruptedProcess isSuspended.
	self assert: (self contextOf: self failingTestCaseMethod in: debugSession)
				notNil.
	^debugSession
]

{ #category : #accessing }
GtDebuggerStepOverSignalExamples >> failingTestCaseMethod [
	^GtDebuggerSteppingFailingTestCase >> #failingEqualityAssertion
]

{ #category : #'private - debug sessions' }
GtDebuggerStepOverSignalExamples >> forkedDebugSessionOnUnhandledExceptionIn: aBlock [
	"Run aBlock in a forked process and suspend that process when an exception reaches its default action without a handler, where the debugger would open.
	The session starts at the signaler context of that exception, like the session of a real debugger.
	Only the first unhandled exception suspends the process; later ones, for example raised while the session is terminated, are passed on."
	<return: #GtDebugSession>
	| exception semaphore process debugSession |
	semaphore := Semaphore new.
	process := 
			[DefaultExecutionEnvironment beActiveDuring: 
					[aBlock on: UnhandledError
						do: 
							[:anUnhandledError |
							exception ifNotNil: [anUnhandledError pass].
							exception := anUnhandledError exception.
							semaphore signal.
							Processor activeProcess suspend]].
			semaphore signal]
					forkAt: Processor activePriority + 1.
	semaphore wait.
	self assert: exception notNil
		description: 'The block should signal an unhandled exception'.
	debugSession := process newDebugSessionNamed: exception description
				startedAt: exception signalerContext.
	debugSession exception: exception.
	^self registeredDebugSession: debugSession
]

{ #category : #initialization }
GtDebuggerStepOverSignalExamples >> initialize [
	super initialize.
	debugSessions := OrderedCollection new
]

{ #category : #'private - scripter' }
GtDebuggerStepOverSignalExamples >> isCoderWithId: aCoderId expandedIn: aScripter [
	^aScripter element
		allChildrenBreadthFirstDetect: [:each | each id = aCoderId]
		ifFound: [:each | each isExpanded]
		ifNone: [false]
]

{ #category : #'private - debug sessions' }
GtDebuggerStepOverSignalExamples >> nextSendSelectorIn: aContext [
	| stream |
	stream := InstructionStream on: aContext method pc: aContext pc.
	^stream willSend ifTrue: [
		| nextSelector|
		((nextSelector := stream selectorToSendOrSelf) == stream)
			ifTrue: [nil] ifFalse: [nextSelector]] ifFalse: [nil]
]

{ #category : #'private - debug sessions' }
GtDebuggerStepOverSignalExamples >> registeredDebugSession: aDebugSession [
	debugSessions add: aDebugSession.
	^aDebugSession
]

{ #category : #'private - scripter' }
GtDebuggerStepOverSignalExamples >> restartAndStepOverInScripter: aScripter method: aMethod sends: aCollectionOfSelectors capturing: anExceptionClass [
	self selectContextOf: aMethod in: aScripter.
	(aScripter debugger)
		label: 'Restart the method';
		clickOnRestartButton;
		assertInSessionNoException;
		assertInCodersContextMethod: aMethod atTopIndex: 1;
		assertNextInstructionMessageSendSelector: aCollectionOfSelectors first;
		play.
	aCollectionOfSelectors allButFirst do: 
			[:eachSelector |
			(aScripter debugger)
				label: 'Step over until the send of ' , eachSelector;
				clickOnStepOverButton;
				assertInCodersContextMethod: aMethod atTopIndex: 1;
				assertNextInstructionMessageSendSelector: eachSelector;
				play].
	(aScripter debugger)
		label: 'Step over the signalling send';
		clickOnStepOverButton;
		assertInSessionExceptionOfType: anExceptionClass;
		assertInSessionContextMethod: Exception >> #signal atTopIndex: 1;
		play.
	self assertStackOf: aScripter includes: aMethod
]

{ #category : #'private - debug sessions' }
GtDebuggerStepOverSignalExamples >> restartAndStepOverInSession: aDebugSession method: aMethod sends: aCollectionOfSelectors capturing: anExceptionClass [
	| methodContext |
	methodContext := self contextOf: aMethod in: aDebugSession.
	aDebugSession restart: methodContext.
	self assert: aDebugSession exception isNil.
	self assert: aDebugSession interruptedContext == methodContext.
	self assert: (self nextSendSelectorIn: methodContext)
		equals: aCollectionOfSelectors first.
	aCollectionOfSelectors allButFirst do: 
			[:eachSelector |
			aDebugSession stepOver: methodContext.
			self assert: (self nextSendSelectorIn: methodContext) equals: eachSelector].
	aDebugSession stepOver: methodContext.
	self assert: (aDebugSession exception isKindOf: anExceptionClass).
	self assert: aDebugSession interruptedContext method
		equals: Exception >> #signal.
	self assert: aDebugSession interruptedProcess isSuspended.
	self
		assert: (aDebugSession interruptedContext stack includes: methodContext)
]

{ #category : #'examples - notification' }
GtDebuggerStepOverSignalExamples >> restartAndStepOverSteppingCapturedNotification [
	<gtExample>
	<after: #terminateDebugSessions>
	<return: #GtDebugSession>
	| debugSession |
	debugSession := self debugSessionOnSteppingCapturedNotification.
	self
		restartAndStepOverInSession: debugSession
		method: self capturedNotificationMethod
		sends: #(#signal)
		capturing: GtDebuggerSteppingCapturedNotification.
	^debugSession
]

{ #category : #'examples - test case' }
GtDebuggerStepOverSignalExamples >> restartAndStepOverTestCaseFailure [
	<gtExample>
	<after: #terminateDebugSessions>
	<return: #GtDebugSession>
	| debugSession |
	
	debugSession := self debugSessionOnTestCaseFailure.
	self
		restartAndStepOverInSession: debugSession
		method: self failingTestCaseMethod
		sends: #(#= #assert:)
		capturing: TestFailure.
		
	^debugSession
]

{ #category : #accessing }
GtDebuggerStepOverSignalExamples >> resumableNotificationMethod [
	^self class >> #targetMethod_signalResumableNotification
]

{ #category : #'private - scripter' }
GtDebuggerStepOverSignalExamples >> scripterOnDebugSession: aDebugSession [
	<return: #BlScripter>
	| scripter |
	scripter := BlScripter new.
	scripter element: (GtMoldableDebugger on: aDebugSession) beDetailedLevel.
	scripter model: aDebugSession.
	^scripter
]

{ #category : #'examples - notification' }
GtDebuggerStepOverSignalExamples >> scripterRestartAndStepOverSteppingCapturedNotification [
	<gtExample>
	<after: #terminateDebugSessions>
	<return: #BlScripter>
	| scripter |
	scripter := self
				scripterOnDebugSession: self debugSessionOnSteppingCapturedNotification.
	(scripter debugger)
		label: 'Assert the debugger on the unhandled notification';
		assertIsMainDebuggerElement;
		assertInSessionExceptionOfType: GtDebuggerSteppingCapturedNotification;
		play.
	self
		restartAndStepOverInScripter: scripter
		method: self capturedNotificationMethod
		sends: #(#signal)
		capturing: GtDebuggerSteppingCapturedNotification.
	^scripter
]

{ #category : #'examples - test case' }
GtDebuggerStepOverSignalExamples >> scripterRestartAndStepOverTestCaseFailure [
	<gtExample>
	<after: #terminateDebugSessions>
	<return: #BlScripter>
	| scripter |
	scripter := self
				scripterOnDebugSession: self debugSessionOnTestCaseFailure.
	(scripter debugger)
		label: 'Assert the debugger on the test failure';
		assertIsMainDebuggerElement;
		assertInSessionExceptionOfType: TestFailure;
		play.
	self
		restartAndStepOverInScripter: scripter
		method: self failingTestCaseMethod
		sends: #(#= #assert:)
		capturing: TestFailure.
	^scripter
]

{ #category : #'private - scripter' }
GtDebuggerStepOverSignalExamples >> selectContextOf: aMethod in: aScripter [
	"The debugger expands only the coder of the first visible context, so the coder of a deeper context is expanded first"
	| coderId |
	coderId := GtExpandableContextMethodCoderId
				indexed: ((aScripter element debugSession interruptedContext stack
						collect: [:each | each method]) indexOf: aMethod).
	(self isCoderWithId: coderId expandedIn: aScripter)
		ifFalse: 
			[(aScripter click)
				label: 'Expand the coder of ' , aMethod printString;
				// coderId;
				// GtSourceCoderExpanderToggleId;
				play].
	(aScripter click)
		label: 'Select the context of ' , aMethod printString;
		// coderId;
		// GtSourceCoderEditorId;
		// GtSourceCoderEditorInnerId;
		play
]

{ #category : #'examples - notification' }
GtDebuggerStepOverSignalExamples >> stepOverResumableNotification [
	<gtExample>
	<after: #terminateDebugSessions>
	<return: #GtDebugSession>
	| debugSession methodContext |
	debugSession := self registeredDebugSession: (self
						debugSessionOn: [self targetMethod_signalResumableNotification]
						stoppingAt: [:aContext | aContext method == self resumableNotificationMethod]).
	methodContext := debugSession interruptedContext.
	self assert: (self nextSendSelectorIn: methodContext) equals: #signal.
	debugSession stepOver: methodContext.
	self assert: debugSession exception isNil.
	self assert: debugSession interruptedContext == methodContext.
	self assert: (self nextSendSelectorIn: methodContext)
		equals: #targetMethod_afterResumableNotification.
	^debugSession
]

{ #category : #'private - target methods' }
GtDebuggerStepOverSignalExamples >> targetMethod_afterResumableNotification [
	^42
]

{ #category : #'private - target methods' }
GtDebuggerStepOverSignalExamples >> targetMethod_signalResumableNotification [
	Notification signal.
	^self targetMethod_afterResumableNotification
]

{ #category : #'private - target methods' }
GtDebuggerStepOverSignalExamples >> targetMethod_signalSteppingCapturedNotification [
	^GtDebuggerSteppingCapturedNotification signal
]

{ #category : #cleanup }
GtDebuggerStepOverSignalExamples >> terminateDebugSessions [
	debugSessions do: [:each | each terminate].
	debugSessions removeAll
]

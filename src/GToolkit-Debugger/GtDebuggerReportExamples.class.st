"
I exemplify debugger reports ({{gtClass:GtDebuggerReport}}): a stack report created from a debug session, and a debug log report with a screenshot created from a debugger.

Reports are stored in an in-memory store. The GemStone debugger report is exemplified in {{gtClass:name=GtRemoteGemStoneDebuggerReportExamples}}.
"
Class {
	#name : #GtDebuggerReportExamples,
	#superclass : #Object,
	#traits : 'TGtScripterDebuggerExamples',
	#classTraits : 'TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'examples - debug log report' }
GtDebuggerReportExamples >> debugLogReportOfMoldableExceptionDebugger [
	<gtExample>
	<return: #GtDebuggerReport>
	| scripter debuggerElement report |
	scripter := self
			scripterInPagerWithDebuggerOn: GtExceptionsWithExtensionsExamples new
					debugingSession_exampleExceptionWithDebuggingView.
	debuggerElement := scripter element query
			// GtMoldableExceptionDebuggingElement;
			anyOne.
	report := GtDebuggerReport debugLogReportForDebugger: debuggerElement.

	self assert: report title equals: debuggerElement debugSession name.
	self
		assert: report exceptionClassName
		equals: 'GtExampleExceptionWithDebuggingView'.
	self
		assert: report exceptionDescription
		equals: debuggerElement debugSession exception description.
	self assert: report hasDebugLog.
	self assert: report debugLog lines first equals: report exceptionDescription.
	self assert: (report stacks collect: [ :each | each name ]) equals: #('stack').
	self assert: report hasScreenshot.
	self
		assert: report screenshotForm extent
		equals: debuggerElement extent ceiling.

	^ report
]

{ #category : #'examples - debug log report' }
GtDebuggerReportExamples >> debugLogReportOfPharoDebugger [
	"A debug log report contains the debug log and the stacks, as given by the debug session, and a screenshot of the debugger"

	<gtExample>
	<return: #GtDebuggerReport>
	| debuggerElement report |
	debuggerElement := self scripterOnPharoDebugger element query
			// GtPharoDebuggerElement;
			anyOne.
	report := GtDebuggerReport debugLogReportForDebugger: debuggerElement.

	self assert: report title equals: 'Error: An exception happened'.
	self assert: report exceptionClassName equals: 'Error'.
	self assert: report exceptionDescription equals: 'Error: An exception happened'.
	self assert: report hasDebugLog.
	self assert: report debugLog lines first equals: report exceptionDescription.
	self assert: (report debugLog includesSubstring: '--- The full stack ---').
	self
		assert: (report debugLog
				includesSubstring: 'GtDebuggerReportExamples>>targetMethod_signalError').
	self assert: (report stacks collect: [ :each | each name ]) equals: #('stack').
	self
		assert: (report stackNamed: 'stack') text
		equals: debuggerElement debugSession stackMethodsString.
	self assert: report hasScreenshot.
	self
		assert: report screenshotForm extent
		equals: debuggerElement extent ceiling.

	^ report
]

{ #category : #'examples - debug log report' }
GtDebuggerReportExamples >> debugLogReportReadFromStore [
	<gtExample>
	<return: #GtDebuggerReport>
	| report entry readReport |
	report := self debugLogReportOfPharoDebugger.
	entry := report storeIn: self memoryStore.
	readReport := (GtStoredReportFiles folder: entry folder) report.

	self assert: readReport reportUid equals: report reportUid.
	self
		assert: readReport exceptionDescription
		equals: report exceptionDescription.
	self
		assert: (readReport stackNamed: 'stack') text
		equals: (report stackNamed: 'stack') text.
	self assert: readReport debugLog equals: report debugLog.
	self assert: readReport screenshotBytes equals: report screenshotBytes.
	self
		assert: readReport screenshotForm extent
		equals: report screenshotForm extent.

	^ readReport
]

{ #category : #'examples - debug log report' }
GtDebuggerReportExamples >> debugLogReportStored [
	"The stacks, the debug log and the screenshot are stored in their own files, next to the JSON summary"

	<gtExample>
	<return: #GtReportsStoreEntry>
	| entry |
	entry := self debugLogReportOfPharoDebugger storeIn: self memoryStore.

	self
		assert: (entry files collect: [ :each | each basename ]) asArray
		equals: #('stack.txt' 'debug-log.txt' 'screenshot.png' 'debugger.json' 'meta.json').

	^ entry
]

{ #category : #'examples - session' }
GtDebuggerReportExamples >> debugSession [
	<gtExample>
	<return: #GtDebugSession>
	^ self debugSessionOn: [ self targetMethod_signalError ] withException: Error
]

{ #category : #'examples - store' }
GtDebuggerReportExamples >> memoryStore [
	<gtExample>
	<return: #GtReportsLocalStore>
	^ GtReportsLocalStore rootFolder: FileSystem memory root / 'gt-reports'
]

{ #category : #'examples - debug log report' }
GtDebuggerReportExamples >> scripterOnPharoDebugger [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self
			scripterInPagerWithDebuggerOn: (self debugSessionOn: [ self targetMethod_signalError ] withException: Error).

	scripter assert
		label: 'Assert the Pharo debugger is displayed';
		exists;
		// GtPharoDebuggerElement;
		play.

	^ scripter
]

{ #category : #'examples - stack report' }
GtDebuggerReportExamples >> stackReport [
	"A stack report contains the methods on the stack, as given by the debug session"

	<gtExample>
	<return: #GtDebuggerReport>
	| report |
	report := GtDebuggerReport stackReportForSession: self debugSession.

	self assert: report title equals: 'Error: An exception happened'.
	self assert: report exceptionClassName equals: 'Error'.
	self assert: report exceptionDescription equals: 'Error: An exception happened'.
	self assert: report hasStacks.
	self assert: (report stacks collect: [ :each | each name ]) equals: #('stack').
	self
		assert: ((report stackNamed: 'stack') text lines first: 2)
		equals: #('GtDebuggerReportExamples(Object)>>error:' 'GtDebuggerReportExamples>>targetMethod_signalError').
	self assert: report hasDebugLog not.
	self assert: report hasScreenshot not.

	^ report
]

{ #category : #'examples - stack report' }
GtDebuggerReportExamples >> stackReportReadFromStore [
	<gtExample>
	<return: #GtDebuggerReport>
	| report entry readReport |
	report := self stackReport.
	entry := report storeIn: self memoryStore.
	readReport := (GtStoredReportFiles folder: entry folder) report.

	self assert: readReport reportUid equals: report reportUid.
	self assert: readReport timestamp equals: report timestamp.
	self assert: readReport title equals: report title.
	self assert: readReport exceptionClassName equals: report exceptionClassName.
	self
		assert: readReport exceptionDescription
		equals: report exceptionDescription.
	self
		assert: (readReport stackNamed: 'stack') text
		equals: (report stackNamed: 'stack') text.
	self assert: readReport hasDebugLog not.
	self assert: readReport hasScreenshot not.

	^ readReport
]

{ #category : #'examples - stack report' }
GtDebuggerReportExamples >> stackReportStored [
	"Each stack is stored in its own text file, next to the JSON summary"

	<gtExample>
	<return: #GtReportsStoreEntry>
	| entry |
	entry := self stackReport storeIn: self memoryStore.

	self
		assert: (entry files collect: [ :each | each basename ]) asArray
		equals: #('stack.txt' 'debugger.json' 'meta.json').

	^ entry
]

{ #category : #'examples - target' }
GtDebuggerReportExamples >> targetMethod_signalError [
	^ self error: 'An exception happened'
]

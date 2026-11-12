"
I exemplify the debugger context menu (see {{gtClass:GtDebuggerContextMenuTarget}}) in the Pharo debugger and in the moldable exception debugger.

The debuggers are displayed in a pager, so that the inspected objects open in a new pane.
The GemStone debugger is exemplified in {{gtClass:name=GtRemoteGemStoneDebuggerContextMenuExamples}}.
"
Class {
	#name : #GtDebuggerContextMenuExamples,
	#superclass : #Object,
	#traits : 'TGtScripterDebuggerExamples',
	#classTraits : 'TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #'examples - copy stack' }
GtDebuggerContextMenuExamples >> debugLogOfDebugSession [
	"Like an entry in the Pharo debug log"

	<gtExample>
	<return: #ByteString>
	| debugLog |
	debugLog := self debugSessionWithErrorInBlock debugLogString.

	self assert: debugLog lines first equals: 'Error: An exception happened'.
	self assert: (debugLog includesSubstring: 'Pharo Image: ').
	self assert: (debugLog includesSubstring: '--- The full stack ---').
	self
		assert: (debugLog
				includesSubstring: 'GtDebuggerContextMenuExamples>>targetMethod_signalErrorInBlock').

	^ debugLog
]

{ #category : #'examples - copy stack' }
GtDebuggerContextMenuExamples >> debugSessionWithErrorInBlock [
	<gtExample>
	<return: #GtDebugSession>
	^ self
		debugSessionOn: [ self targetMethod_signalErrorInBlock ]
		withException: Error
]

{ #category : #'examples - moldable exception debugger' }
GtDebuggerContextMenuExamples >> moldableExceptionDebuggerCopyDebugLog [
	<gtExample>
	<return: #BlScripter>
	| scripter previousClipboardText copiedText |
	scripter := self scripterOnMoldableExceptionDebugger.

	previousClipboardText := GtClipboard clipboardText.
	[ scripter debugger
		openContextMenu;
		assertContextMenuHasItemWithLabel: 'Copy Stack';
		clickContextMenuItemWithLabel: 'Copy Debug Log';
		play.

	copiedText := GtClipboard clipboardText asString.
	self
		assert: copiedText lines first
		equals: scripter model exception description.
	self assert: (copiedText includesSubstring: '--- The full stack ---') ]
		ensure: [ GtClipboard clipboardText: previousClipboardText ].

	^ scripter
]

{ #category : #'examples - moldable exception debugger' }
GtDebuggerContextMenuExamples >> moldableExceptionDebuggerInspectDebugSession [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self scripterOnMoldableExceptionDebugger.

	scripter debugger
		openContextMenu;
		clickContextMenuItemWithLabel: 'Inspect Debugging Session';
		play.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObject: scripter model;
		play.

	^ scripter
]

{ #category : #'examples - moldable exception debugger' }
GtDebuggerContextMenuExamples >> moldableExceptionDebuggerInspectException [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self scripterOnMoldableExceptionDebugger.

	scripter debugger
		openContextMenu;
		assertContextMenuHasNoItemWithLabel: 'Analyse exception (static)';
		clickContextMenuItemWithLabel: 'Inspect Exception';
		play.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObject: scripter model exception;
		play.

	^ scripter
]

{ #category : #'examples - moldable exception debugger' }
GtDebuggerContextMenuExamples >> moldableExceptionDebuggerInspectFromDebuggingTarget [
	"A domain object added with #addDebuggingTargetFor: contributes an action to the context menu"

	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self scripterOnMoldableExceptionDebuggerWithDebuggingTargets.

	scripter debugger
		openContextMenu;
		assertContextMenuHasNoItemWithLabel: 'Inspect Expected String';
		clickContextMenuItemWithLabel: 'Inspect Message';
		play.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObject: scripter model exception objectOne message;
		play.

	^ scripter
]

{ #category : #'examples - moldable exception debugger' }
GtDebuggerContextMenuExamples >> moldableExceptionDebuggerInspectFromSpecificationTarget [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self scripterOnMoldableExceptionDebuggerWithSpecificationTarget.

	scripter debugger
		openContextMenu;
		assertContextMenuHasItemWithLabel: 'Inspect Exception';
		clickContextMenuItemWithLabel: 'Inspect Expected String';
		play.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObject: scripter model exception expectedString;
		play.

	^ scripter
]

{ #category : #'examples - pharo debugger' }
GtDebuggerContextMenuExamples >> pharoDebuggerCopyStack [
	<gtExample>
	<return: #BlScripter>
	| scripter previousClipboardText |
	scripter := self scripterOnPharoDebugger.

	previousClipboardText := GtClipboard clipboardText.
	[ scripter debugger
		openContextMenu;
		assertContextMenuHasItemWithLabel: 'Copy Debug Log';
		clickContextMenuItemWithLabel: 'Copy Stack';
		play.

	self
		assert: GtClipboard clipboardText asString
		equals: scripter model stackMethodsString ]
		ensure: [ GtClipboard clipboardText: previousClipboardText ].

	^ scripter
]

{ #category : #'examples - pharo debugger' }
GtDebuggerContextMenuExamples >> pharoDebuggerInspectDebugSession [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self scripterOnPharoDebugger.

	scripter debugger
		openContextMenu;
		clickContextMenuItemWithLabel: 'Inspect Debugging Session';
		play.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObject: scripter model;
		play.

	^ scripter
]

{ #category : #'examples - pharo debugger' }
GtDebuggerContextMenuExamples >> pharoDebuggerInspectException [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self scripterOnPharoDebugger.

	scripter debugger
		openContextMenu;
		assertContextMenuHasNoItemWithLabel: 'Inspect Recent Exception';
		clickContextMenuItemWithLabel: 'Inspect Exception';
		play.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObject: scripter model exception;
		play.

	^ scripter
]

{ #category : #'examples - pharo debugger' }
GtDebuggerContextMenuExamples >> pharoDebuggerInspectRecentException [
	"After a debugging action clears the exception, the menu offers the most recent exception"

	<gtExample>
	<return: #BlScripter>
	| scripter exception |
	scripter := self scripterOnPharoDebugger.
	exception := scripter model exception.

	scripter debugger
		onThisOrBreadthFirstChildOfClass: GtMoldableDebugger;
		clickOnRestartButton;
		assertInSessionNoException;
		play.

	scripter debugger
		openContextMenu;
		assertContextMenuHasNoItemWithLabel: 'Inspect Exception';
		clickContextMenuItemWithLabel: 'Inspect Recent Exception';
		play.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObject: exception;
		play.

	^ scripter
]

{ #category : #'examples - moldable exception debugger' }
GtDebuggerContextMenuExamples >> scripterOnMoldableExceptionDebugger [
	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self
			scripterInPagerWithDebuggerOn: GtExceptionsWithExtensionsExamples new
					debugingSession_exampleExceptionWithDebuggingView.

	scripter assert
		label: 'Assert the moldable exception debugger is displayed';
		exists;
		// GtMoldableExceptionDebuggingElement;
		play.

	scripter debugger
		onThisOrBreadthFirstChildOfClass: GtMoldableDebugger;
		assertInSessionExceptionOfType: GtExampleExceptionWithDebuggingView;
		play.

	^ scripter
]

{ #category : #'examples - moldable exception debugger' }
GtDebuggerContextMenuExamples >> scripterOnMoldableExceptionDebuggerWithDebuggingTargets [
	"The exception's debugger specification adds domain objects as debugging targets"

	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self
			scripterInPagerWithDebuggerOn: (self
					debugSessionOn: [ GtExampleExceptionWithForwardedDebuggingView signalWithDomainData ]
					withException: GtExampleExceptionWithForwardedDebuggingView).

	scripter assert
		label: 'Assert the moldable exception debugger is displayed';
		exists;
		// GtMoldableExceptionDebuggingElement;
		play.

	^ scripter
]

{ #category : #'examples - moldable exception debugger' }
GtDebuggerContextMenuExamples >> scripterOnMoldableExceptionDebuggerWithSpecificationTarget [
	"The exception's debugger specification adds an extra target to the context menu"

	<gtExample>
	<return: #BlScripter>
	| scripter |
	scripter := self
			scripterInPagerWithDebuggerOn: (self
					debugSessionOn: [ GtExampleExceptionWithDebuggerContextMenuAction new
							expectedString: 'expected';
							actualString: 'actual';
							signal ]
					withException: GtExampleExceptionWithDebuggerContextMenuAction).

	scripter assert
		label: 'Assert the moldable exception debugger is displayed';
		exists;
		// GtMoldableExceptionDebuggingElement;
		play.

	^ scripter
]

{ #category : #'examples - pharo debugger' }
GtDebuggerContextMenuExamples >> scripterOnPharoDebugger [
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

	scripter debugger
		onThisOrBreadthFirstChildOfClass: GtMoldableDebugger;
		assertInSessionExceptionOfType: Error;
		play.

	^ scripter
]

{ #category : #'examples - copy stack' }
GtDebuggerContextMenuExamples >> stackMethodsOfDebugSession [
	"One method per stack frame; frames of blocks are prefixed with '[] in '"

	<gtExample>
	<return: #ByteString>
	| stackMethods |
	stackMethods := self debugSessionWithErrorInBlock stackMethodsString.

	self
		assert: (stackMethods lines first: 5)
		equals: #('GtDebuggerContextMenuExamples(Object)>>error:' 'GtDebuggerContextMenuExamples>>targetMethod_signalError' '[] in GtDebuggerContextMenuExamples>>targetMethod_signalErrorInBlock' 'Array(SequenceableCollection)>>do:' 'GtDebuggerContextMenuExamples>>targetMethod_signalErrorInBlock').
	self assert: (stackMethods includesSubstring: 'and more not shown') not.

	^ stackMethods
]

{ #category : #'examples - copy stack' }
GtDebuggerContextMenuExamples >> stackMethodsOfDeepStackAreLimited [
	"At most the default stack limit of GtDebuggerStackMethodsPrinter frames are listed"

	<gtExample>
	<return: #ByteString>
	| debugSession stackMethods lines |
	debugSession := self
			debugSessionOn: [ self targetMethod_signalErrorAfterRecursion: 1100 ]
			withException: Error.
	stackMethods := debugSession stackMethodsString.
	lines := stackMethods lines.

	self
		assert: lines size
		equals: GtDebuggerStackMethodsPrinter new stackLimit + 1.
	self
		assert: (lines at: 3)
		equals: 'GtDebuggerContextMenuExamples>>targetMethod_signalErrorAfterRecursion:'.
	self assert: lines last equals: '-- and more not shown --'.

	^ stackMethods
]

{ #category : #'examples - copy stack' }
GtDebuggerContextMenuExamples >> stackMethodsWithCustomLimit [
	<gtExample>
	<return: #ByteString>
	| stackMethods |
	stackMethods := GtDebuggerStackMethodsPrinter new
			stackLimit: 3;
			printStackOf: self debugSessionWithErrorInBlock interruptedContext.

	self
		assert: stackMethods lines
		equals: #('GtDebuggerContextMenuExamples(Object)>>error:' 'GtDebuggerContextMenuExamples>>targetMethod_signalError' '[] in GtDebuggerContextMenuExamples>>targetMethod_signalErrorInBlock' '-- and more not shown --').

	^ stackMethods
]

{ #category : #'examples - target' }
GtDebuggerContextMenuExamples >> targetMethod_signalError [
	^ self error: 'An exception happened'
]

{ #category : #'examples - target' }
GtDebuggerContextMenuExamples >> targetMethod_signalErrorAfterRecursion: aDepth [
	aDepth = 0 ifTrue: [ ^ self targetMethod_signalError ].
	^ self targetMethod_signalErrorAfterRecursion: aDepth - 1
]

{ #category : #'examples - target' }
GtDebuggerContextMenuExamples >> targetMethod_signalErrorInBlock [
	^ #(1) do: [ :each | self targetMethod_signalError ]
]

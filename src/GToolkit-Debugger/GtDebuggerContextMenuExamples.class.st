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
		clickContextMenuItemWithLabel: 'Inspect Exception';
		play.

	scripter inspectorStep
		onPagerPaneWithIndex: 2;
		assertInspectedObject: scripter model exception;
		play.

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

{ #category : #'examples - target' }
GtDebuggerContextMenuExamples >> targetMethod_signalError [
	^ self error: 'An exception happened'
]

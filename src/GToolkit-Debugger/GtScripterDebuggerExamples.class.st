Class {
	#name : #GtScripterDebuggerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #private }
GtScripterDebuggerExamples >> debuggerOn: aBlock stoppingAt: testBlock [
	"self new 
		debuggerOn: [10 slowFactorial] 
		stoppingAt: [:context | context selector = #slowFactorial and: [context receiver = 5]]"

	| process |
	process := aBlock newProcess.
	[ testBlock value: process suspendedContext ]
		whileFalse: [ process step: process suspendedContext ].
	^ GtMoldableDebugger
		on: (DebugSession
				named: 'Scripted debugger'
				on: process
				startedAt: process suspendedContext)
]

{ #category : #accessing }
GtScripterDebuggerExamples >> returnOnePlusOne [
	^ 1 + 1
]

{ #category : #accessing }
GtScripterDebuggerExamples >> savingDoesNotMoveCursor [
	"https://github.com/feenkcom/gtoolkit/issues/3419"

	<gtExample>
	| scripter |
	scripter := self scripterOnOnePlusOneDebugger.

	scripter assert
		id: GtSourceCoderEditorId index: 1;
		value: [ :editor | editor editor cursors first position ] equals: 0;
		play.

	scripter keyPress
		key: BlKeyboardKey arrowRight;
		play.

	scripter assert
		id: GtSourceCoderEditorId index: 1;
		value: [ :editor | editor editor cursors first position ] equals: 1;
		play.

	scripter click
		id: GtMethodCoderSaveActionId index: 1;
		play.

	scripter assert
		id: GtSourceCoderEditorId index: 1;
		value: [ :editor | editor editor cursors first position ] equals: 1;
		play.

	^ scripter
]

{ #category : #accessing }
GtScripterDebuggerExamples >> scripterOnOnePlusOneDebugger [
	| scripter debugger |
	debugger := self
			debuggerOn: [ self returnOnePlusOne ]
			stoppingAt: [ :context | context selector = #returnOnePlusOne ].
	scripter := BlScripter new.
	scripter element: debugger.
	^ scripter
]

{ #category : #accessing }
GtScripterDebuggerExamples >> switchingCodersDoesNotLoseChanges [
	"https://github.com/feenkcom/gtoolkit/issues/3418"

	<gtExample>
	| scripter methodSource |
	scripter := self scripterOnOnePlusOneDebugger.
	methodSource := (self class >> #returnOnePlusOne) sourceCode.
	
	scripter assert
		id: GtSourceCoderEditorId index: 1;
		value: [ :editor | editor text asString ] equals: methodSource;
		play.
		
	scripter keyPress
		key: BlKeyboardKey return;
		play.
		
	scripter assert
		id: GtSourceCoderEditorId index: 1;
		value: [ :editor | editor text asString ] equals: String cr , methodSource;
		play.
		
	scripter click
		label: 'Click second coder';
		id: GtSourceCoderExpanderToggleId index: 2;
		play.
		
	scripter requestFocus
		id: GtSourceCoderEditorId index: 2;
		play.
		
	scripter requestFocus
		id: GtSourceCoderEditorId index: 1;
		play.
		
	scripter assert
		id: GtSourceCoderEditorId index: 1;
		value: [ :editor | editor text asString ] equals: String cr , methodSource;
		play.
		
	^ scripter
]

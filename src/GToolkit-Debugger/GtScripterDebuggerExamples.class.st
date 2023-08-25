Class {
	#name : #GtScripterDebuggerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #asserting }
GtScripterDebuggerExamples >> assertContext: scripter at: index satisfies: aBlock [
	scripter assert
		id: GtSourceCoderEditorId index: index;
		value: [ :editor | 
				editor
					allParentsDetect: [ :each | each class = GtExpandableContextMethodCoderElement ]
					ifFound: [ :each | aBlock value: each coderViewModel context ]
					ifNone: [  ] ]
			equals: true;
		play
]

{ #category : #asserting }
GtScripterDebuggerExamples >> assertModifiedIndicatorInvisible: scripter at: index [
	scripter assert
		id: GtTextualCoderModificationIndicatorId index: index;
		value: [ :element | element visibility ] equals: BlVisibility gone;
		play
]

{ #category : #asserting }
GtScripterDebuggerExamples >> assertModifiedIndicatorVisible: scripter at: index [
	scripter assert
		id: GtTextualCoderModificationIndicatorId index: index;
		value: [ :element | element visibility ] equals: BlVisibility visible;
		play
]

{ #category : #asserting }
GtScripterDebuggerExamples >> assertUninstalledIndicatorInvisible: scripter at: index [
	scripter assert
		id: #'coder-uninstalled-indicator' index: index;
		value: [ :element | element visibility ] equals: BlVisibility gone;
		play
]

{ #category : #asserting }
GtScripterDebuggerExamples >> assertUninstalledIndicatorVisible: scripter at: index [
	scripter assert
		id: #'coder-uninstalled-indicator' index: index;
		value: [ :element | element visibility ] equals: BlVisibility visible;
		play
]

{ #category : #examples }
GtScripterDebuggerExamples >> createDNUMethod [
	"<gtExample>"
	| scripter |
	scripter := self scripterOnDNUDebugger.

	[ scripter assert
		@ [ :element | ((element childWithId: #toolbar) childAt: 1) childAt: 1 ];
		value: [ :button | button label asString ] equals: 'Create';
		play.

	scripter click
		@ [ :element | ((element childWithId: #toolbar) childAt: 1) childAt: 1 ];
		play.
	(Delay forMilliseconds: 1000) wait.
	scripter pulse.
	
	scripter click
		label: 'Click first coder';
		id: GtSourceCoderExpanderToggleId index: 1;
		play.

	self assert: (self class includesSelector: #dnuCall).

	self
		assertContext: scripter
		at: 1
		satisfies: [ :context | context selector = #dnuCall ].

	scripter assert
		id: GtSourceCoderEditorId index: 1;
		value: [ :editor | editor text asString beginsWith: 'dnuCall' ] equals: true;
		play ] ensure: [ self class removeSelector: #dnuCall ].

	^ scripter
]

{ #category : #private }
GtScripterDebuggerExamples >> debuggerOn: aBlock stoppingAt: testBlock [
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

{ #category : #'debugger methods' }
GtScripterDebuggerExamples >> doMethod [
	| total |
	total := 0.
	(1 to: 10) asArray do: [ :i | total := total + i ].
	^ total
]

{ #category : #examples }
GtScripterDebuggerExamples >> modifyingBlockThatCannotBeRestarted [
	<gtExample>
	| scripter debugger |
	self class compile: 'aMethod ^[1 + 1]'.
	[ debugger := self
			debuggerOn: [ self aMethod value ]
			stoppingAt: [ :context | context selector = #aMethod and: [ context isBlockContext ] ].
	scripter := BlScripter new.
	scripter element: debugger.

	self
		assertContext: scripter
		at: 1
		satisfies: [ :context | context isBlockContext ].

	self assertUninstalledIndicatorInvisible: scripter at: 1.

	scripter keyPress
		key: BlKeyboardKey return;
		play.

	self assertModifiedIndicatorVisible: scripter at: 1.

	self assertUninstalledIndicatorInvisible: scripter at: 1.

	scripter click
		id: GtMethodCoderSaveActionId index: 1;
		play.
	scripter pulse.

	self
		assertContext: scripter
		at: 1
		satisfies: [ :context | context isBlockContext ].

	self assertUninstalledIndicatorVisible: scripter at: 1.

	self assertModifiedIndicatorInvisible: scripter at: 1.

	scripter keyPress
		key: BlKeyboardKey backspace;
		play.

	self assertModifiedIndicatorVisible: scripter at: 1.

	scripter keyPress
		key: BlKeyboardKey return;
		play.

	self assertModifiedIndicatorInvisible: scripter at: 1 ]
		ensure: [ self class removeSelector: #aMethod ].
	^ scripter
]

{ #category : #examples }
GtScripterDebuggerExamples >> modifyingMethodShowsIndicator [
	<gtExample>
	| scripter |
	scripter := self scripterOnOnePlusOneDebugger.

	self assertModifiedIndicatorInvisible: scripter at: 1.

	scripter keyPress
		key: BlKeyboardKey return;
		play.

	self assertModifiedIndicatorVisible: scripter at: 1.

	scripter keyPress
		key: BlKeyboardKey backspace;
		play.

	self assertModifiedIndicatorInvisible: scripter at: 1.

	^ scripter
]

{ #category : #'debugger methods' }
GtScripterDebuggerExamples >> returnBlock [
	^ [ self printString ]
]

{ #category : #'debugger methods' }
GtScripterDebuggerExamples >> returnOnePlusOne [
	^ 1 + 1
]

{ #category : #examples }
GtScripterDebuggerExamples >> savingBlockRestartsMethod [
	<gtExample>
	| scripter |
	scripter := self scripterOnDoMethodDebugger.

	self
		assertContext: scripter
		at: 1
		satisfies: [ :context | context isBlockContext ].

	scripter click
		id: GtMethodCoderSaveActionId index: 1;
		play.

	self
		assertContext: scripter
		at: 1
		satisfies: [ :context | context isBlockContext not ].

	self assertUninstalledIndicatorInvisible: scripter at: 1.

	^ scripter
]

{ #category : #examples }
GtScripterDebuggerExamples >> savingBlockThatCannotBeRestarted [
	<gtExample>
	| scripter |
	scripter := self scripterOnReturnedBlockDebugger.

	self
		assertContext: scripter
		at: 1
		satisfies: [ :context | context isBlockContext ].

	self assertUninstalledIndicatorInvisible: scripter at: 1.

	scripter click
		id: GtMethodCoderSaveActionId index: 1;
		play.


	self
		assertContext: scripter
		at: 1
		satisfies: [ :context | context isBlockContext ].

	self assertUninstalledIndicatorVisible: scripter at: 1.

	^ scripter
]

{ #category : #examples }
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

{ #category : #examples }
GtScripterDebuggerExamples >> savingMethodOutsideDebuggerShowsUninstalledIndicator [
	<gtExample>
	| scripter methodSource |
	scripter := self scripterOnOnePlusOneDebugger.
	methodSource := (self class >> #returnOnePlusOne) sourceCode.
	
	self assertUninstalledIndicatorInvisible: scripter at: 1.

	self class compile: methodSource.
	scripter pulse.
	
	self assertUninstalledIndicatorVisible: scripter at: 1.

	^ scripter
]

{ #category : #scripter }
GtScripterDebuggerExamples >> scripterOnDNUDebugger [
	| scripter debugger |
	debugger := self
			debuggerOn: [ self dnuCall ]
			stoppingAt: [ :context | context selector = #doesNotUnderstand: ].
	scripter := BlScripter new.
	scripter element: debugger.
	^ scripter
]

{ #category : #scripter }
GtScripterDebuggerExamples >> scripterOnDoMethodDebugger [
	| scripter debugger |
	debugger := self
			debuggerOn: [ self doMethod ]
			stoppingAt: [ :context | context selector = #doMethod and: [ context isBlockContext ] ].
	scripter := BlScripter new.
	scripter element: debugger.
	^ scripter
]

{ #category : #scripter }
GtScripterDebuggerExamples >> scripterOnOnePlusOneDebugger [
	| scripter debugger |
	debugger := self
			debuggerOn: [ self returnOnePlusOne ]
			stoppingAt: [ :context | context selector = #returnOnePlusOne ].
	scripter := BlScripter new.
	scripter element: debugger.
	^ scripter
]

{ #category : #scripter }
GtScripterDebuggerExamples >> scripterOnReturnedBlockDebugger [
	| scripter debugger |
	debugger := self
			debuggerOn: [ self returnBlock value ]
			stoppingAt: [ :context | context selector = #returnBlock and: [ context isBlockContext ] ].
	scripter := BlScripter new.
	scripter element: debugger.
	^ scripter
]

{ #category : #examples }
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

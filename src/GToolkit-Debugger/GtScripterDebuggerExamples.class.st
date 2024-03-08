Class {
	#name : #GtScripterDebuggerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #asserting }
GtScripterDebuggerExamples >> assertContext: scripter at: index satisfies: aBlock [
	scripter
		assertStep: [ :aStep | 
			aStep
				id: GtSourceCoderEditorId index: index;
				value: [ :editor | 
						editor
							allParentsDetect: [ :each | 
								each class = GtExpandableContextMethodCoderElement ]
							ifFound: [ :each | aBlock value: each coderViewModel context ]
							ifNone: [  ] ]
					equals: true ]
]

{ #category : #asserting }
GtScripterDebuggerExamples >> assertModifiedIndicatorInvisible: scripter at: index [
	scripter
		assertStep: [ :s | 
			s
				id: GtTextualCoderModificationIndicatorId index: index;
				value: [ :element | element visibility ] equals: BlVisibility gone ]
]

{ #category : #asserting }
GtScripterDebuggerExamples >> assertModifiedIndicatorVisible: scripter at: index [
	scripter
		assertStep: [ :aStep | 
			aStep
				id: GtTextualCoderModificationIndicatorId index: index;
				value: [ :element | element visibility ] equals: BlVisibility visible ]
]

{ #category : #asserting }
GtScripterDebuggerExamples >> assertUninstalledIndicatorInvisible: scripter at: index [
	scripter
		assertStep: [ :s | 
			s
				id: #'coder-uninstalled-indicator' index: index;
				value: [ :element | element visibility ] equals: BlVisibility gone ]
]

{ #category : #asserting }
GtScripterDebuggerExamples >> assertUninstalledIndicatorVisible: scripter at: index [
	scripter
		assertStep: [ :s | 
			s
				id: #'coder-uninstalled-indicator' index: index;
				value: [ :element | element visibility ] equals: BlVisibility visible ]
]

{ #category : #examples }
GtScripterDebuggerExamples >> createDNUMethod [
	"<gtExample>"

	| scripter |
	scripter := self scripterOnDNUDebugger.

	[ scripter
		assertStep: [ :s | 
			s
				@ [ :element | ((element childWithId: #toolbar) childAt: 1) childAt: 1 ];
				value: [ :button | button label asString ] equals: 'Create' ].

	scripter
		clickStep: [ :s | 
			s
				@ [ :element | ((element childWithId: #toolbar) childAt: 1) childAt: 1 ] ].
	(Delay forMilliseconds: 1000) wait.
	scripter pulse.

	scripter
		clickStep: [ :s | 
			s
				label: 'Click first coder';
				id: GtSourceCoderExpanderToggleId index: 1 ].

	self assert: (self class includesSelector: #dnuCall).

	self
		assertContext: scripter
		at: 1
		satisfies: [ :context | context selector = #dnuCall ].

	scripter
		assertStep: [ :s | 
			s
				id: GtSourceCoderEditorId index: 1;
				value: [ :editor | editor text asString beginsWith: 'dnuCall' ]
					equals: true ] ] ensure: [ self class removeSelector: #dnuCall ].

	^ scripter
]

{ #category : #private }
GtScripterDebuggerExamples >> debuggerOn: aBlock stoppingAt: testBlock [
	| process |
	process := aBlock newProcess.
	[ testBlock value: process suspendedContext ]
		whileFalse: [ process step: process suspendedContext ].
	^ (GtMoldableDebugger
		on: (DebugSession
				named: 'Scripted debugger'
				on: process
				startedAt: process suspendedContext)) beDetailedLevel
]

{ #category : #'debugger methods' }
GtScripterDebuggerExamples >> doMethod [
	| total |
	total := 0.
	(1 to: 10) asArray do: [ :i | total := total + i ].
	^ total
]

{ #category : #examples }
GtScripterDebuggerExamples >> doubleClickExpandDebuggerPlayground [
	<gtExample>
	| scripter |
	scripter := self scripterOnDoMethodDebugger.

	scripter debugger
		assertPlaygroundExpanderCollapsed;
		doubleClickOnPlaygroudExpander;
		assertPlaygroundExpanderVisible.
	
	self assert: (scripter element query 
		lepiterQuery firstSnippetInPage) anyOne hasFocus.
	
	scripter debugger
		doubleClickOnPlaygroudExpander;
		assertPlaygroundExpanderCollapsed.
		
	^ scripter
]

{ #category : #examples }
GtScripterDebuggerExamples >> methodContextCoderElementOnInheritedMethod [
	<gtExample>
	
	^ BlScripter new
		element: self methodContextCoderOnInheritedMethod asElement
]

{ #category : #examples }
GtScripterDebuggerExamples >> methodContextCoderElementOnInheritedMethod_BreadcrumbContent [
	<gtExample>
	| scripter |
	
	scripter := self methodContextCoderElementOnInheritedMethod.
	scripter
		checks: 'Check Breadcrumb'
		do: [ :aStep | 
			aStep
				assertStep: [ :s | 
					s
						label: 'Assert Breadcrumb Package Name';
						value: [ :aButton | aButton label asString ]
							equals: [ Object package name ];
						onBreadthFirstChildOfClass: GtPharoMethodCoderHeaderElement;
						onChildAt: 1 ].

			aStep
				assertStep: [ :s | 
					s
						label: 'Assert Breadcrumb Class Name';
						value: [ :aButton | aButton label asString ]
							equals: [ 'ByteString' ];
						onBreadthFirstChildOfClass: GtPharoMethodCoderHeaderElement;
						onChildAt: 3 ].
						
			aStep
				assertStep: [ :s | 
					s
						label: 'Assert Breadcrumb Class Name';
						value: [ :aButton | aButton label asString ]
							equals: [ 'Object' ];
						onBreadthFirstChildOfClass: GtPharoMethodCoderHeaderElement;
						id: #secondBehaviorButton ] ].
	
	^ scripter
]

{ #category : #examples }
GtScripterDebuggerExamples >> methodContextCoderOnInheritedMethod [
	<gtExample>
	| debugger |
	debugger := self
			debuggerOn: [ '123' printString  ]
			stoppingAt: [ :context | context selector = #printString ].
	^ GtPharoMethodContextCoder
		forContext: debugger debugSession interruptedContext
		session: debugger debugSession.
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

	scripter
		keyPressStep: [ :s | 
			s
				key: BlKeyboardKey return ].

	self assertModifiedIndicatorVisible: scripter at: 1.

	self assertUninstalledIndicatorInvisible: scripter at: 1.

	scripter
		clickStep: [ :s | 
			s
				id: GtMethodCoderSaveActionId index: 1 ].
	scripter pulse.

	self
		assertContext: scripter
		at: 1
		satisfies: [ :context | context isBlockContext ].

	self assertUninstalledIndicatorVisible: scripter at: 1.

	self assertModifiedIndicatorInvisible: scripter at: 1.

	scripter
		keyPressStep: [ :s | 
			s
				key: BlKeyboardKey backspace ].

	self assertModifiedIndicatorVisible: scripter at: 1.

	scripter
		keyPressStep: [ :s | 
			s
				key: BlKeyboardKey return ].

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

	scripter
		keyPressStep: [ :s | 
			s
				key: BlKeyboardKey return ].

	self assertModifiedIndicatorVisible: scripter at: 1.

	scripter
		keyPressStep: [ :s | 
			s
				key: BlKeyboardKey backspace ].

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

	scripter
		clickStep: [ :s | 
			s
				id: GtMethodCoderSaveActionId index: 1 ].

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

	scripter
		clickStep: [ :s | 
			s
				id: GtMethodCoderSaveActionId index: 1 ].


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

	scripter
		assertStep: [ :s | 
			s
				id: GtSourceCoderEditorId index: 1;
				value: [ :editor | editor editor cursors first position ] equals: 0 ].

	scripter
		keyPressStep: [ :s | 
			s
				key: BlKeyboardKey arrowRight ].

	scripter
		assertStep: [ :s | 
			s
				id: GtSourceCoderEditorId index: 1;
				value: [ :editor | editor editor cursors first position ] equals: 1 ].

	scripter
		clickStep: [ :s | 
			s
				id: GtMethodCoderSaveActionId index: 1 ].

	scripter
		assertStep: [ :s | 
			s
				id: GtSourceCoderEditorId index: 1;
				value: [ :editor | editor editor cursors first position ] equals: 1 ].

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

{ #category : #'examples - embedded method' }
GtScripterDebuggerExamples >> scripterOnEnumerationDebugger [
	<gtExample>
	<noTest>
	| scripter debugger |
	debugger := self
			debuggerOn: [ GtDebuggerDummySelfCallsObject new enumerate ]
			stoppingAt: [ :context | context selector = #enumerate ].
	debugger debugSession stepOver.
	debugger debugSession stepOver.
	debugger debugSession stepThrough.
	debugger debugSession stepThrough.
	scripter := BlScripter new.
	scripter element: debugger.

	scripter do
		label: 'Set window size';
		block: [ :aSpace | aSpace extent: 1200 @ 600 ];
		onSpace;
		play.	
		
	"scripter
		assertStep: [ :s | 
			s
				label: 'Assert element has a method expander';
				exists;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// (GtPharoMethodExpanderId indexed: 1) ].
	scripter
		clickStep: [ :s | 
			s
				label: 'Click on the method expander';
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// (GtPharoMethodExpanderId indexed: 1) ].
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert embeded method has play and inspect button';
				exists;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderExpandedContentElement;
				// GtPharoMethodPlayAndInspectActionId ].
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert aNumber value';
				value: [ :aCoderElement | aCoderElement textualCoderViewModel localBindings bindingValueOf: #aNumber ]
					equals: 3;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderEditorId ].
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert receiver object';
				value: [ :aCoderElement | aCoderElement textualCoderViewModel selfObject ]
					equals: 42;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderEditorId ].

	scripter
		clickStep: [ :s | 
			s
				label: 'Click embeded method play and inspect button';
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderExpandedContentElement;
				// GtPharoMethodPlayAndInspectActionId ]."

	^ scripter
]

{ #category : #'examples - embedded method' }
GtScripterDebuggerExamples >> scripterOnInstAReceiverDebugger [
	<gtExample>
	| scripter debugger |
	debugger := self
			debuggerOn: [ GtDebuggerDummySelfCallsObject new instAReceiver ]
			stoppingAt: [ :context | context selector = #instAReceiver ].
	debugger debugSession stepOver.
	debugger debugSession stepOver.
	scripter := BlScripter new.
	scripter element: debugger.

	scripter do
		label: 'Set window size';
		block: [ :aSpace | aSpace extent: 1200 @ 600 ];
		onSpace;
		play.

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert element has a method expander';
				exists;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// (GtPharoMethodExpanderId indexed: 1) ].
	scripter
		clickStep: [ :s | 
			s
				label: 'Click on the method expander';
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// (GtPharoMethodExpanderId indexed: 1) ].
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert embeded method has play and inspect button';
				exists;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderExpandedContentElement;
				// GtPharoMethodPlayAndInspectActionId ].
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert aNumber value';
				value: [ :aCoderElement | aCoderElement textualCoderViewModel localBindings bindingValueOf: #aNumber ]
					equals: 3;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderEditorId ].
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert receiver object';
				value: [ :aCoderElement | aCoderElement textualCoderViewModel selfObject ]
					equals: 42;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderEditorId ].

	scripter
		clickStep: [ :s | 
			s
				label: 'Click embeded method play and inspect button';
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderExpandedContentElement;
				// GtPharoMethodPlayAndInspectActionId ].

	^ scripter
]

{ #category : #'examples - embedded method' }
GtScripterDebuggerExamples >> scripterOnInstAReceiverDebugger2 [
	<gtExample>
	| scripter debugger |
	debugger := self
			debuggerOn: [ GtDebuggerDummySelfCallsObject new instAReceiver ]
			stoppingAt: [ :context | context selector = #instAReceiver ].
	debugger debugSession stepOver.
	debugger debugSession stepOver.
	scripter := BlScripter new.
	scripter element: debugger.

	scripter do
		label: 'Set window size';
		block: [ :aSpace | aSpace extent: 1200 @ 600 ];
		onSpace;
		play.

	scripter methodCoder
		assertExpandersCountIs: 1;
		clickOnExpander: 1
			insideDo: [ :s | 
				s
					assertExpandersCountIs: 15;
					assertPlayAndInspectActionExists;
					assertSelfObjectIs: 42;
					assertBinding: #aNumber is: 3;
					clickOnPlayAndInspectButton ];
		// (GtExpandableContextMethodCoderId indexed: 1);
		play.

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

{ #category : #'examples - embedded method' }
GtScripterDebuggerExamples >> scripterOnSelfCallSum21Debugger [
	<gtExample>
	| scripter debugger |
	debugger := self
			debuggerOn: [ GtDebuggerDummySelfCallsObject new sum21 ]
			stoppingAt: [ :context | context selector = #sum21 ].
	debugger debugSession stepOver.
	debugger debugSession stepOver.
	scripter := BlScripter new.
	scripter element: debugger.

	scripter do
		label: 'Set window size';
		block: [ :aSpace | aSpace extent: 1200 @ 600 ];
		onSpace;
		play.

	scripter
		clickStep: [ :s | 
			s
				label: 'Click on method two expander';
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// (GtPharoMethodExpanderId indexed: 1) ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert tempA value';
				value: [ :aCoderElement | aCoderElement textualCoderViewModel localBindings bindingValueOf: #tempA ]
					equals: 2;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderEditorId ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert tempB value';
				value: [ :aCoderElement | aCoderElement textualCoderViewModel localBindings bindingValueOf: #tempB ]
					equals: 1;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderEditorId ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert play and inspect button';
				exists;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderExpandedContentElement;
				// GtPharoMethodPlayAndInspectActionId ].

	^ scripter
]

{ #category : #'examples - embedded method' }
GtScripterDebuggerExamples >> scripterOnSelfCallSumABDebugger [
	<gtExample>
	| scripter debugger |
	debugger := self
			debuggerOn: [ GtDebuggerDummySelfCallsObject new sum39 ]
			stoppingAt: [ :context | context selector = #sum39 ].
	debugger debugSession stepOver.
	debugger debugSession stepOver.
	debugger debugSession stepOver.
	scripter := BlScripter new.
	scripter element: debugger.

	scripter do
		label: 'Set window size';
		block: [ :aSpace | aSpace extent: 1200 @ 600 ];
		onSpace;
		play.

	scripter
		clickStep: [ :s | 
			s
				label: 'Click on method two expander';
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// (GtPharoMethodExpanderId indexed: 1) ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert embedded method bingings';
				value: [ :aCoderElement | aCoderElement textualCoderViewModel localBindings bindingValueOf: #valueA ]
					equals: 3;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderEditorId ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert embedded method bingings';
				value: [ :aCoderElement | aCoderElement textualCoderViewModel localBindings bindingValueOf: #valueB ]
					equals: 9;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderEditorId ].

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert play and inspect button';
				exists;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderExpandedContentElement;
				// GtPharoMethodPlayAndInspectActionId ].

	^ scripter
]

{ #category : #'examples - embedded method' }
GtScripterDebuggerExamples >> scripterOnSelfCallThreeDebugger [
	<gtExample>
	| scripter debugger |
	debugger := self
			debuggerOn: [ GtDebuggerDummySelfCallsObject new three ]
			stoppingAt: [ :context | context selector = #three ].
	scripter := BlScripter new.
	scripter element: debugger.

	scripter do
		label: 'Set window size';
		block: [ :aSpace | aSpace extent: 1200 @ 600 ];
		onSpace;
		play.

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert element has method two expander';
				exists;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// (GtPharoMethodExpanderId indexed: 1) ].
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert element has method one expander';
				exists;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// (GtPharoMethodExpanderId indexed: 2) ].
	scripter
		clickStep: [ :s | 
			s
				label: 'Click on method two expander';
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// (GtPharoMethodExpanderId indexed: 1) ].
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert embeded method has play and inspect button';
				exists;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderExpandedContentElement;
				// GtPharoMethodPlayAndInspectActionId ].
	scripter
		clickStep: [ :s | 
			s
				label: 'Click embeded method play and inspect button';
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderExpandedContentElement;
				// GtPharoMethodPlayAndInspectActionId ].

	^ scripter
]

{ #category : #'examples - embedded method' }
GtScripterDebuggerExamples >> scripterOnTempReceiverDebugger [
	<gtExample>
	| scripter debugger |
	debugger := self
			debuggerOn: [ GtDebuggerDummySelfCallsObject new tempReceiver ]
			stoppingAt: [ :context | context selector = #tempReceiver ].
	debugger debugSession stepOver.
	debugger debugSession stepOver.
	debugger debugSession stepOver.
	scripter := BlScripter new.
	scripter element: debugger.

	scripter do
		label: 'Set window size';
		block: [ :aSpace | aSpace extent: 1200 @ 600 ];
		onSpace;
		play.

	scripter
		assertStep: [ :s | 
			s
				label: 'Assert element has a method expander';
				exists;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// (GtPharoMethodExpanderId indexed: 1) ].
	scripter
		clickStep: [ :s | 
			s
				label: 'Click on the method expander';
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// (GtPharoMethodExpanderId indexed: 1) ].
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert embeded method has play and inspect button';
				exists;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderExpandedContentElement;
				// GtPharoMethodPlayAndInspectActionId ].
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert aNumber value';
				value: [ :aCoderElement | aCoderElement textualCoderViewModel localBindings bindingValueOf: #aNumber ]
					equals: 9;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderEditorId ].
	scripter
		assertStep: [ :s | 
			s
				label: 'Assert receiver object';
				value: [ :aCoderElement | aCoderElement textualCoderViewModel selfObject ]
					equals: 3;
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderEditorId ].

	scripter
		clickStep: [ :s | 
			s
				label: 'Click embeded method play and inspect button';
				// (GtExpandableContextMethodCoderId indexed: 1);
				// GtSourceCoderEditorId;
				// GtSourceCoderExpandedContentElement;
				// GtPharoMethodPlayAndInspectActionId ].

	^ scripter
]

{ #category : #examples }
GtScripterDebuggerExamples >> switchingCodersDoesNotLoseChanges [
	"https://github.com/feenkcom/gtoolkit/issues/3418"

	<gtExample>
	| scripter methodSource |
	scripter := self scripterOnOnePlusOneDebugger.
	methodSource := (self class >> #returnOnePlusOne) sourceCode.

	scripter
		assertStep: [ :s | 
			s
				id: GtSourceCoderEditorId index: 1;
				value: [ :editor | editor text asString ] equals: methodSource ].

	scripter
		keyPressStep: [ :s | 
			s
				key: BlKeyboardKey return ].

	scripter
		assertStep: [ :s | 
			s
				id: GtSourceCoderEditorId index: 1;
				value: [ :editor | editor text asString ] equals: String cr , methodSource ].

	scripter
		clickStep: [ :s | 
			s
				label: 'Click second coder';
				id: GtSourceCoderExpanderToggleId index: 2 ].

	scripter requestFocus
		id: GtSourceCoderEditorId index: 2;
		play.

	scripter requestFocus
		id: GtSourceCoderEditorId index: 1;
		play.

	scripter
		assertStep: [ :s | 
			s
				id: GtSourceCoderEditorId index: 1;
				value: [ :editor | editor text asString ] equals: String cr , methodSource ].

	^ scripter
]

"
process ifNotNil: [process terminate].
context := [ '11211212' printString ] asContext.
process := Process
	forContext: context
	priority: Processor userInterruptPriority.	
debuggingSession := GTBytecodeDebuggerSession 
	named: 'test debugging' 
	on: process 
	startedAt: process suspendedContext.
21 timesRepeat: [ 
	debuggingSession stepInto ].
GtBytecodeDebugger openInspectorOn: debuggingSession.

"
Class {
	#name : #GtBytecodeDebugger,
	#superclass : #GtStackDebuggerElement,
	#instVars : [
		'bytecodesPane',
		'bytecodesListElement'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #initialization }
GtBytecodeDebugger class >> defaultTitle [
	^ 'Bytecode'
]

{ #category : #accessing }
GtBytecodeDebugger class >> sessionClass [

	^ GTBytecodeDebuggerSession
]

{ #category : #callbacks }
GtBytecodeDebugger >> actOnSelectedBytecodeChangedFor: aSymbolicBytecode [
	| selectionForBytecode |
	selectionForBytecode := aSymbolicBytecode sourceInterval.
	self editorElement editor selecter
		overwrite;
		from: selectionForBytecode first - 1 to: selectionForBytecode last;
		withoutCursorUpdate;
		select
]

{ #category : #callbacks }
GtBytecodeDebugger >> actOnSelectedContextChangedFor: aContext [
	super actOnSelectedContextChangedFor: aContext.
	self updateBytecodePaneFor: aContext.
]

{ #category : #'building widgets' }
GtBytecodeDebugger >> buildBytecodesListElement [
	| bytecodesList |
	bytecodesList := BrSimpleList new.
	bytecodesList
		addEventHandler: GtInspectorListToSelectHandler new;
		stencil: [ :each :index |
			BlTextElement new
				text: (self formatBytecode: each);
				constraintsDo: [ :c | c horizontal matchParent ];
				padding: (BlInsets all: 5);
				when: BlClickEvent do: [ :anEvent  |
					anEvent consumed: true.
					bytecodesList selectOne: index ] ].
	^ bytecodesList
]

{ #category : #'accessing - elements' }
GtBytecodeDebugger >> bytecodesListElement [
	^ bytecodesListElement
]

{ #category : #'accessing - elements' }
GtBytecodeDebugger >> bytecodesPane [
	^ bytecodesPane
]

{ #category : #formatting }
GtBytecodeDebugger >> formatBytecode: aBytecode [
	| formattedCode |

	formattedCode := aBytecode printString asRopedText.
	formattedCode foreground: Smalltalk ui theme textColor.

	self selectedContext pc = aBytecode offset
		ifTrue: [ formattedCode italic ]. 

	self selectedContext pc > aBytecode offset
		ifTrue: [ formattedCode foreground: Color gray ].

	^ formattedCode
]

{ #category : #initialization }
GtBytecodeDebugger >> initializeBytecodeTransmissions [
	self bytecodesListElement
		when: BrSelectionChanged
		do: [ :anEvent | anEvent selectedDo: [ :anInterval |
			| anIndex anItemValue |
			anIndex := anInterval first.
			anItemValue := self bytecodesListElement items at: anIndex.
			self actOnSelectedBytecodeChangedFor: anItemValue ] ]
]

{ #category : #initialization }
GtBytecodeDebugger >> initializePanes [
	| secondPane |
	stackPane := self buildPaneElement.
	codePane := self buildPaneElement.
	bytecodesPane := self buildPaneElement.
	detailsPane := self buildPaneElement.
	
	secondPane := BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ].
	secondPane addChildren: {codePane. bytecodesPane}.
	
	self addChildren: {stackPane . secondPane . detailsPane}.
]

{ #category : #'updating panes' }
GtBytecodeDebugger >> updateBytecodePaneFor: aContext [
	| bytecodeToSelect |
	bytecodesListElement := self buildBytecodesListElement.

	self bytecodesPane
		removeChildren;
		addChild: bytecodesListElement.
	
	bytecodeToSelect := self session symbolicBytecodeForCurrentPCFrom: self currentContext.
	self bytecodesListElement display: aContext method symbolicBytecodes.
	self bytecodesListElement selectOne: (self bytecodesListElement items indexOf: bytecodeToSelect).
	self initializeBytecodeTransmissions.
	
]

{ #category : #accessing }
GtBytecodeDebugger >> variablesListForContext: aContext [
	^ aContext gtBytecodeDebuggerRetrieveContextValues
]

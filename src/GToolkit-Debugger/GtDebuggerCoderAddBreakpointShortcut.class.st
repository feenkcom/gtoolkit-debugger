Class {
	#name : #GtDebuggerCoderAddBreakpointShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GToolkit-Debugger-Breakpoints'
}

{ #category : #accessing }
GtDebuggerCoderAddBreakpointShortcut >> description [
	^ 'Add a breakpoint at the caret'
]

{ #category : #initialization }
GtDebuggerCoderAddBreakpointShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryY
]

{ #category : #accessing }
GtDebuggerCoderAddBreakpointShortcut >> name [
	^ 'Add breakpoint'
]

{ #category : #evaluation }
GtDebuggerCoderAddBreakpointShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	| node breakpoint |
	
	aSourceCoderViewModel cursors allCursors ifNotEmpty: 
			[:cursors |
			| position |
			position := cursors first position.
			node := aSourceCoderViewModel compiledMethod ast
						bestNodeForPosition: position].
						
	node hasBreakpoint ifTrue: [^self].
	node isMessage | node isVariable | node isLiteralNode ifFalse: [^self].
	
	breakpoint := Breakpoint new.
	breakpoint node: node.
	breakpoint once: true.
	breakpoint install.
	
	aSourceCoderViewModel coderModel requestStyleSourceText
]

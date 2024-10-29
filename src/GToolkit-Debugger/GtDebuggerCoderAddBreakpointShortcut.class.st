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
	aSourceCoderViewModel addBreakpointAtCursorLocation
]

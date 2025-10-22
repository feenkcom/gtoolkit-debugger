Class {
	#name : #GtDebuggerCoderAddSelfObjectBreakpointShortcut,
	#superclass : #GtDebuggerCoderAddBreakpointShortcut,
	#traits : 'TGtPhlowWithSelfObjectHolder',
	#classTraits : 'TGtPhlowWithSelfObjectHolder classTrait',
	#category : #'GToolkit-Debugger-Breakpoints'
}

{ #category : #accessing }
GtDebuggerCoderAddSelfObjectBreakpointShortcut >> description [
	^ 'Add a self object breakpoint at the caret'
]

{ #category : #initialization }
GtDebuggerCoderAddSelfObjectBreakpointShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryShiftY
]

{ #category : #accessing }
GtDebuggerCoderAddSelfObjectBreakpointShortcut >> name [
	^ 'Add object breakpoint'
]

{ #category : #evaluation }
GtDebuggerCoderAddSelfObjectBreakpointShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	aSourceCoderViewModel addBreakpointAtCursorLocationForSelfObjectHolder: self selfObjectHolder
]

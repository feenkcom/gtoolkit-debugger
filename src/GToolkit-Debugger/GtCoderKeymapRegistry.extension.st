Extension { #name : #GtCoderKeymapRegistry }

{ #category : #'*GToolkit-Debugger' }
GtCoderKeymapRegistry >> initializeDebuggerShortcutCombinations [
	<gtKeymapRegistration>
	self 
		initializeShortcut: GtCoderShortcutIds default addBreakpointShortcutId
		with: BlKeyCombination primaryY.
	self 
		initializeShortcut: GtCoderShortcutIds default addSelfObjectBreakpointShortcutId
		with: BlKeyCombination primaryShiftY
]

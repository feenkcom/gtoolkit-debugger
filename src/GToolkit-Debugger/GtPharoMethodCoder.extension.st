Extension { #name : #GtPharoMethodCoder }

{ #category : #'*GToolkit-Debugger' }
GtPharoMethodCoder >> addBreakpointAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtAstCoderAddOns: 9>
	
	coderAddOns addShortcut: GtDebuggerCoderAddBreakpointShortcut new.
	coderAddOns addStyler: GtDebuggerCoderBreakpointStyler new
]

{ #category : #'*GToolkit-Debugger' }
GtPharoMethodCoder >> addBreakpointContextMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns: 19>
	
	self
		addContextMenuItemFrom: GtDebuggerCoderAddBreakpointShortcut new
		withId: #'context-menu--breakpoint'
		to: coderAddOns
]

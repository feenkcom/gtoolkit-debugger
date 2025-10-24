Extension { #name : #GtPharoMethodCoder }

{ #category : #'*GToolkit-Debugger' }
GtPharoMethodCoder >> addBreakpointAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtAstCoderAddOns: 9>
	
	coderAddOns addShortcut: GtDebuggerCoderAddBreakpointShortcut new.
	aCoderViewModel
		ifSelfObject: [ :aSelfObject | 
			coderAddOns
				addShortcut: (GtDebuggerCoderAddSelfObjectBreakpointShortcut new
						selfObjectHolder: aCoderViewModel selfObjectHolder) ]
		ifNone: [  ].
	coderAddOns addStyler: GtDebuggerCoderBreakpointStyler new
]

{ #category : #'*GToolkit-Debugger' }
GtPharoMethodCoder >> addBreakpointContextMenuAddOnsAst: anAst to: coderAddOns from: aCoderViewModel [
	<gtCoderContextMenuAddOns>
	(self
		addContextMenuItemFrom: GtDebuggerCoderAddBreakpointShortcut new
		group: BrMenuItemGroupConfiguration evaluation
		withId: #'context-menu--breakpoint'
		to: coderAddOns) ifNotNil: [ :anAction | anAction priority: 900 ].

	aCoderViewModel
		ifSelfObject: [ :aSelfObject | 
			(self
				addContextMenuItemFrom: (GtDebuggerCoderAddSelfObjectBreakpointShortcut new
						selfObjectHolder: aCoderViewModel selfObjectHolder)
				group: BrMenuItemGroupConfiguration evaluation
				withId: #'context-menu--object-breakpoint'
				to: coderAddOns) ifNotNil: [ :anAction | anAction priority: 901 ] ]
		ifNone: [  ]
]

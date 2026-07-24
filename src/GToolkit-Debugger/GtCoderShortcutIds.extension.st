Extension { #name : #GtCoderShortcutIds }

{ #category : #'*GToolkit-Debugger' }
GtCoderShortcutIds >> addBreakpointShortcutId [
	^ self shortcutIdForIdentifier: #CoderAddBreakpoint
]

{ #category : #'*GToolkit-Debugger' }
GtCoderShortcutIds >> addSelfObjectBreakpointShortcutId [
	^ self shortcutIdForIdentifier: #CoderAddSelfObjectBreakpoint
]

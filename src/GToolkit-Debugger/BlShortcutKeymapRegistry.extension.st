Extension { #name : #BlShortcutKeymapRegistry }

{ #category : #'*GToolkit-Debugger' }
BlShortcutKeymapRegistry >> debugger [
	<gtKeymapRegistry>
	^ self ensureRegistryCategoryOfType: GtDebuggerKeymapRegistry
]

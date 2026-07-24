Extension { #name : #BlDynamicShortcut }

{ #category : #'*GToolkit-Debugger' }
BlDynamicShortcut >> debuggerShortcutId: anId [
	self 
		shortcutId: anId 
		inRegistry: BlShortcutKeymapRegistry default debugger
]

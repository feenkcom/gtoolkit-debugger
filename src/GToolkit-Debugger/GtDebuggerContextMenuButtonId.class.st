"
I identify the dropdown button that shows the actions targeting {{gtClass:GtDebuggerContextMenuTarget}} in a debugger toolbar.
"
Class {
	#name : #GtDebuggerContextMenuButtonId,
	#superclass : #BlElementUniqueId,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #converting }
GtDebuggerContextMenuButtonId >> asSymbol [
	^ #'debugger--context-menu'
]

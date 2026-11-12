"
I add a dropdown to the toolbar of Pharo debuggers. The dropdown shows the phlow actions of the debug session that target {{gtClass:GtDebuggerContextMenuTarget}}, using a {{gtClass:GtPhlowContext}} that includes the current debugger.
"
Class {
	#name : #GtDebuggerContextMenuDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #accessing }
GtDebuggerContextMenuDebugAction class >> defaultIcon [
	^ BrGlamorousVectorIcons hamburger
]

{ #category : #accessing }
GtDebuggerContextMenuDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	^ self forDebugger: aDebugger
]

{ #category : #accessing }
GtDebuggerContextMenuDebugAction >> asDebugActionElementWithHostElement: aHostElement do: aBlock [
	^ self createPhlowAction asElement: aBlock withHostElement: aHostElement
]

{ #category : #accessing }
GtDebuggerContextMenuDebugAction >> createPhlowAction [
	^ GtPhlowAction new dropdown
		id: GtDebuggerContextMenuButtonId;
		tooltip: self defaultLabel;
		icon: self defaultIcon;
		phlowActionsForObjects: self debugger debugSession debuggerContextMenuObjects
			inContext: (GtPhlowContext new currentDebugger: self debugger)
			fromTarget: GtDebuggerContextMenuTarget
]

{ #category : #accessing }
GtDebuggerContextMenuDebugAction >> defaultLabel [
	^ 'Debugger actions'
]

{ #category : #initialization }
GtDebuggerContextMenuDebugAction >> initialize [
	super initialize.

	self needsUpdate: false.
	self order: 1000
]

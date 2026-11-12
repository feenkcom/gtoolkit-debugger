"
I add a toggle to the toolbar of debuggers that support variable value overlays (see {{gtMethod:GtDebuggerElement>>#supportsVariableValueOverlays}}). The toggle shows or hides the values of variables in the method coders of the stack.

The initial state of the toggle is read from the debugger, so it stays in sync when the toolbar is rebuilt.
"
Class {
	#name : #GtVariableValueOverlaysDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #accessing }
GtVariableValueOverlaysDebugAction class >> defaultIcon [
	^ BrGlamorousVectorIcons edit
]

{ #category : #accessing }
GtVariableValueOverlaysDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	^ self forDebugger: aDebugger
]

{ #category : #accessing }
GtVariableValueOverlaysDebugAction >> appliesToDebugger: aDebugger [
	^ aDebugger supportsVariableValueOverlays
]

{ #category : #accessing }
GtVariableValueOverlaysDebugAction >> asDebugActionElementWithHostElement: aHostElement do: aBlock [
	^ self createPhlowAction asElement: aBlock withHostElement: aHostElement
]

{ #category : #accessing }
GtVariableValueOverlaysDebugAction >> createPhlowAction [
	^ GtPhlowAction new toggle
		tooltip: self defaultLabel;
		icon: self defaultIcon;
		isActivated: [ self debugger areVariableValueOverlaysEnabled ];
		activatedAction: [ self debugger enableVariableValueOverlays ];
		deactivatedAction: [ self debugger disableVariableValueOverlays ]
]

{ #category : #accessing }
GtVariableValueOverlaysDebugAction >> defaultLabel [
	^ 'Variable Value Overlays'
]

{ #category : #initialization }
GtVariableValueOverlaysDebugAction >> initialize [
	super initialize.

	self needsUpdate: false.	"After the stepping actions and before the context menu (see GtDebuggerContextMenuDebugAction>>#initialize)"
	self order: 900
]

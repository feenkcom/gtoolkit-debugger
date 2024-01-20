"
A StepOverDebugAction the current context.

"
Class {
	#name : #StepOverDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #registration }
StepOverDebugAction class >> actionType [
	<debuggingAction>
	<contextMenuDebuggingAction>
]

{ #category : #registration }
StepOverDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	<gt2StackDebuggingAction>
	^ (self forDebugger: aDebugger)
		icon: BrGlamorousIcons over;
		keymap: (BlKeyCombination builder
				key: BlKeyboardKey F10;
				build) 
]

{ #category : #accessing }
StepOverDebugAction >> defaultKeymap [

	^ PharoShortcuts current stepOverShortcut
]

{ #category : #accessing }
StepOverDebugAction >> defaultLabel [

	^ 'Step over'
]

{ #category : #accessing }
StepOverDebugAction >> defaultOrder [

	^ 20
]

{ #category : #actions }
StepOverDebugAction >> executeAction [

	self session stepOver: self currentContext
]

{ #category : #accessing }
StepOverDebugAction >> help [
	^ 'Step over the highlighted message, i.e. do not follow the sent message, taking debugger control after the method invoked returns.'
]

{ #category : #accessing }
StepOverDebugAction >> id [

	^ #stepOver
]

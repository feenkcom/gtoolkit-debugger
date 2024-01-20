"
A StepIntoDebugAction the current context.

"
Class {
	#name : #StepIntoDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #registration }
StepIntoDebugAction class >> actionType [
	<debuggingAction>
	<contextMenuDebuggingAction>
]

{ #category : #registration }
StepIntoDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	<gt2StackDebuggingAction>
	^ (self forDebugger: aDebugger)
		icon: BrGlamorousIcons into;
		keymap: ((BlKeyCombination builder
				key: BlKeyboardKey F11;
				build) or: BlKeyCombination builder primary alt arrowDown build)
]

{ #category : #accessing }
StepIntoDebugAction >> defaultKeymap [

	^ PharoShortcuts current stepIntoShortcut
]

{ #category : #accessing }
StepIntoDebugAction >> defaultLabel [

	^ 'Step into'
]

{ #category : #accessing }
StepIntoDebugAction >> defaultOrder [

	^ 15
]

{ #category : #actions }
StepIntoDebugAction >> executeAction [

	self session stepInto: self currentContext
]

{ #category : #accessing }
StepIntoDebugAction >> help [
	^ 'Step in the highlighted message, i.e. follow the sent message, taking debugger control in the method invoked.'
]

{ #category : #accessing }
StepIntoDebugAction >> id [

	^ #stepInto
]

"
A StepThroughDebugAction through the execution until control returns to the current method.

"
Class {
	#name : #StepThroughDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #registration }
StepThroughDebugAction class >> actionType [
	<debuggingAction>
	<contextMenuDebuggingAction>
]

{ #category : #registration }
StepThroughDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	^ (self forDebugger: aDebugger)
		icon: BrGlamorousIcons through;
		keymap: (BlKeyCombination builder
				key: BlKeyboardKey F12;
				build) gtDisplayString
]

{ #category : #registration }
StepThroughDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons through
]

{ #category : #accessing }
StepThroughDebugAction >> defaultKeymap [

	^ PharoShortcuts current stepThroughShortcut
]

{ #category : #accessing }
StepThroughDebugAction >> defaultLabel [

	^ 'Step through'
]

{ #category : #accessing }
StepThroughDebugAction >> defaultOrder [

	^ 25
]

{ #category : #actions }
StepThroughDebugAction >> executeAction [

	self session stepThrough: self currentContext
]

{ #category : #accessing }
StepThroughDebugAction >> help [
	^ 'Step over the highlighted message, i.e. do not follow the sent message, taking debugger control after the method invoked returns or whenever execution should return inside a block used as an argument before that.'
]

{ #category : #accessing }
StepThroughDebugAction >> id [

	^ #stepThrough
]

"
A RestartDebugAction restarts the execution of the current context.

"
Class {
	#name : #RestartDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #registration }
RestartDebugAction class >> actionType [
	<debuggingAction>
	<contextMenuDebuggingAction>
]

{ #category : #registration }
RestartDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
		<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousVectorIcons restart;
		keymap: (BlKeyCombination builder
				key: BlKeyboardKey F7;
				build) gtDisplayString
]

{ #category : #accessing }
RestartDebugAction >> defaultKeymap [

	^ PharoShortcuts current restartExecutionShortcut
]

{ #category : #accessing }
RestartDebugAction >> defaultLabel [

	^ 'Restart'
]

{ #category : #accessing }
RestartDebugAction >> defaultOrder [

	^ 10
]

{ #category : #actions }
RestartDebugAction >> executeAction [

	self session restart: self currentContext
]

{ #category : #accessing }
RestartDebugAction >> help [
	^ 'Go back the start of the current execution context, resetting all local variables and take debugger control.'
]

{ #category : #accessing }
RestartDebugAction >> id [

	^ #restart
]

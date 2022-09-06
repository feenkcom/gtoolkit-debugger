Extension { #name : #StepIntoDebugAction }

{ #category : #'*GToolkit-Debugger' }
StepIntoDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	^ (self forDebugger: aDebugger)
		icon: BrGlamorousIcons into;
		keymap: (BlKeyCombination builder
				key: BlKeyboardKey F11;
				build) userPrintString
]

{ #category : #'*GToolkit-Debugger' }
StepIntoDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons into
]

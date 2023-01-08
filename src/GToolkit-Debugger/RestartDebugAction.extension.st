Extension { #name : #RestartDebugAction }

{ #category : #'*GToolkit-Debugger' }
RestartDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons restart;
		keymap: (BlKeyCombination builder
				key: BlKeyboardKey F7;
				build) gtDisplayString
]

{ #category : #'*GToolkit-Debugger' }
RestartDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons restart
]

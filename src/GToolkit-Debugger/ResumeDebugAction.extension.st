Extension { #name : #ResumeDebugAction }

{ #category : #'*GToolkit-Debugger' }
ResumeDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons play;
		keymap: (BlKeyCombination builder
				key: BlKeyboardKey F5;
				build) userPrintString
]

{ #category : #'*GToolkit-Debugger' }
ResumeDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousVectorIcons play
]

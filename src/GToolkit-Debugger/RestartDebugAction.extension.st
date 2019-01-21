Extension { #name : #RestartDebugAction }

{ #category : #'*GToolkit-Debugger' }
RestartDebugAction class >> gt2ContetDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons restart
]

{ #category : #'*GToolkit-Debugger' }
RestartDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons restart
]

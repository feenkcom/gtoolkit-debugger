Extension { #name : #StepOverDebugAction }

{ #category : #'*GToolkit-Debugger' }
StepOverDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons over
]

{ #category : #'*GToolkit-Debugger' }
StepOverDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons over
]

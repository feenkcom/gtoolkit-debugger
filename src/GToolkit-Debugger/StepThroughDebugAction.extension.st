Extension { #name : 'StepThroughDebugAction' }

{ #category : '*GToolkit-Debugger' }
StepThroughDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons through
]

{ #category : '*GToolkit-Debugger' }
StepThroughDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons through
]

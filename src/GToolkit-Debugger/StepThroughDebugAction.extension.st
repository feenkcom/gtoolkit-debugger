Extension { #name : #StepThroughDebugAction }

{ #category : #'*GToolkit-Debugger' }
StepThroughDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons through
]

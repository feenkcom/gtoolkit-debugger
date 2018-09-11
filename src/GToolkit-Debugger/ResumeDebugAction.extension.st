Extension { #name : #ResumeDebugAction }

{ #category : #'*GToolkit-Debugger' }
ResumeDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousIcons play
]

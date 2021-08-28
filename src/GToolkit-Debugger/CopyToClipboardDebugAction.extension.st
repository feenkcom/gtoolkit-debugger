Extension { #name : 'CopyToClipboardDebugAction' }

{ #category : '*GToolkit-Debugger' }
CopyToClipboardDebugAction class >> gt2ActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			order: 35;
			icon: BrGlamorousIcons clipboard;
			label: 'Copy'
]

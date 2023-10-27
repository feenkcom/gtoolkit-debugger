Extension { #name : #TBlDevScripterTarget }

{ #category : #'*GToolkit-Debugger' }
TBlDevScripterTarget >> debuggerTarget [
	^ GtDebuggerDevScripterTarget forStep: self
]

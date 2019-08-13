Extension { #name : #MorphicUIManager }

{ #category : #'*GToolkit-Debugger' }
MorphicUIManager >> gtDebugProcess: process context: context withEmbeddedDebuggerIn: sourceCoder forException: exception [
	self debugProcess: process context: context label: exception description fullView: true
]

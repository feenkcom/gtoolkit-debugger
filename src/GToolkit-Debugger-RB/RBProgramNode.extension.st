Extension { #name : #RBProgramNode }

{ #category : #'*GToolkit-Debugger-RB' }
RBProgramNode >> gtDebugHighlightRange [
	^ self
		propertyAt: #debuggerSourceInterval
		ifAbsent: [ self gtDebugHighlightStart to: self gtDebugHighlightStop ]
]

{ #category : #'*GToolkit-Debugger-RB' }
RBProgramNode >> gtDebugHighlightStart [
	^ self
		propertyAt: #debuggerSourceInterval
		ifAbsent: [ self debugHighlightStart ]
]

{ #category : #'*GToolkit-Debugger-RB' }
RBProgramNode >> gtDebugHighlightStop [
	^ self
		propertyAt: #debuggerSourceInterval
		ifAbsent: [ self debugHighlightStop ]
]

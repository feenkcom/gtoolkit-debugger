Extension { #name : #RBAssignmentNode }

{ #category : #'*GToolkit-Debugger-RB' }
RBAssignmentNode >> gtDebugHighlightStart [
	^ self
		propertyAt: #debuggerSourceInterval
		ifPresent: [ :interval | interval first ]
		ifAbsent: [ self variable gtDebugHighlightStart ]
]

{ #category : #'*GToolkit-Debugger-RB' }
RBAssignmentNode >> gtDebugHighlightStop [
	^ self
		propertyAt: #debuggerSourceInterval
		ifPresent: [ :interval | interval last ]
		ifAbsent: [ self value gtDebugHighlightStop ]
]

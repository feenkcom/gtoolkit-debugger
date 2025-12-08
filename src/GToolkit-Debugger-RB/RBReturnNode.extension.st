Extension { #name : #RBReturnNode }

{ #category : #'*GToolkit-Debugger-RB' }
RBReturnNode >> gtDebugHighlightStop [
	^ self
		propertyAt: #debuggerSourceInterval
		ifPresent: [ :interval | interval last ]
		ifAbsent: [ self value gtDebugHighlightStop ]
]

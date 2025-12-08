Extension { #name : #RBMessageNode }

{ #category : #'*GToolkit-Debugger-RB' }
RBMessageNode >> gtDebugHighlightStop [
	^ self
		propertyAt: #debuggerSourceInterval
		ifPresent: [ :interval | interval last ]
		ifAbsent: [ self arguments notEmpty
				ifTrue: [ self arguments last gtDebugHighlightStop ]
				ifFalse: [ self debugHighlightStop ] ]
]

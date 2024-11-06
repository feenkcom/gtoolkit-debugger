Extension { #name : #CompiledCode }

{ #category : #'*GToolkit-Debugger' }
CompiledCode >> hasMethodOrBlockParameterNamed: aParameterName [
	^ self argumentNames includes: aParameterName
]

Extension { #name : #CompiledBlock }

{ #category : #'*GToolkit-Debugger' }
CompiledBlock >> hasMethodOrBlockParameterNamed: aParameterName [
	^ (super hasMethodOrBlockParameterNamed: aParameterName)
		ifTrue: [ true ]
		ifFalse: [
			self outerCode 
				ifNil: [ false ]
				ifNotNil: [ :aCompiledCode | 
					aCompiledCode hasMethodOrBlockParameterNamed: aParameterName ] ]
]

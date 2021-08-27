Extension { #name : 'Context' }

{ #category : '*GToolkit-Debugger' }
Context >> isContextDoesNotUnderstand [
	^ self selector == #doesNotUnderstand:
]

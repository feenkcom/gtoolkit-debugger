Class {
	#name : #GtCoderContextVariableButtonStyler,
	#superclass : #GtCoderContextVariableStyler,
	#category : #'GToolkit-Debugger'
}

{ #category : #accessing }
GtCoderContextVariableButtonStyler >> initializeVariables [
	super initializeVariables.
	variables at: 'self' put: methodCoder receiver.

]

{ #category : #accessing }
GtCoderContextVariableButtonStyler >> visitVariableNode: aVariableNode [
	variables
		at: aVariableNode name
		ifPresent: [ :value | 
			self
				styleFrom: aVariableNode start
				to: aVariableNode stop
				with:
					{(GtPlaygroundEvaluatedCodeButtonAttribute new
						beNotOverwritableByStyler;
						result: value;
						paint: (Color fromHexString: #'90CAF9'))} ].
	super visitVariableNode: aVariableNode
]

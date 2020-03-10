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
GtCoderContextVariableButtonStyler >> styleVariableNode: aVariableNode [
	self
		valueForVariableNamed: aVariableNode name
		ifPresent: [ :value | 
			self
				styleFrom: aVariableNode start
				to: aVariableNode stop
				with:
					{(GtPlaygroundEvaluatedCodeButtonAttribute new
						beNotOverwritableByStyler;
						result: value)} ]
]

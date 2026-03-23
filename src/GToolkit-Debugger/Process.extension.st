Extension { #name : #Process }

{ #category : #'*GToolkit-Debugger' }
Process >> newDebugSessionNamed: aString startedAt: aContext [

	^GtDebugSession named: aString on: self startedAt: aContext
]

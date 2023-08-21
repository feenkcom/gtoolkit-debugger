Extension { #name : #TBlDevScripterCheckStepCreation }

{ #category : #'*GToolkit-Debugger' }
TBlDevScripterCheckStepCreation >> debugger [
	"Builds a step to assert the state of the graphical scene"

	<scripterActionStep>
	^ GtDebuggerDevScripterCheckStep new parent: self
]

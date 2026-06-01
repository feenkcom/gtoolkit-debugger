Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-Debugger' }
TBlDevScripterActionStep >> debugger [
	"Builds a step to assert the state of the graphical scene"
	^ self
		addStep: (GtDebuggerDevScripterCheckStep new
				label: 'Debugger';
				referenceSender;
				onParentStepTarget: self)
]

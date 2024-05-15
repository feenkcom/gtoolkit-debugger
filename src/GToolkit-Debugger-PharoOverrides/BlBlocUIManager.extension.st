Extension { #name : #BlBlocUIManager }

{ #category : #'*GToolkit-Debugger-PharoOverrides' }
BlBlocUIManager >> handleDebugRequest: aDebugRequest [ 
	<debuggerCompleteToSender>

	OupsDebuggerSystem new gtOpenDebuggerOnRequest: aDebugRequest
]

{ #category : #'*GToolkit-Debugger-PharoOverrides' }
BlBlocUIManager >> handleDebugRequest: aDebugRequest fromDebuggerSystem: anOupsDebuggerSystem [
	<debuggerCompleteToSender>

	anOupsDebuggerSystem gtOpenDebuggerOnRequest: aDebugRequest
]

{ #category : #'*GToolkit-Debugger-PharoOverrides' }
BlBlocUIManager >> handleWarningDebugRequest: aDebugRequest [
	<debuggerCompleteToSender>
	
	OupsDebuggerSystem new gtOpenDebuggerOnRequest: aDebugRequest
]

{ #category : #'*GToolkit-Debugger-PharoOverrides' }
BlBlocUIManager >> handleWarningDebugRequest: aDebugRequest fromDebuggerSystem: anOupsDebuggerSystem [
	<debuggerCompleteToSender>
	
	anOupsDebuggerSystem gtOpenDebuggerOnRequest: aDebugRequest
]

Extension { #name : #BlBlocUIManager }

{ #category : #'*GToolkit-Debugger' }
BlBlocUIManager >> gtDebugProcess: process context: context withEmbeddedDebuggerIn: aCoderRequesterObject withSourceString: aSourceString withSourceInterval: aSourceInterval forException: exception evaluationInfo: anEvaluationInfo [
	"Open a dedicated debugger as a result of an error that happened when executing code 
	in an editor. The debugger can decide if and how to embed itself within the editor."

	self
		debugProcess: process
		context: context
		label: exception description
		exception: exception
		spawningDebuggingUsing: [ :debugSession | 
			GtCoderEmbeddedDebuggerElement
				openOn: debugSession
				dueTo: exception
				embeddedIn: aCoderRequesterObject
				withSourceString: aSourceString
				withSourceInterval: aSourceInterval
				evaluationInfo: anEvaluationInfo ]
]

Extension { #name : #BlBlocUIManager }

{ #category : #'*GToolkit-Debugger' }
BlBlocUIManager >> gtDebugProcess: process context: context withEmbeddedDebuggerIn: sourceCoder  withSelection: aSelection forException: exception [
	"Open a dedicated debugger as a result of an error that happened when executing code 
	in an editor. The debugger can decide if and how to embed itself within the editor."
	self 
		debugProcess: process 
		context: context 
		label: exception description
		spawningDebuggingUsing: [ :debugSession | 
			GtEmbeddedDebuggerElement   
				openOn: debugSession 
				dueTo: exception 
				embeddedIn: sourceCoder
				withSelection: aSelection ]
]

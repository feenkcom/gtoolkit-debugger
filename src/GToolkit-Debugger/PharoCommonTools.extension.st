Extension { #name : #PharoCommonTools }

{ #category : #'*GToolkit-Debugger' }
PharoCommonTools >> gtDebuggerTool: aTool [
	^ self register: aTool as: #debugger
]

{ #category : #'*GToolkit-Debugger' }
PharoCommonTools >> gtEmbeddableDebugger [
	^ self toolNamed: #gtEmbeddableDebugger
]

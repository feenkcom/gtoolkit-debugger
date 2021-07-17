Extension { #name : #PharoCommonTools }

{ #category : #'*GToolkit-Debugger' }
PharoCommonTools >> debuggerTool: aTool [
	^ self register: aTool as: #debugger
]

{ #category : #'*GToolkit-Debugger' }
PharoCommonTools >> gtEmbeddableDebugger [
	^ self toolNamed: #gtEmbeddableDebugger
]

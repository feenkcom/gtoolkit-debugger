Extension { #name : #BlBlocMorphicUIManager }

{ #category : #'*GToolkit-Debugger' }
BlBlocMorphicUIManager >> gtDebugProcess: process context: context withEmbeddedDebuggerIn: sourceCoder forException: exception [
	| debugSession isForBlocUIProcess |

	debugSession := process newDebugSessionNamed: exception description startedAt: context.
	debugSession logStackToFileIfNeeded.
	
	isForBlocUIProcess := self isForBlockUIProcess: debugSession.
	isForBlocUIProcess "Handle the case of the Bloc UI process"
		ifTrue: [ debugSession errorWasInUIProcess: true ].
	debugSession isAboutUIProcess ifTrue: [
		DefaultExecutionEnvironment beActiveDuring: [
			isForBlocUIProcess "Handle the case of the Bloc UI process"
				ifTrue:[ self spawnNewBlocProcess ]
				ifFalse: [ self spawnNewMorphicProcess ]
			] ].

	isForBlocUIProcess 
		ifTrue: [
			BlUniverse defer: [ 
				[ Smalltalk tools gtEmbeddableDebugger  
					openOn: debugSession dueTo: exception embeddedIn: sourceCoder
				] on: Error do: [ :ex | debugSession signalDebuggerError: ex ] ] ] 
		ifFalse: [ 
			self defer: [ 
				[ Smalltalk tools debugger 
					openOn: debugSession withFullView: false andNotification: nil.
				] on: Error do: [ :ex | 	debugSession signalDebuggerError: ex ] ] ].
	
	process suspend
]

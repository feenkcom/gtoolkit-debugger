Extension { #name : #BlBlocMorphicUIManager }

{ #category : #'*GToolkit-Debugger' }
BlBlocMorphicUIManager >> gtDebugProcess: process context: context withEmbeddedDebuggerIn: sourceCoder forException: exception [
	| debugSession isForBlocUIProcess aBlocUniverseIfAny |

	debugSession := process newDebugSessionNamed: exception description startedAt: context.
	debugSession logStackToFileIfNeeded.
	
	isForBlocUIProcess := false.
	aBlocUniverseIfAny := nil.
	
	self
		universeForSession: debugSession
		ifPresent: [ :aUniverse |
			isForBlocUIProcess := true.
			aBlocUniverseIfAny := aUniverse.
			debugSession errorWasInUIProcess: true ]
		ifAbsent: [].
	
	debugSession isAboutUIProcess ifTrue: [ 
		DefaultExecutionEnvironment beActiveDuring: [
		isForBlocUIProcess "Handle the case of the Bloc UI process"
			ifTrue:[ self spawnNewBlocProcess: aBlocUniverseIfAny ]
			ifFalse: [ self spawnNewMorphicProcess ] ] ].

	isForBlocUIProcess 
		ifTrue: [
			self blocDefer: [ 
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

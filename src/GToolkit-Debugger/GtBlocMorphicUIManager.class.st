Class {
	#name : #GtBlocMorphicUIManager,
	#superclass : #BlBlocMorphicUIManager,
	#category : #'GToolkit-Debugger'
}

{ #category : #'ui process' }
GtBlocMorphicUIManager >> defer: aBlock [
	"For now still defer through the morphic UI thread as the Bloc UI thread is not present if there are no bloc windows."
	super defer: aBlock
	"BlUniverse defer: aBlock"
]

{ #category : #debug }
GtBlocMorphicUIManager >> gtDebugProcess: process context: context withEmbeddedDebuggerIn: sourceCoder forException: exception [
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

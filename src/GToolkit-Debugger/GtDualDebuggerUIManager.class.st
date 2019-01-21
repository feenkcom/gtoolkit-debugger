Class {
	#name : #GtDualDebuggerUIManager,
	#superclass : #BlBlocMorphicUIManager,
	#category : #'GToolkit-Debugger'
}

{ #category : #debug }
GtDualDebuggerUIManager >> debugProcess: process context: context label: title fullView: bool notification: notificationString [
	"I open a debugger and add support for detecting also if the debugged process is the Bloc UI process.
	In that case I spawn another Bloc UI process instead of a Morphic one."

	| debugSession isForBlocUIProcess |

	debugSession := process newDebugSessionNamed: title startedAt: context.
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
				[ GtExpandableDebuggerElement openInspectorOn: debugSession ] 
					on: Error do: [ :ex | debugSession signalDebuggerError: ex ] ] ] 
		ifFalse: [ 
			self defer: [ 
				[ Smalltalk tools debugger 
					openOn: debugSession withFullView: bool andNotification: notificationString.
				] on: Error do: [ :ex | 	debugSession signalDebuggerError: ex ] ] ].
	
	process suspend
]

{ #category : #'ui process' }
GtDualDebuggerUIManager >> resumeUIProcess: aProcess [
	"Adopt aProcess as the project process -- probably because of proceeding from a debugger"
	
	"I explicitly check if the process corresponds to the Bloc UI process or not so I can determine which UI process to resume."
	aProcess name = BlUniverse default pulseLoop processId
		ifTrue:  [ 
			"Resume the Bloc UI process"
			self resumeBlocUIProcess: aProcess ]
		ifFalse: [ 
			"Resume the Moprhic UI process normally as before"
			self resumeMorphicUIProcess: aProcess ]
]

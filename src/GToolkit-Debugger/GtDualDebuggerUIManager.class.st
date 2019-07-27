"
I provide a solution to open a Bloc debugger on errors that happen in the Bloc UI process, and a Morphic debugger on errors that happen in the Morphic UI process.

My superclass on the other hand allways opens the same debugger on errors in both processes.
Because I use different debuggers for each UI process, I can resume both the Bloc and the Morphic UI process normally without any hacks.

I use ==Smalltalk tools debugger== to open a Morphic debugger and I hardcode the Bloc based debugger.

See the comment of my superclass for more details.
"
Class {
	#name : #GtDualDebuggerUIManager,
	#superclass : #BlBlocMorphicUIManager,
	#category : #'GToolkit-Debugger'
}

{ #category : #accessing }
GtDualDebuggerUIManager class >> isActiveManager [
	^ false
]

{ #category : #debug }
GtDualDebuggerUIManager >> debugProcess: process context: context label: title fullView: bool notification: notificationString [
	"I open a debugger and add support for detecting also if the debugged process is the Bloc UI process.
	In that case I spawn another Bloc UI process instead of a Morphic one."

	| debugSession isForBlocUIProcess |

	debugSession := process newDebugSessionNamed: title startedAt: context.
	debugSession logStackToFileIfNeeded.
	
	isForBlocUIProcess := self isForBlocUIProcess: debugSession.
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
GtDualDebuggerUIManager >> resumeBlocUIProcess: aProcess [
	"Adopt aProcess as the UI process for Bloc -- probably because of proceeding from a debugger"
			
	BlUniverse default pulseLoop forceStartOfUIProcess: aProcess.
]

{ #category : #'ui process' }
GtDualDebuggerUIManager >> resumeMorphicUIProcess: aProcess [
	"Adopt aProcess as the UI process for morphic -- probably because of proceeding from a debugger"
			
	UIProcess := aProcess.
	UIProcess resume
]

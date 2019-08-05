"
I provide a solution for handling the opening of a Bloc debugger in the Bloc UI process when errors happen in either the Bloc UI process and the Morphic UI Process.

I do the opposite as my superclass, which assumes a Morphic debugger is opened in the Morphic UI process. 

I should only be used with debuggers that run inside the Bloc UI process. I allways spawn  a Bloc debugger on errors that happen either in the Bloc UI process or the Morphic UI process. 
I know how to correctly resume the Morphic UI process even if the actual debugger runs in the Bloc UI process.

I use ==Smalltalk tools debugger== to open the actual debugger. For my preconditions to hold this needs to be a Bloc based debugger. 

See the comment of my superclass for more details.
"
Class {
	#name : #GtBlocMorphicUIManager,
	#superclass : #BlBlocMorphicUIManager,
	#category : #'GToolkit-Debugger'
}

{ #category : #'ui process' }
GtBlocMorphicUIManager >> defer: aBlock [
	| theUniversesWithUIProcess |
		
	theUniversesWithUIProcess := (BlParallelUniverse all select: [ :eachUniverse |
			eachUniverse hasSpaces
				and: [ eachUniverse hasUIProcess
					and: [ eachUniverse hostClass new isRunning ] ] ])
		sorted: [ :a :b | a hostClass priority < b hostClass priority ].

	theUniversesWithUIProcess
		ifEmpty: [ super defer: aBlock ]
		ifNotEmpty: [ :theUniverses | theUniverses first defer: aBlock ].

	"aGlutinUniverse := BlParallelUniverse forHost: Bloc preferableHostClass.
	aGlutinUniverse defer: aBlock"
]

{ #category : #events }
GtBlocMorphicUIManager >> onPrimitiveError: aString [ 
	| message |

	message := String
				streamContents: [:s | 
					| context |
					s nextPutAll: '*** System error handling failed ***'.
					s cr; nextPutAll: aString.
					context := thisContext sender sender.
					20
						timesRepeat: [context == nil
								ifFalse: [s cr; print: (context := context sender)]]].
	GtEmergencyDebugger askForEmergencyEvaluatorOrExitWithText: message.

]

{ #category : #'ui process' }
GtBlocMorphicUIManager >> resumeBlocUIProcess: aProcess [
	"Adopt aProcess as the UI process for Bloc -- probably because of proceeding from a debugger"
			
	"This UI manager resumes the Bloc UI proces normally. 
	It assumes the debugger was opened and runs in the Bloc UI process."
	
	self
		universeForProcess: aProcess
		ifPresent: [ :aUniverse | aUniverse hostClass forceResumeOfUIProcess: aProcess ]
		ifAbsent: [  ]
]

{ #category : #'ui process' }
GtBlocMorphicUIManager >> resumeMorphicUIProcess: aProcess [
	"The Morphic UI process needs to be handled in a special way. The current debugger only knows about the existance of a single UI process.
	Hence, on resume the debugger tries to terminate the active UI process using ==Processor terminateActive== (DebugSession>>#terminate).
	While that works for the Bloc UI process, it will not work for the Morphic UI process, as the debugger for the Morphic UI process runs inside the Bloc UI process.
	Instead I do all the work of closing and resuming the Morphic UI process"
	
	| currentDebugSession |
	
	"Terminate current UI process"
	UIProcess terminate.
	
	"Resume the given process as the current Morphic UI process"
	UIProcess := aProcess.
	UIProcess resume.
		
	"The this method in the supperclass for an explanation of this code."
	currentDebugSession := thisContext sender sender receiver. 
	currentDebugSession errorWasInUIProcess: false.
]

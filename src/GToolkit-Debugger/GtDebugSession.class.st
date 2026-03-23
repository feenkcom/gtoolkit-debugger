Class {
	#name : #GtDebugSession,
	#superclass : #DebugSession,
	#instVars : [
		'isUIProcessError'
	],
	#category : #'GToolkit-Debugger-Session'
}

{ #category : #'instance creation' }
GtDebugSession class >> named: aString on: aProcess startedAt: aContext [
	^ self new
		name: aString;
		process: aProcess context: aContext;
		detectUIProcess
]

{ #category : #initialization }
GtDebugSession >> detectUIProcess [

	self errorWasInUIProcess: (MorphicUIManager uiProcess == interruptedProcess)
]

{ #category : #accessing }
GtDebugSession >> errorWasInUIProcess [
	^ self 
			forPharo13AndNewer: [ isUIProcessError ] 
			forOlder: [ super errorWasInUIProcess]
]

{ #category : #initialization }
GtDebugSession >> errorWasInUIProcess: aBoolean [
	self 
		forPharo13AndNewer: [ isUIProcessError := true ] 
		forOlder: [super errorWasInUIProcess: aBoolean]
]

{ #category : #accessing }
GtDebugSession >> isAboutUIProcess [

	^self errorWasInUIProcess
]

{ #category : #private }
GtDebugSession >> resumeInterruptedProcess [

	self errorWasInUIProcess ifFalse: [ ^ super resumeInterruptedProcess ].
	MorphicUIManager default resumeUIProcess: interruptedProcess
]

{ #category : #process }
GtDebugSession >> spawnNewUIProcess [

	DefaultExecutionEnvironment beActiveDuring: [
		MorphicUIManager default spawnNewProcess ]
]

{ #category : #process }
GtDebugSession >> spawnNewUIProcessIfNecessary [
	"If we're about to debug the UI process, we must create a new UI process to take its place. Because the debugged process will be suspended at some point, and suspending the UI process means freezing the UI of the image"

	self errorWasInUIProcess ifTrue: [ self spawnNewUIProcess ]
]

{ #category : #'debugging actions' }
GtDebugSession >> terminate [

	self interruptedProcess ifNotNil: [ ^ super terminate ].
	
	"Assume the interrupted process was resumed." 
	"Kill the active process if the error was in the UI as there should be only one UI process."
	self errorWasInUIProcess ifTrue: [ Processor terminateActive ]
]

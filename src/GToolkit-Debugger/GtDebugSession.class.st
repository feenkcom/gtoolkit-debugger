Class {
	#name : #GtDebugSession,
	#superclass : #DebugSession,
	#instVars : [
		'isUIProcessError',
		'exceptionsHistory'
	],
	#classVars : [
		'ShouldForceStep'
	],
	#category : #'GToolkit-Debugger-Session'
}

{ #category : #accessing }
GtDebugSession class >> disableForceStepping [
	ShouldForceStep := false
]

{ #category : #accessing }
GtDebugSession class >> enableForceStepping [
	ShouldForceStep := true
]

{ #category : #'instance creation' }
GtDebugSession class >> named: aString on: aProcess startedAt: aContext [
	^ self new
		name: aString;
		process: aProcess context: aContext;
		detectUIProcess
]

{ #category : #accessing }
GtDebugSession class >> shouldForceStep [
	^ ShouldForceStep ifNil: [ true ]
]

{ #category : #'gt - actions' }
GtDebugSession >> debuggerContextMenuObjects [
	"Objects whose actions targeting GtDebuggerContextMenuTarget appear in the debugger's menu"

	^ self exception
		ifNil: [ {self} ]
		ifNotNil: [ :anException | 
			{self.
				anException} ]
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
		forPharo13AndNewer: [ isUIProcessError := aBoolean ] 
		forOlder: [super errorWasInUIProcess: aBoolean]
]

{ #category : #accessing }
GtDebugSession >> exception [
	^ self 
		forPharo13AndNewer: [
			"In Pharo 13 we do not use super as it does not return the expected exception"
			exception ] 
		forOlder: [super exception]
]

{ #category : #accessing }
GtDebugSession >> exception: anException [
	super exception: anException.
	
	anException ifNotNil: [ 
		exceptionsHistory add: anException ]
]

{ #category : #accessing }
GtDebugSession >> exceptionsHistory [
	"Exceptions the session had, oldest first. An exception is added when it is set and again when a debug action clears or replaces it"

	^ exceptionsHistory
]

{ #category : #'gt - actions' }
GtDebugSession >> gtActionInspectDebugSessionFor: anAction [
	<gtAction>
	^ anAction button
		priority: 20;
		target: GtDebuggerContextMenuTarget;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Inspect Debugging Session';
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | aButton phlow spawnObject: self ]
]

{ #category : #'gt - actions' }
GtDebugSession >> gtActionInspectExceptionFor: anAction [
	<gtAction>
	self exception ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 10;
		target: GtDebuggerContextMenuTarget;
		addTarget: GtPhlowObjectContextMenuTarget;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Inspect Exception';
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | 
			"Get the exception when the action is executed, as it can change while debugging"
			self exception
				ifNotNil: [ :anException | aButton phlow spawnObject: anException ] ]
]

{ #category : #'gt - actions' }
GtDebugSession >> gtActionInspectRecentExceptionFor: anAction [
	<gtAction>
	self recentException ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 15;
		target: GtDebuggerContextMenuTarget;
		addTarget: GtPhlowObjectContextMenuTarget;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Inspect Recent Exception';
		menuItemGroup: BrMenuItemGroupConfiguration navigation;
		action: [ :aButton | 
			self recentException
				ifNotNil: [ :anException | aButton phlow spawnObject: anException ] ]
]

{ #category : #initialization }
GtDebugSession >> initialize [
	super initialize.
	
	exceptionsHistory := OrderedCollection new.
]

{ #category : #accessing }
GtDebugSession >> isAboutUIProcess [

	^self errorWasInUIProcess
]

{ #category : #accessing }
GtDebugSession >> recentException [
	"Answer the most recent exception from the history that is not the current exception, or nil"

	| currentException |
	currentException := self exception.
	exceptionsHistory
		reverseDo: [ :each | each == currentException ifFalse: [ ^ each ] ].
	^ nil
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

{ #category : #initialization }
GtDebugSession >> updateContextTo: aContext [
	super updateContextTo: aContext.
	self updateDebugSessionExceptionFrom: aContext.
]

{ #category : #initialization }
GtDebugSession >> updateDebugSessionExceptionFrom: aContext [
	exception ifNotNil: [ :anException |
			exceptionsHistory add: anException ].
					
	aContext ifNil: [ 
		exception := nil. ^ self ].
	
	((aContext receiver isKindOf: Exception) 
		and: [ aContext selector = #signal ])
			ifTrue: [
				exception := aContext receiver ]
			ifFalse: [
				exception := nil ]
]

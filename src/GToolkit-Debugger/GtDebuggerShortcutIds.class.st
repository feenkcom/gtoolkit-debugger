"
I hold the shortcut identifiers for debugger-specific keyboard shortcuts (step over, step into, step through, resume, restart).
"
Class {
	#name : #GtDebuggerShortcutIds,
	#superclass : #BlShortcutIds,
	#instVars : [
		'stepOverShortcutId',
		'stepIntoShortcutId',
		'stepThroughShortcutId',
		'resumeShortcutId',
		'restartShortcutId'
	],
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #initialization }
GtDebuggerShortcutIds >> initialize [
	super initialize.
	
	stepOverShortcutId := BlShortcutId identifier: #DebuggerStepOver.
	stepIntoShortcutId := BlShortcutId identifier: #DebuggerStepInto.
	stepThroughShortcutId := BlShortcutId identifier: #DebuggerStepThrough.
	resumeShortcutId := BlShortcutId identifier: #DebuggerResume.
	restartShortcutId := BlShortcutId identifier: #DebuggerRestart
]

{ #category : #accessing }
GtDebuggerShortcutIds >> restartShortcutId [
	^ restartShortcutId
]

{ #category : #accessing }
GtDebuggerShortcutIds >> resumeShortcutId [
	^ resumeShortcutId
]

{ #category : #accessing }
GtDebuggerShortcutIds >> stepIntoShortcutId [
	^ stepIntoShortcutId
]

{ #category : #accessing }
GtDebuggerShortcutIds >> stepOverShortcutId [
	^ stepOverShortcutId
]

{ #category : #accessing }
GtDebuggerShortcutIds >> stepThroughShortcutId [
	^ stepThroughShortcutId
]

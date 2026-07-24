"
I am the keymap registry category for debugger shortcuts. I hold the default key combinations for debugger actions like step over, step into, step through, resume, and restart.
"
Class {
	#name : #GtDebuggerKeymapRegistry,
	#superclass : #BlShortcutKeymapRegistryCategory,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #accessing }
GtDebuggerKeymapRegistry class >> registryLabel [
	^ 'Debugger'
]

{ #category : #accessing }
GtDebuggerKeymapRegistry >> combinationForPlatformFor: aShortcutId [
	"Returns the platform-appropriate combination for the given shortcut id.
	This is a utility for places that need the combination directly."
	| entry |
	entry := self keymapFor: aShortcutId ifAbsent: [ ^ nil ].
	^ entry combinationForPlatform
]

{ #category : #defaults }
GtDebuggerKeymapRegistry >> defaultRestartShortcutCombination [
	^ BlKeyCombination builder
			key: BlKeyboardKey F7;
			build
]

{ #category : #defaults }
GtDebuggerKeymapRegistry >> defaultResumeShortcutCombination [
	^ BlKeyCombination builder
			key: BlKeyboardKey F5;
			build
]

{ #category : #defaults }
GtDebuggerKeymapRegistry >> defaultStepIntoShortcutCombination [
	^ BlKeyCombination builder
			key: BlKeyboardKey F11;
			build
]

{ #category : #defaults }
GtDebuggerKeymapRegistry >> defaultStepOverShortcutCombination [
	^ BlKeyCombination builder
			key: BlKeyboardKey F10;
			build
]

{ #category : #defaults }
GtDebuggerKeymapRegistry >> defaultStepThroughShortcutCombination [
	^ BlKeyCombination builder
			key: BlKeyboardKey F12;
			build
]

{ #category : #initialization }
GtDebuggerKeymapRegistry >> initializeBasicCombinations [
	super initializeBasicCombinations.
	
	self 
		initializeShortcut: GtDebuggerShortcutIds default stepOverShortcutId 
		with: self defaultStepOverShortcutCombination.
	self 
		initializeShortcut: GtDebuggerShortcutIds default stepIntoShortcutId 
		with: self defaultStepIntoShortcutCombination.
	self 
		initializeShortcut: GtDebuggerShortcutIds default stepThroughShortcutId 
		with: self defaultStepThroughShortcutCombination.
	self 
		initializeShortcut: GtDebuggerShortcutIds default resumeShortcutId 
		with: self defaultResumeShortcutCombination.
	self 
		initializeShortcut: GtDebuggerShortcutIds default restartShortcutId 
		with: self defaultRestartShortcutCombination
]

{ #category : #'accessing - combinations' }
GtDebuggerKeymapRegistry >> restartPlatformCombination [
	^ self combinationForPlatformFor: GtDebuggerShortcutIds default restartShortcutId
]

{ #category : #'accessing - combinations' }
GtDebuggerKeymapRegistry >> resumePlatformCombination [
	^ self combinationForPlatformFor: GtDebuggerShortcutIds default resumeShortcutId
]

{ #category : #'accessing - combinations' }
GtDebuggerKeymapRegistry >> stepIntoPlatformCombination [
	^ self combinationForPlatformFor: GtDebuggerShortcutIds default stepIntoShortcutId 
]

{ #category : #'accessing - combinations' }
GtDebuggerKeymapRegistry >> stepOverPlatformCombination [
	^ self combinationForPlatformFor: GtDebuggerShortcutIds default stepOverShortcutId 
]

{ #category : #'accessing - combinations' }
GtDebuggerKeymapRegistry >> stepThroughPlatformCombination [
	^ self combinationForPlatformFor: GtDebuggerShortcutIds default stepThroughShortcutId 
]

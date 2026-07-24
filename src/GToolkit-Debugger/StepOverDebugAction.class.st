"
A StepOverDebugAction the current context.

"
Class {
	#name : #StepOverDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #registration }
StepOverDebugAction class >> actionType [
	<debuggingAction>
	<contextMenuDebuggingAction>
]

{ #category : #registration }
StepOverDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	<gt2StackDebuggingAction>
	^(self forDebugger: aDebugger)
]

{ #category : #testing }
StepOverDebugAction >> canBeDirectlyRun [
	^ self debugger debugSession  isInterruptedContextSteppable
]

{ #category : #accessing }
StepOverDebugAction >> defaultIcon [

	^ BrGlamorousVectorIcons over
]

{ #category : #accessing }
StepOverDebugAction >> defaultKeymap [

	^ (BlShortcutKeymapRegistry default 
			debugger stepOverPlatformCombination) gtDisplayString
]

{ #category : #accessing }
StepOverDebugAction >> defaultLabel [

	^ 'Step over'
]

{ #category : #accessing }
StepOverDebugAction >> defaultOrder [

	^ 20
]

{ #category : #actions }
StepOverDebugAction >> executeAction [

	self session stepOver: self currentContext
]

{ #category : #accessing }
StepOverDebugAction >> help [
	^ 'Step over the highlighted message, i.e. do not follow the sent message, taking debugger control after the method invoked returns.'
]

{ #category : #accessing }
StepOverDebugAction >> id [

	^ #stepOver
]

{ #category : #testing }
StepOverDebugAction >> isAllowedToEnforceExecution [
	^ true
]

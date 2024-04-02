Class {
	#name : #GtStepOverOrIntoParameterBlocksDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-Experiments'
}

{ #category : #registration }
GtStepOverOrIntoParameterBlocksDebugAction class >> actionType [
	<debuggingAction>
	<contextMenuDebuggingAction>
]

{ #category : #registration }
GtStepOverOrIntoParameterBlocksDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	"<gt2ContextDebuggingAction>
	<gt2StackDebuggingAction>"
	
	^ (self forDebugger: aDebugger)
]

{ #category : #accessing }
GtStepOverOrIntoParameterBlocksDebugAction >> defaultKeymap [

	^ PharoShortcuts current stepThroughShortcut
]

{ #category : #accessing }
GtStepOverOrIntoParameterBlocksDebugAction >> defaultLabel [

	^ 'Step'
]

{ #category : #accessing }
GtStepOverOrIntoParameterBlocksDebugAction >> defaultOrder [

	^ 25
]

{ #category : #actions }
GtStepOverOrIntoParameterBlocksDebugAction >> executeAction [

	self session stepToHomeThroughException: self currentContext
]

{ #category : #accessing }
GtStepOverOrIntoParameterBlocksDebugAction >> help [
	^ 'Step over the highlighted message, i.e. do not follow the sent message, taking debugger control after the method invoked returns or whenever execution should return inside a block used as an argument before that.'
]

{ #category : #accessing }
GtStepOverOrIntoParameterBlocksDebugAction >> id [

	^ #stepThrough
]

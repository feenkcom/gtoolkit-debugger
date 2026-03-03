Class {
	#name : #GtLDebuggerChatDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #accessing }
GtLDebuggerChatDebugAction class >> defaultIcon [
	^BrGlamorousVectorIcons chat
]

{ #category : #accessing }
GtLDebuggerChatDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	^ (self forDebugger: aDebugger)
]

{ #category : #accessing }
GtLDebuggerChatDebugAction >> appliesToDebugger: aDebugger [
	^ GtLConnectionRegistry instance hasConnectableDefaultConnection
]

{ #category : #accessing }
GtLDebuggerChatDebugAction >> asDebugActionElementWithHostElement: aHostElement do: aBlock [
	^ self createPhlowAction 
		asElement: aBlock 
		withHostElement: aHostElement
]

{ #category : #accessing }
GtLDebuggerChatDebugAction >> createPhlowAction [
	^ GtPhlowAction  new dropdown
		icon: self defaultIcon;
		withDropdownIndicator;
		menu: [ :anActionElement :aTargetElement | 
				GtLDebuggerChatActionsTarget 
					menuItemsForObject: self debugger debugSession exception
					hostElement: aTargetElement ]
]

{ #category : #accessing }
GtLDebuggerChatDebugAction >> defaultLabel [
	^'Chat'
]

{ #category : #initialization }
GtLDebuggerChatDebugAction >> initialize [
	super initialize.

	self needsUpdate: false.
	self order: 200.
]

"
A CopyToClipboardDebugAction copies a short debugging stack to the clipboard.

"
Class {
	#name : #CopyToClipboardDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #registration }
CopyToClipboardDebugAction class >> actionType [
	<contextMenuDebuggingAction>
]

{ #category : #registration }
CopyToClipboardDebugAction class >> gt2ActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			order: 35;
			icon: BrGlamorousVectorIcons clipboard;
			label: 'Copy'
]

{ #category : #accessing }
CopyToClipboardDebugAction >> defaultLabel [

	^ 'Copy the stack to clipboard'
]

{ #category : #accessing }
CopyToClipboardDebugAction >> defaultOrder [

	^ 120
]

{ #category : #actions }
CopyToClipboardDebugAction >> executeAction [

	Clipboard clipboardText: (String streamContents: [ :s| 
		self debugger interruptedContext shortDebugStackOn: s ])
]

{ #category : #accessing }
CopyToClipboardDebugAction >> help [
	^ 'Copy a short debugging stack to the clipboard.'
]

{ #category : #accessing }
CopyToClipboardDebugAction >> id [

	^ #copyToClipboard
]

Class {
	#name : #GtRewriteRestartAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-RB'
}

{ #category : #registration }
GtRewriteRestartAction class >> gt2ContextDebuggingActionFor: aDebugger [
	^ (self forDebugger: aDebugger) icon: BrGlamorousVectorIcons restart
]

{ #category : #accessing }
GtRewriteRestartAction >> defaultLabel [
	^ 'Restart rewrite'
]

{ #category : #accessing }
GtRewriteRestartAction >> enabled [
	^ self session isValid
]

{ #category : #actions }
GtRewriteRestartAction >> executeAction [
	| context |
	context := self session foundMatchContext.
	context ifNil: [ ^ self ].
	self session process popTo: context.
	self session process restartTop.
	self session updateContextTo: context
]

{ #category : #accessing }
GtRewriteRestartAction >> help [
	^ 'Restart the rewrite'
]

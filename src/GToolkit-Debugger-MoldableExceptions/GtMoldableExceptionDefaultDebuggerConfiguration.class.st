Class {
	#name : #GtMoldableExceptionDefaultDebuggerConfiguration,
	#superclass : #GtMoldableExceptionDebuggerConfiguration,
	#instVars : [
		'receiverViewPragmaNames'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #accessing }
GtMoldableExceptionDefaultDebuggerConfiguration >> collectContextDebuggingViewsForReceiver: aReceiver forDebugger: aDebugger in: aComposite [
	^ (GtMoldableExceptionDebuggingViewsObjectTarget forObject: aReceiver) 
			collectTargetDebuggingViewsForPragmaNames: self receiverViewPragmaNames
			in: aComposite
			forDebugger: aDebugger
]

{ #category : #accessing }
GtMoldableExceptionDefaultDebuggerConfiguration >> receiverViewPragmaNames [
	^ receiverViewPragmaNames ifNil: [ #() ]
]

{ #category : #accessing }
GtMoldableExceptionDefaultDebuggerConfiguration >> receiverViewPragmaNames: aCollection [
	"Configure the list of pragmas used to look for debugging views specific to this exception in the receiver."
	receiverViewPragmaNames := aCollection
]

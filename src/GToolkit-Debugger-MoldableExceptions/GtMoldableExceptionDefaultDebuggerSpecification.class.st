Class {
	#name : #GtMoldableExceptionDefaultDebuggerSpecification,
	#superclass : #GtMoldableExceptionStandaloneDebuggerSpecification,
	#instVars : [
		'receiverViewPragmaNames'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #accessing }
GtMoldableExceptionDefaultDebuggerSpecification >> collectContextDebuggingViewsForReceiver: aReceiver forDebugger: aDebugger in: aComposite [
	^ (GtMoldableExceptionDebuggingViewsObjectTarget forObject: aReceiver) 
			collectTargetDebuggingViewsForPragmaNames: self receiverViewPragmaNames
			in: aComposite
			forDebugger: aDebugger
]

{ #category : #accessing }
GtMoldableExceptionDefaultDebuggerSpecification >> receiverViewPragmaNames [
	^ receiverViewPragmaNames ifNil: [ #() ]
]

{ #category : #accessing }
GtMoldableExceptionDefaultDebuggerSpecification >> receiverViewPragmaNames: aCollection [
	"Configure the list of pragmas used to look for debugging views specific to this exception in the receiver."
	receiverViewPragmaNames := aCollection
]

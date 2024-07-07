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
	self 
		collectSpecificPragmaContextDebuggingViewsForReceiver: aReceiver 
		forDebugger: aDebugger 
		in: aComposite.
	self 
		collectGenericPragmaContextDebuggingViewsForReceiver: aReceiver 
		forDebugger: aDebugger 
		in: aComposite
]

{ #category : #accessing }
GtMoldableExceptionDefaultDebuggerSpecification >> collectGenericPragmaContextDebuggingViewsForReceiver: aReceiver forDebugger: aDebugger in: aComposite [
	(GtMoldableExceptionDebuggingViewsObjectTarget forObject: aReceiver) 
		collectTargetDebuggingViewsForPragmaNames: {#gtContextView:}
		matchingArguments: [ :aPragma |
			self targetException class
				includesBehavior: aPragma arguments first asClass  ]
		in: aComposite
		forDebugger: aDebugger
]

{ #category : #accessing }
GtMoldableExceptionDefaultDebuggerSpecification >> collectSpecificPragmaContextDebuggingViewsForReceiver: aReceiver forDebugger: aDebugger in: aComposite [
	(GtMoldableExceptionDebuggingViewsObjectTarget forObject: aReceiver) 
		collectTargetDebuggingViewsForPragmaNames: self receiverViewPragmaNames
		in: aComposite
		forDebugger: aDebugger
]

{ #category : #accessing }
GtMoldableExceptionDefaultDebuggerSpecification >> defaultTargetObjectDebuggingActionPragmas [
	^ #(gtStackAction)
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

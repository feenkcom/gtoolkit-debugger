Class {
	#name : #GtDebuggerStackElementFirstNonFilteredContextPreloadSignal,
	#superclass : #GtDebuggerSignal,
	#instVars : [
		'promise'
	],
	#category : #'GToolkit-Debugger-Logging'
}

{ #category : #accessing }
GtDebuggerStackElementFirstNonFilteredContextPreloadSignal >> promise: aPromise [
	promise := aPromise
]

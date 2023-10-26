Class {
	#name : #GtDebuggerDevScripterTarget,
	#superclass : #BlDevScripterCustomTarget,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtDebuggerDevScripterTarget >> onPlayground [
	self scripterStep // GtDebuggerPlaygroundElement
]

{ #category : #accessing }
GtDebuggerDevScripterTarget >> onPlaygroundResizer [
	self onPlayground.
	self scripterStep / BrResizer 
]

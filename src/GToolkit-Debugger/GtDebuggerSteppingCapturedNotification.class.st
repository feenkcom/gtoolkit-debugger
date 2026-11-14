"
I am a notification that opens a debugger when nobody handles me, like test failures in frameworks that model failures as notifications.
I answer true to captureIfSignalledWhenStepping, so stepping over a send that signals me stops at the signal instead of running my default action inside the stepping simulation.
See {{gtClass:GtDebuggerStepOverSignalExamples}}.
"
Class {
	#name : #GtDebuggerSteppingCapturedNotification,
	#superclass : #Notification,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #testing }
GtDebuggerSteppingCapturedNotification class >> captureIfSignalledWhenStepping [
	^self == GtDebuggerSteppingCapturedNotification
]

{ #category : #'priv handling' }
GtDebuggerSteppingCapturedNotification >> defaultAction [
	^self raiseUnhandledError
]

Class {
	#name : #GtSharedDebugSessionDebuggedAnnouncement,
	#superclass : #GtSharedDebugSessionAnnouncement,
	#instVars : [
		'debugger'
	],
	#category : #'GToolkit-Debugger-Session'
}

{ #category : #accessing }
GtSharedDebugSessionDebuggedAnnouncement >> debugger [
	^ debugger
]

{ #category : #accessing }
GtSharedDebugSessionDebuggedAnnouncement >> debugger: anObject [
	debugger := anObject
]

Class {
	#name : 'GtSharedDebugSessionAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'session'
	],
	#category : 'GToolkit-Debugger-Session'
}

{ #category : 'api - accessing' }
GtSharedDebugSessionAnnouncement >> session [
	<return: #GtSharedDebugSession>
	^ session
]

{ #category : 'api - accessing' }
GtSharedDebugSessionAnnouncement >> session: aSession [
	session := aSession
]

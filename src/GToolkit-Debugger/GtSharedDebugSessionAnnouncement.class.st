Class {
	#name : #GtSharedDebugSessionAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'session',
		'releasedSession'
	],
	#category : #'GToolkit-Debugger-Session'
}

{ #category : #accessing }
GtSharedDebugSessionAnnouncement >> releasedSession [
	^ releasedSession
]

{ #category : #accessing }
GtSharedDebugSessionAnnouncement >> releasedSession: anObject [
	releasedSession := anObject
]

{ #category : #'api - accessing' }
GtSharedDebugSessionAnnouncement >> session [
	<return: #GtSharedDebugSession>
	^ session
]

{ #category : #'api - accessing' }
GtSharedDebugSessionAnnouncement >> session: aSession [
	session := aSession
]

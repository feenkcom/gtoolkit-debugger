Class {
	#name : 'GtAnnouncingDebugSession',
	#superclass : 'Object',
	#traits : 'TBlDebug + TGtAnnouncer',
	#classTraits : 'TBlDebug classTrait + TGtAnnouncer classTrait',
	#instVars : [
		'announcer'
	],
	#category : 'GToolkit-Debugger-Session'
}

{ #category : 'announcer' }
GtAnnouncingDebugSession >> announcer [
	<return: #Announcer>
	^ announcer
]

{ #category : 'gt-extensions' }
GtAnnouncingDebugSession >> gtSubscriptionsFor: aView [
	<gtView>
	self announcer ifNil: [ ^ aView empty ].
	^ (self announcer gtSubscriptionsFor: aView)
		priority: 42
]

{ #category : 'initialization' }
GtAnnouncingDebugSession >> initialize [
	super initialize.
	announcer := Announcer new.
]

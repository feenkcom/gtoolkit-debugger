Class {
	#name : #GtBeaconMethodSignal,
	#superclass : #BeaconSignal,
	#instVars : [
		'methodSelector',
		'methodClassName',
		'currentProcessId',
		'glutinUIProcessId',
		'label'
	],
	#category : #'GToolkit-Debugger-Logging'
}

{ #category : #'instance creation' }
GtBeaconMethodSignal class >> createForMethod: aMethod labeled: aString [
	^ self new 
		label: aString;
		methodClassName: aMethod methodClass name;
		methodSelector: aMethod selector
]

{ #category : #logging }
GtBeaconMethodSignal class >> emitForMethod: aMethod [
	^ self 
		emitForMethod: aMethod 
		labeled: nil
]

{ #category : #logging }
GtBeaconMethodSignal class >> emitForMethod: aMethod labeled: aString [
	^ (self createForMethod: aMethod labeled: aString) emit
]

{ #category : #accessing }
GtBeaconMethodSignal >> currentProcessId [
	^ currentProcessId
]

{ #category : #accessing }
GtBeaconMethodSignal >> currentProcessId: anInteger [
	currentProcessId := anInteger
]

{ #category : #'as yet unclassified' }
GtBeaconMethodSignal >> gtViewMethodSourceFor: aView [
	<gtView>
	| aMethodClassName methodClass |
	aMethodClassName := (self methodClassName endsWith: ' class')
		ifTrue: [ self methodClassName removeSuffix: ' class' ]
		ifFalse: [ self methodClassName ].
	
	methodClass := aMethodClassName asClassIfAbsent: [ 
		^ aView empty ].
	(self methodClassName endsWith: ' class')
		ifTrue: [ methodClass := methodClass classSide ].
	^ (methodClass >> self methodSelector) gtSourceFor: aView
]

{ #category : #initialization }
GtBeaconMethodSignal >> initialize [
	super initialize.
	currentProcessId := Processor activeProcess identityHash.
	BlGlutinHost uiProcessDo: [ :process | glutinUIProcessId := process identityHash ].
	
	
]

{ #category : #accessing }
GtBeaconMethodSignal >> label [
	^ label
]

{ #category : #accessing }
GtBeaconMethodSignal >> label: aString [
	label := aString
]

{ #category : #accessing }
GtBeaconMethodSignal >> methodClassName [
	^ methodClassName
]

{ #category : #accessing }
GtBeaconMethodSignal >> methodClassName: aString [
	methodClassName := aString
]

{ #category : #accessing }
GtBeaconMethodSignal >> methodSelector [
	^ methodSelector
]

{ #category : #accessing }
GtBeaconMethodSignal >> methodSelector: aSelector [
	methodSelector := aSelector
]

{ #category : #printing }
GtBeaconMethodSignal >> printOneLineContentsOn: stream [
	stream 
		nextPutAll: self methodClassName;
		nextPutAll: '>>#';
		nextPutAll: self methodSelector
]

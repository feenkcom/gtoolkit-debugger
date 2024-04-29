Class {
	#name : #GtMoldableExceptionTransformationsSettings,
	#superclass : #Object,
	#instVars : [
		'disabledExceptions',
		'areAutomaticTransformationsAllowed'
	],
	#classInstVars : [
		'defaultInstance'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #cleanup }
GtMoldableExceptionTransformationsSettings class >> cleanUp [
	self cleanUpDefaultInstance
]

{ #category : #cleanup }
GtMoldableExceptionTransformationsSettings class >> cleanUpDefaultInstance [
	defaultInstance := nil.
]

{ #category : #accessing }
GtMoldableExceptionTransformationsSettings class >> defaultInstance [
	^ defaultInstance ifNil: [
		defaultInstance := self new ]
]

{ #category : #'gt - extensions' }
GtMoldableExceptionTransformationsSettings class >> gtViewDefaultMoldableExceptionsWithTransformationsFor: aView [
	<gtView>
	<gtClassView>
	
	^ aView forward 
		title: 'Exceptions (with transformation)';
		priority: 15;
		object: [ self defaultInstance ];
		view: #gtViewMoldableExceptionsWithTransformationsFor:;
		actionButtonIcon: BrGlamorousVectorIcons inspect
			tooltip: 'Inspect default settings'
			action: [ :aButton |
				aButton phlow spawnObject: self defaultInstance ]
]

{ #category : #configuration }
GtMoldableExceptionTransformationsSettings >> allowAutomaticTransformationForException: anException [
	disabledExceptions 
		remove: anException class name
		ifAbsent: []
]

{ #category : #configuration }
GtMoldableExceptionTransformationsSettings >> allowAutomaticTransformations [
	areAutomaticTransformationsAllowed := true
]

{ #category : #testing }
GtMoldableExceptionTransformationsSettings >> areTransformationsAllowed [
	^ areAutomaticTransformationsAllowed ifNil: [ false ] 
]

{ #category : #testing }
GtMoldableExceptionTransformationsSettings >> canApplyAutomaticTransformationForException: anException [
	^ self areTransformationsAllowed and: [
		(disabledExceptions includes: anException class name) not ]
]

{ #category : #configuration }
GtMoldableExceptionTransformationsSettings >> disableAutomaticTransformationForException: anException [
	^ disabledExceptions add: anException class name
]

{ #category : #configuration }
GtMoldableExceptionTransformationsSettings >> disableAutomaticTransformations [
	areAutomaticTransformationsAllowed := false
]

{ #category : #'gt - extensions' }
GtMoldableExceptionTransformationsSettings >> gtViewDisabledExceptionsFor: aView [
	<gtView>
	
	^ aView list 
		title: 'Disabled Exceptions';
		priority: 10;
		items: [ disabledExceptions asOrderedCollection ]
]

{ #category : #'gt - extensions' }
GtMoldableExceptionTransformationsSettings >> gtViewMoldableExceptionsWithTransformationsFor: aView [
	<gtView>
	
	^ aView columnedList 
		title: 'Exceptions (with transformation)';
		priority: 5;
		items: [ 
			TGtMoldableExceptionSignalWithTransformation users asOrderedCollection ];
		column: 'Exception' text: [ :anExceptionClass | anExceptionClass name ];
		column: 'Automatic Transformation Allowed' text: [ :anExceptionClass | 
			self canApplyAutomaticTransformationForException: anExceptionClass name ];
		column: 'Is Disabled' text: [ :anExceptionClass | 
			disabledExceptions includes: anExceptionClass name ];
		actionButtonIcon: (self areTransformationsAllowed
				ifTrue: [ BrGlamorousVectorIcons cancel ]
				ifFalse: [ BrGlamorousVectorIcons accept ])
			tooltip: (self areTransformationsAllowed
				ifTrue: [ 'Disable automatic transformations' ]
				ifFalse: [ 'Allow automatic transformations' ])
			action: [ :aButton |
				self toggleAutomaticTransformationStatus.
				aButton phlow fireToolUpdateWish ]
]

{ #category : #initialization }
GtMoldableExceptionTransformationsSettings >> initialize [
	super initialize.
	
	self disableAutomaticTransformations.
	disabledExceptions := Set new.
]

{ #category : #configuration }
GtMoldableExceptionTransformationsSettings >> toggleAutomaticTransformationStatus [
	areAutomaticTransformationsAllowed := self areTransformationsAllowed not
]

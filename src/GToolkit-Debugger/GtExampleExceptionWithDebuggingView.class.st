Class {
	#name : #GtExampleExceptionWithDebuggingView,
	#superclass : #Exception,
	#instVars : [
		'customData'
	],
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtExampleExceptionWithDebuggingView >> customData [
	^ customData
]

{ #category : #accessing }
GtExampleExceptionWithDebuggingView >> customData: anObject [
	customData := anObject
]

{ #category : #'gt-extensions' }
GtExampleExceptionWithDebuggingView >> gtViewCustomDataFor: aView [
	<gtView> 
	<gtExceptionDebuggingView>
	
	^ aView forward 
		title: 'Custom Data';
		object: [ customData ];
		priority: 1;
		view: #gtItemsFor:
]

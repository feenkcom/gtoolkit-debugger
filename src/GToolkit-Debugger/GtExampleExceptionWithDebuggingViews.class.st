Class {
	#name : #GtExampleExceptionWithDebuggingViews,
	#superclass : #Exception,
	#instVars : [
		'customData'
	],
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtExampleExceptionWithDebuggingViews >> customData [
	^ customData
]

{ #category : #accessing }
GtExampleExceptionWithDebuggingViews >> customData: anObject [
	customData := anObject
]

{ #category : #'gt-extensions' }
GtExampleExceptionWithDebuggingViews >> gtViewCustomDataFor: aView [
	<gtView> 
	<gtExceptionDebuggingView>
	
	^ aView forward 
		title: 'Custom Data';
		object: [ customData ];
		priority: 1;
		view: #gtItemsFor:
]

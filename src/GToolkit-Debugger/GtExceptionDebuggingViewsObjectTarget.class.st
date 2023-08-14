Class {
	#name : #GtExceptionDebuggingViewsObjectTarget,
	#superclass : #Object,
	#instVars : [
		'targetObject'
	],
	#category : #'GToolkit-Debugger-Models'
}

{ #category : #'instance creation' }
GtExceptionDebuggingViewsObjectTarget class >> forObject: anObject [
	^ self new
		 targetObject: anObject
]

{ #category : #configuration }
GtExceptionDebuggingViewsObjectTarget >> configureDebuggingViewsCollector: aViewsCollector [
	^ aViewsCollector 
		fromObject: self targetObject
]

{ #category : #testing }
GtExceptionDebuggingViewsObjectTarget >> hasDebuggingViewMethodsWithPragmaNames: aCollectionOfPragmaNames [
	^ (GtPhlowCollector new
		fromObject: self targetObject;
		pragmaNames: aCollectionOfPragmaNames;
		collectAllPragmas) size > 0
]

{ #category : #accessing }
GtExceptionDebuggingViewsObjectTarget >> targetObject [
	^ targetObject
]

{ #category : #accessing }
GtExceptionDebuggingViewsObjectTarget >> targetObject: anObject [ 
	targetObject := anObject 
]

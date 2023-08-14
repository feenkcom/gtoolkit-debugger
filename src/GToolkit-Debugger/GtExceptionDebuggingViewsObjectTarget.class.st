"
{{gtClass:GtExceptionDebuggingViewsObjectTarget}} models an object that is the source of debugging views and actions for a domain-specific debugger associated with an exception.

The two main API methods provided by this object are:
	- {{gtMethod:GtExceptionDebuggingViewsObjectTarget>>hasDebuggingViewMethodsWithPragmaNames:|label=#selector}}  uses a {{gtClass:GtPhlowCollector}} to determine if debugging views are attached to the target object
	- {{gtMethod:GtExceptionDebuggingViewsObjectTarget>>configureDebuggingViewsCollector:|label=#selector}} configures a {{gtClass:GtPhlowCollector}} with the target object



"
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

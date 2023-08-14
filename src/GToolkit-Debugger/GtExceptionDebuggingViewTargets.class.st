"
{{gtClass:GtExceptionDebuggingViewTargets}} models all the target objects where the domain-specific debugger associated with an exception looks for debugging views. 

This is a composite target, containing a list of invidual target objects that are instances of {{gtClass:GtExceptionDebuggingViewsObjectTarget}}. This allows debugging views and actions to be defined either in the exception objects, or in a list of related objects that the exception configures.
The main API methods for doing the configuration are:
	- {{gtMethod:GtExceptionDebuggingViewTargets>>withDebuggingExceptionTargetFor:|label=#selector}}
	- {{gtMethod:GtExceptionDebuggingViewTargets>>withoutDebuggingExceptionTarget|label=#selector}}
	- {{gtMethod:GtExceptionDebuggingViewTargets>>addDebuggingTargetFor:|label=#selector}}

It is possible to just configure the exception, or a one or more objects, or both the exception and a list of objects as the target for debugging views and actions.
"
Class {
	#name : #GtExceptionDebuggingViewTargets,
	#superclass : #Object,
	#instVars : [
		'exceptionTarget',
		'objectTargets'
	],
	#category : #'GToolkit-Debugger-Models'
}

{ #category : #configuration }
GtExceptionDebuggingViewTargets >> addDebuggingTargetFor: anObject [
	"Adds the given object as a target for views and actions"

	objectTargets add: (GtExceptionDebuggingViewsObjectTarget forObject: anObject)
]

{ #category : #accessing }
GtExceptionDebuggingViewTargets >> collectTargetDebuggingViewsForPragmaNames: aCollectionOfPragmaNames [
	| compositeView |
	compositeView := GtPhlowView empty composite 
		title: 'Views'.
	self withIndividualTargetsDo: [ :aTarget |
		compositeView collectorAppend: [ :aCollector |
			aCollector pragmaNames: aCollectionOfPragmaNames.
			aTarget configureDebuggingViewsCollector: aCollector ] ].
	^ compositeView
]

{ #category : #testing }
GtExceptionDebuggingViewTargets >> hasDebuggingViewMethodsWithPragmaNames: aCollectionOfPragmaNames [
	| hasPragmas |
	hasPragmas := objectTargets anySatisfy: [ :aTarget |
		aTarget hasDebuggingViewMethodsWithPragmaNames: aCollectionOfPragmaNames ].
	^ exceptionTarget
		ifNil: [ hasPragmas ]
		ifNotNil: [ 
			hasPragmas or: [ 
				(exceptionTarget hasDebuggingViewMethodsWithPragmaNames: aCollectionOfPragmaNames) ] ].
]

{ #category : #initialization }
GtExceptionDebuggingViewTargets >> initialize [
	super initialize.
	
	objectTargets := OrderedCollection new.
]

{ #category : #configuration }
GtExceptionDebuggingViewTargets >> withDebuggingExceptionTargetFor: anException [
	"Configures the given exception as a target for views and actions"
	exceptionTarget := GtExceptionDebuggingViewsObjectTarget forObject: anException
]

{ #category : #traversing }
GtExceptionDebuggingViewTargets >> withIndividualTargetsDo: aBlock [ 
	exceptionTarget ifNotNil: [ :aTarget | 
		aBlock value: aTarget ].
	objectTargets do: [ :aTarget | 
		aBlock value: aTarget  ]
]

{ #category : #configuration }
GtExceptionDebuggingViewTargets >> withoutDebuggingExceptionTarget [
	"Indicate the current exception should not be used as a target for views and actions"
	exceptionTarget := nil
]

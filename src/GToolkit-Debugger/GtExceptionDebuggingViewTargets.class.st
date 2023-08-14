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
	exceptionTarget := nil
]

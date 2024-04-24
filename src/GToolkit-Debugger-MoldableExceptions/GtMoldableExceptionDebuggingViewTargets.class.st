"
{{gtClass:GtMoldableExceptionDebuggingViewTargets}} models all the target objects where the domain-specific debugger associated with an exception looks for debugging views. 

This is a composite target, containing a list of invidual target objects that are instances of {{gtClass:GtMoldableExceptionDebuggingViewsObjectTarget}}. This allows debugging views and actions to be defined either in the exception objects, or in a list of related objects that the exception configures.
The main API methods for doing the configuration are:
	- {{gtMethod:GtMoldableExceptionDebuggingViewTargets>>withDebuggingExceptionTargetFor:|label=#selector}}
	- {{gtMethod:GtMoldableExceptionDebuggingViewTargets>>withoutDebuggingExceptionTarget|label=#selector}}
	- {{gtMethod:GtMoldableExceptionDebuggingViewTargets>>addDebuggingTargetFor:|label=#selector}}

It is possible to just configure the exception, or a one or more objects, or both the exception and a list of objects as the target for debugging views and actions.
"
Class {
	#name : #GtMoldableExceptionDebuggingViewTargets,
	#superclass : #Object,
	#instVars : [
		'exceptionTarget',
		'objectTargets'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #configuration }
GtMoldableExceptionDebuggingViewTargets >> addDebuggingTargetFor: anObject [
	"Adds the given object as a target for views and actions"

	objectTargets add: (GtMoldableExceptionDebuggingViewsObjectTarget forObject: anObject)
]

{ #category : #accessing }
GtMoldableExceptionDebuggingViewTargets >> collectTargetDebuggingActionsForPragmaNames: aCollectionOfPragmaNames forDebugger: aDebuggerElement [

	| debuggingActions  |
	
	debuggingActions := OrderedCollection new.
	self withIndividualTargetsDo: [ :aTarget |
		debuggingActions addAll: (aTarget 
			collectTargetDebuggingActionsForPragmaNames: aCollectionOfPragmaNames 
			forDebugger: aDebuggerElement) ].
			
	^ debuggingActions
]

{ #category : #accessing }
GtMoldableExceptionDebuggingViewTargets >> collectTargetDebuggingViewsForPragmaNames: aCollectionOfPragmaNames in: aComposite forDebugger: aDebuggerElement [
		
	self withIndividualTargetsDo: [ :aTarget |
		aTarget
			collectTargetDebuggingViewsForPragmaNames: aCollectionOfPragmaNames 
			in: aComposite 
			forDebugger: aDebuggerElement ] 
]

{ #category : #testing }
GtMoldableExceptionDebuggingViewTargets >> hasDebuggingViewMethodsWithPragmaNames: aCollectionOfPragmaNames [
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
GtMoldableExceptionDebuggingViewTargets >> initialize [
	super initialize.
	
	objectTargets := OrderedCollection new.
]

{ #category : #configuration }
GtMoldableExceptionDebuggingViewTargets >> withDebuggingExceptionTargetFor: anException [
	"Configures the given exception as a target for views and actions"
	exceptionTarget := GtMoldableExceptionDebuggingViewsObjectTarget forObject: anException
]

{ #category : #traversing }
GtMoldableExceptionDebuggingViewTargets >> withIndividualTargetsDo: aBlock [ 
	exceptionTarget ifNotNil: [ :aTarget | 
		aBlock value: aTarget ].
	objectTargets do: [ :aTarget | 
		aBlock value: aTarget  ]
]

{ #category : #configuration }
GtMoldableExceptionDebuggingViewTargets >> withoutDebuggingExceptionTarget [
	"Indicate the current exception should not be used as a target for views and actions"
	exceptionTarget := nil
]

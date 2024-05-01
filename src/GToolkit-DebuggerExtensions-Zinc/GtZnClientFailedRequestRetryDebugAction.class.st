Class {
	#name : #GtZnClientFailedRequestRetryDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-DebuggerExtensions-Zinc'
}

{ #category : #accessing }
GtZnClientFailedRequestRetryDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	^ self forDebugger: aDebugger
]

{ #category : #testing }
GtZnClientFailedRequestRetryDebugAction >> appliesToDebugger: aDebugger [
	aDebugger session isInterruptedContextPostMortem ifTrue: [ ^ false ].
	
	(aDebugger session exception  isNil or: [
		(ZnClient new retryExceptionSet 
			handles: aDebugger debugSession exception)])
				ifFalse: [ ^ false ].
		
	^ aDebugger session
		hasLimitedFullActiveContextForMethod: ZnClient>>#execute
]

{ #category : #accessing }
GtZnClientFailedRequestRetryDebugAction >> asDebugActionElementWithHostElement: aHostElement do: aBlock [
	^ self createPhlowAction 
		asElement: aBlock 
		withHostElement: aHostElement
]

{ #category : #accessing }
GtZnClientFailedRequestRetryDebugAction >> createPhlowAction [
	^ self 
		gtActionRetryWithIncreasingRetriesFor: GtPhlowAction noAction 
		inContext:(GtPhlowContext new 
			currentDebugger: self debugger)
]

{ #category : #accessing }
GtZnClientFailedRequestRetryDebugAction >> defaultIcon [
	^  BrGlamorousVectorIcons refresh
]

{ #category : #accessing }
GtZnClientFailedRequestRetryDebugAction >> defaultLabel [
	^ 'Retry'
]

{ #category : #accessing }
GtZnClientFailedRequestRetryDebugAction >> defaultOrder [
	^ 50
]

{ #category : #accessing }
GtZnClientFailedRequestRetryDebugAction >> executeAction [
	self session restartInterruptedContext.
	self debugger resumeAndCloseDebugger.
]

{ #category : #accessing }
GtZnClientFailedRequestRetryDebugAction >> gtActionPerformRetryUsing: aDebugger withNewRetryCount: newCount [
	aDebugger  
		findLimitedFullActiveContextForMethod: ZnClient>>#execute
		ifFound: [ :aContext |
			aContext receiver 
				numberOfRetries: newCount.
							
			aDebugger 
				restart: aContext;
				resumeAndCloseDebugger ]
		ifNone: [
			self inform: 'Cannot execute action. Context not found.'] 
]

{ #category : #accessing }
GtZnClientFailedRequestRetryDebugAction >> gtActionRetryWithIncreasingRetriesFor: anAction inContext: aPhlowActionContext [
	| targetContext actionLabel |
	
	aPhlowActionContext currentDebuggingSession 
		findLimitedFullActiveContextForMethod: ZnClient>>#execute
		ifFound: [ :aContext | targetContext := aContext  ] 
		ifNone: [ ^ anAction noAction ] .
	
	actionLabel := 'Increase the number of retries in the Zinc client and retry the request'.
	^ anAction dropdown
		label: self defaultLabel;
		icon: self defaultIcon ;
		priority: self defaultOrder;
		id: #'gtZincConnectionFailure-retry';
		tooltip: actionLabel;
		preferredExtent: 650@350;
		content: [ 
			| contentElement |
			contentElement := GtZnClientFailedRequestRetryElement 
				forZnClient:  targetContext receiver
				andDebugger: aPhlowActionContext currentDebugger.
			contentElement  
				actionLabel: actionLabel;
				retryAction: [ :newCount :currentDebugger |
					self 
						gtActionPerformRetryUsing: currentDebugger
						withNewRetryCount: newCount].
			contentElement ] 
]

{ #category : #initalization }
GtZnClientFailedRequestRetryDebugAction >> initialize [
	super initialize.
	
	"No need to update the debgger as it will anyway be closed."
	self needsUpdate: false
]

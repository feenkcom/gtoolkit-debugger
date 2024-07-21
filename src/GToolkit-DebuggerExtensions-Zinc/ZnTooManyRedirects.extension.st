Extension { #name : #ZnTooManyRedirects }

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ZnTooManyRedirects >> gtActionPerformRetryUsing: aDebugger withNewRedirectCount: newCount [
	aDebugger  
		findLimitedFullActiveContextForMethod: ZnClient>>#execute
		ifFound: [ :aContext |
			aContext receiver 
				maxNumberOfRedirects: newCount.
							
			aDebugger 
				restart: aContext;
				resumeAndCloseDebugger ]
		ifNone: [
			self inform: 'Cannot execute action. Context not found.'] 
]

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ZnTooManyRedirects >> gtActionRetryWithIncreasingRedirectsFor: anAction inContext: aPhlowActionContext [
	<gtExceptionAction>
	<gtStackAction>
	| actionLabel |
	
	(aPhlowActionContext currentDebuggingSession 
		hasLimitedFullActiveContextForMethod: ZnClient>>#execute)
			ifFalse: [ ^ anAction noAction ].
		
	actionLabel := 'Increase the number of redirects in the Zinc client and retry the request'.
	^ anAction dropdown
		label: 'Retry';
		icon: BrGlamorousVectorIcons refresh ;
		priority: 50;
		id: #'gtTooManyRedirects-retry';
		tooltip: actionLabel;
		preferredExtent: 650@350;
		content: [ :aSourceButton |
			| contentElement |
			contentElement := GtZnClientTooManyRedirectsRetryElement 
				forZnClient:  signaler
				andDebugger: aPhlowActionContext currentDebugger
				fromSourceElement: aSourceButton.
			contentElement  
				actionLabel: actionLabel;
				retryAction: [ :newCount :currentDebugger |
					self 
						gtActionPerformRetryUsing: currentDebugger
						withNewRedirectCount: newCount].
			contentElement ] 
]

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ZnTooManyRedirects >> gtExceptionDebuggerSpecification [
	^ super gtExceptionDebuggerSpecification
		priority: 1200;
		availableAutomatically: false
]

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ZnTooManyRedirects >> gtViewUrlTrailFor: aView [ 
	<gtView>
	<gtContextView>
	<gtExceptionView>
	<gtEmbeddedDebuggerView>
	
	^ aView list 
		title: 'Url trail';
		items: [ self trail ]
]

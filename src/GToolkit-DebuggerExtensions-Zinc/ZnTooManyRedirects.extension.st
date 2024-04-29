Extension { #name : #ZnTooManyRedirects }

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ZnTooManyRedirects >> gtActionPerformRetryUsing: aDebugger withNewRetryCount: newCount [
	aDebugger  
		findLimitedFullActiveContextForMethod: ZnClient>>#executeWithTimeout
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
	| actionLabel |
	
	(aPhlowActionContext currentDebuggingSession 
		hasLimitedFullActiveContextForMethod: ZnClient>>#executeWithTimeout)
			ifFalse: [ ^ anAction noAction ].
		
	actionLabel := 'Increasing the number of redirects in the Zinc client and retry'.
	^ anAction dropdown
		label: 'Retry';
		icon: BrGlamorousVectorIcons refresh ;
		priority: 50;
		id: #'gtTooManyRedirects-retry';
		tooltip: actionLabel;
		preferredExtent: 650@350;
		content: [ 
			| contentElement |
			contentElement := GtZnClientTooManyRedirectsRetryElement 
				forZnClient:  signaler
				andDebugger: aPhlowActionContext currentDebugger.
			contentElement  
				actionLabel: actionLabel;
				retryAction: [ :newCount :currentDebugger |
					self 
						gtActionPerformRetryUsing: currentDebugger
						withNewRetryCount: newCount].
			contentElement ] 
]

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ZnTooManyRedirects >> gtDefaultDebuggerSpecification [
	^ super gtDefaultDebuggerSpecification
		debuggingActionPragmas: #(gtExceptionAction);
		yourself
]

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ZnTooManyRedirects >> gtExceptionDebuggerSpecification [
	^ super gtExceptionDebuggerSpecification
		priority: 1200;
		availableAutomatically: false;
		debuggingActionPragmas: #(gtExceptionAction)
]

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ZnTooManyRedirects >> gtViewUrlTrailFor: aView [ 
	<gtView>
	<gtContextView>
	<gtExceptionView>
	
	^ aView list 
		title: 'Url trail';
		items: [ self trail ]
]

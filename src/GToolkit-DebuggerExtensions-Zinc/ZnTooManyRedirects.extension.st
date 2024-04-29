Extension { #name : #ZnTooManyRedirects }

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ZnTooManyRedirects >> gtActionContinueWithIncreasingRedirectsFor: anAction inContext: aPhlowActionContext [
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
			GtZnClientTooManyRedirectsRetryElement new 
				actionLabel: actionLabel;
				currentMaxNumberOfRedirects: signaler maxNumberOfRedirects;
				retryAction: [ :newCount |
					aPhlowActionContext currentDebuggingSession  
						findLimitedFullActiveContextForMethod: ZnClient>>#executeWithTimeout
						ifFound: [ :aContext |
							aContext receiver 
								maxNumberOfRedirects: newCount.
							aPhlowActionContext currentDebuggingSession restart: aContext.
							aPhlowActionContext currentDebugger resumeAndCloseDebugger ]
						ifNone: [
							self inform: 'Cannot execute action. Context not found.'] ] ] 
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

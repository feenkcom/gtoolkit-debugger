Extension { #name : #ConnectionTimedOut }

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ConnectionTimedOut >> gtActionPerformRetryUsing: aDebugger withNewTimeout: aTimeoutInSeconds [
	aDebugger  
		findLimitedFullActiveContextForMethod: ZnClient>>#executeWithTimeout
		ifFound: [ :aContext |
			aContext receiver 
				timeout: aTimeoutInSeconds.
							
			aDebugger 
				restart: aContext;
				resumeAndCloseDebugger ]
		ifNone: [
			self inform: 'Cannot execute action. Context not found.'] 
]

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ConnectionTimedOut >> gtDefaultDebuggerSpecification [
	^ super gtDefaultDebuggerSpecification
		debuggingActionPragmas: #(gtStackAction);
		yourself
]

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ConnectionTimedOut >> gtZincActionRetryWithIncreasingTimeoutFor: anAction inContext: aPhlowActionContext [
	<gtExceptionAction>
	<gtStackAction>
	| targetContext actionLabel |
	
	aPhlowActionContext currentDebuggingSession 
		findLimitedFullActiveContextForMethod: ZnClient>>#executeWithTimeout
		ifFound: [ :aContext | targetContext := aContext  ] 
		ifNone: [ ^ anAction noAction ] .
		
	actionLabel := 'Increase the timeout in the Zinc client and retry'.
	
	^ anAction dropdown
		label: 'Retry';
		icon: BrGlamorousVectorIcons refresh ;
		priority: 50;
		id: #'gtConnectionTimedOut-retry';
		tooltip: actionLabel;
		preferredExtent: 650@350;
		content: [ 
			| contentElement |
			contentElement := GtZnClientConnectionTimedOutRetryElement 
				forZnClient: targetContext receiver
				andDebugger: aPhlowActionContext currentDebugger.
			contentElement  
				actionLabel: actionLabel;
				retryAction: [ :newCount :currentDebugger |
					self 
						gtActionPerformRetryUsing: currentDebugger
						withNewTimeout: newCount].
			contentElement ] 
]

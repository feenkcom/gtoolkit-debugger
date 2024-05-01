Extension { #name : #ConnectionTimedOut }

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ConnectionTimedOut >> gtActionContinueWaitingUsing: aDebugger withNewTimeout: aTimeoutInSeconds [
	aDebugger  
		findLimitedFullActiveContextForMethod: ZdcAbstractSocketStream>>#socketWaitForData
		ifFound: [ :aContext |
			aTimeoutInSeconds ~= aContext receiver timeout
				ifTrue: [
					aContext receiver 
						timeout: aTimeoutInSeconds ].
							
			aDebugger 
				restart: aContext;
				resumeAndCloseDebugger ]
		ifNone: [
			self inform: 'Cannot execute action. Context not found.'] 
]

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ConnectionTimedOut >> gtActionPerformRetryUsing: aDebugger withNewTimeout: aTimeoutInSeconds [
	aDebugger  
		findLimitedFullActiveContextForMethod: ZnClient>>#execute
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
ConnectionTimedOut >> gtZincActionContinueWaitingFor: anAction inContext: aPhlowActionContext [
	<gtExceptionAction>
	<gtStackAction>
	| targetContext actionLabel |
	
	(aPhlowActionContext currentDebuggingSession 
		hasLimitedFullActiveContextForMethod: ZnClient>>#execute) 
			ifFalse: [ ^ anAction noAction ].
	
	aPhlowActionContext currentDebuggingSession 
		findLimitedFullActiveContextForMethod: ZdcAbstractSocketStream>>#socketWaitForData
		ifFound: [ :aContext | targetContext := aContext  ] 
		ifNone: [ ^ anAction noAction ] .
		
	actionLabel := 'Continue waiting for the response'.
	
	^ anAction dropdown
		label: 'Continue';
		icon: BrGlamorousVectorIcons play ;
		priority: 50;
		id: #'gtConnectionTimedOut-wait';
		tooltip: actionLabel;
		preferredExtent: 650@350;
		content: [ :aSourceButton |
			| contentElement |
			contentElement := GtZnClientConnectionTimedOutRetryElement 
				forSocketStream: targetContext receiver
				andDebugger: aPhlowActionContext currentDebugger
				fromSourceElement: aSourceButton.
			contentElement  
				actionLabel: actionLabel;
				retryAction: [ :newCount :currentDebugger |
					self 
						gtActionContinueWaitingUsing: currentDebugger
						withNewTimeout: newCount].
			contentElement ] 
]

{ #category : #'*GToolkit-DebuggerExtensions-Zinc' }
ConnectionTimedOut >> gtZincActionRetryWithIncreasingTimeoutFor: anAction inContext: aPhlowActionContext [
	<gtExceptionAction>
	<gtStackAction>
	| targetContext actionLabel |
	
	aPhlowActionContext currentDebuggingSession 
		findLimitedFullActiveContextForMethod: ZnClient>>#execute
		ifFound: [ :aContext | targetContext := aContext  ] 
		ifNone: [ ^ anAction noAction ] .
		
	actionLabel := 'Increase the timeout in the Zinc client and retry the request'.
	
	^ anAction dropdown
		label: 'Retry';
		icon: BrGlamorousVectorIcons refresh ;
		priority: 50;
		id: #'gtConnectionTimedOut-retry';
		tooltip: actionLabel;
		preferredExtent: 650@350;
		content: [ :aSourceButton |
			| contentElement |
			contentElement := GtZnClientConnectionTimedOutRetryElement 
				forZnClient: targetContext receiver
				andDebugger: aPhlowActionContext currentDebugger
				fromSourceElement: aSourceButton.
			contentElement  
				actionLabel: actionLabel;
				retryAction: [ :newCount :currentDebugger |
					self 
						gtActionPerformRetryUsing: currentDebugger
						withNewTimeout: newCount].
			contentElement ] 
]

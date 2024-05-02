Class {
	#name : #GtZnClientFailedRequestRetryElement,
	#superclass : #GtZnClientExceptionRetryElement,
	#category : #'GToolkit-DebuggerExtensions-Zinc'
}

{ #category : #accessing }
GtZnClientFailedRequestRetryElement >> currentNumberOfRetries: aCount [ 
	countEditorElement text:  (aCount * 2) asString.
	messageEditorElement text: (self messageTextForRetriesCount: aCount)
]

{ #category : #accessing }
GtZnClientFailedRequestRetryElement >> editLabelText [
	^ 'Retry count:'
]

{ #category : #initialization }
GtZnClientFailedRequestRetryElement >> initializeForZnClient: aZnClient andDebugger: aDebugger fromSourceElement: aSourceElement [ 
	super initializeForZnClient: aZnClient andDebugger: aDebugger fromSourceElement: aSourceElement.

	self currentNumberOfRetries: aZnClient numberOfRetries
]

{ #category : #accessing }
GtZnClientFailedRequestRetryElement >> messageTextForRetriesCount: aCount [ 
	^ 'Reached the allowed number of {1} {2}. Increase the number of retries in the HTTP client and retry the request.' format: {
		aCount. 
		aCount = 1 
			ifTrue: [ 'retry' ] 
			ifFalse: [ 'retries' ]}
]

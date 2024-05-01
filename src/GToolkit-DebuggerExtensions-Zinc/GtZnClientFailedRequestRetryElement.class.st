Class {
	#name : #GtZnClientFailedRequestRetryElement,
	#superclass : #GtZnClientExceptionRetryElement,
	#category : #'GToolkit-DebuggerExtensions-Zinc'
}

{ #category : #accessing }
GtZnClientFailedRequestRetryElement >> currentNumberOfRetries: anInteger [ 
	countEditorElement text:  (anInteger * 2) asString.
	messageEditorElement text: (self messageTextForRetriesCount: anInteger)
]

{ #category : #accessing }
GtZnClientFailedRequestRetryElement >> editLabelText [
	^ 'Retry count:'
]

{ #category : #initialization }
GtZnClientFailedRequestRetryElement >> initializeForZnClient: aZnClient andDebugger: aDebugger [ 
	super initializeForZnClient: aZnClient andDebugger: aDebugger.
	
	self currentNumberOfRetries: aZnClient numberOfRetries
]

{ #category : #accessing }
GtZnClientFailedRequestRetryElement >> messageTextForRetriesCount: anInteger [ 
	^ 'Reached the allowed number of {1} {2}. Increase the number of retries in the ZnClient and retry the request.' format: {
		anInteger. 
		anInteger = 1 
			ifTrue: [ 'retry' ] 
			ifFalse: [ 'retries' ]}
]

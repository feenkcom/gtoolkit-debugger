Class {
	#name : #GtZnClientConnectionTimedOutRetryElement,
	#superclass : #GtZnClientExceptionRetryElement,
	#category : #'GToolkit-DebuggerExtensions-Zinc'
}

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> currentTimeout: anInteger [ 
	countEditorElement text:  (anInteger * 2) asString.
	messageEditorElement text: (self messageTextForTimeout: anInteger)
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> editLabelText [
	^ 'Timeout:'
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> initializeForZnClient: aZnClient andDebugger: aDebugger [ 
	super initializeForZnClient: aZnClient andDebugger: aDebugger.
	
	self currentTimeout: aZnClient timeout
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> messageTextForTimeout: aTimeoutInSeconds [ 
	^ 'Reached the maximum timeout of {1} {2}. Retry by increasing the value in the ZnClient.' format: {
		aTimeoutInSeconds. 
		'second' asPluralBasedOn: aTimeoutInSeconds}
]

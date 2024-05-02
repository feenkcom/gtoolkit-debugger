Class {
	#name : #GtZnClientConnectionTimedOutRetryElement,
	#superclass : #GtZnClientExceptionRetryElement,
	#category : #'GToolkit-DebuggerExtensions-Zinc'
}

{ #category : #'instance creation' }
GtZnClientConnectionTimedOutRetryElement class >> forSocketStream: aSocketStream andDebugger: aDebugger fromSourceElement: aSourceElement [
	^ self new 
		initializeForSocketStream: aSocketStream
		andDebugger: aDebugger 
		fromSourceElement: aSourceElement
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> configureForRetryWithCurrentTimeout: aTimeoutInSeconds [ 
	countEditorElement text:  (aTimeoutInSeconds * 2) asString.
	messageEditorElement text: (self messageRetryTextForTimeout: aTimeoutInSeconds)
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> configureForWaitWithCurrentTimeout: aTimeoutInSeconds [
	countEditorElement text: aTimeoutInSeconds.
	messageEditorElement text: (self messageWaitTextForTimeout: aTimeoutInSeconds)
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> editLabelText [
	^ 'Timeout (seconds):'
]

{ #category : #'initialization ' }
GtZnClientConnectionTimedOutRetryElement >> initializeForSocketStream: aSocketStream andDebugger: aDebugger fromSourceElement: aSourceElement [
	self initializeForDebugger: aDebugger fromSourceElement: aSourceElement.
	
	self configureForWaitWithCurrentTimeout: aSocketStream timeout.
]

{ #category : #initialization }
GtZnClientConnectionTimedOutRetryElement >> initializeForZnClient: aZnClient andDebugger: aDebugger fromSourceElement: aSourceElement [
	super initializeForZnClient: aZnClient andDebugger: aDebugger fromSourceElement: aSourceElement.

	self configureForRetryWithCurrentTimeout: aZnClient timeout
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> messageRetryTextForTimeout: aTimeoutInSeconds [ 
	^ 'Reached the maximum timeout of {1} {2}. Increase the timeout in the HTTP client and retry the request.' format: {
		aTimeoutInSeconds. 
		'second' asPluralBasedOn: aTimeoutInSeconds}
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> messageWaitTextForTimeout: aTimeoutInSeconds [ 
	^ 'Reached the maximum timeout of {1} {2}. Continue waiting in the HTTP client for a given number of seconds.' format: {
		aTimeoutInSeconds. 
		'second' asPluralBasedOn: aTimeoutInSeconds}
]

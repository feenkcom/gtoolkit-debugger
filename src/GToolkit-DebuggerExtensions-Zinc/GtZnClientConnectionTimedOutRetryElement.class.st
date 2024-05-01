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
GtZnClientConnectionTimedOutRetryElement >> configureForRetryWithCurrentTimeout: anInteger [ 
	countEditorElement text:  (anInteger * 2) asString.
	messageEditorElement text: (self messageRetryTextForTimeout: anInteger)
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> configureForWaitWithCurrentTimeout: anInteger [
	countEditorElement text: anInteger.
	messageEditorElement text: (self messageWaitTextForTimeout: anInteger)
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> editLabelText [
	^ 'Timeout (seconds):'
]

{ #category : #'initialization ' }
GtZnClientConnectionTimedOutRetryElement >> initializeForSocketStream: aSocketStream andDebugger: aDebugger [ 
	currentDebugger := aDebugger.
	
	self configureForWaitWithCurrentTimeout: aSocketStream timeout.
]

{ #category : #'initialization ' }
GtZnClientConnectionTimedOutRetryElement >> initializeForSocketStream: aSocketStream andDebugger: aDebugger fromSourceElement: aSourceElement [
	self initializeForDebugger: aDebugger fromSourceElement: aSourceElement.
	
	self configureForWaitWithCurrentTimeout: aSocketStream timeout.
]

{ #category : #initialization }
GtZnClientConnectionTimedOutRetryElement >> initializeForZnClient: aZnClient andDebugger: aDebugger fromSourceElement: aSourceElement [
	self initializeForDebugger: aDebugger fromSourceElement: aSourceElement.
	
	self configureForRetryWithCurrentTimeout: aZnClient timeout
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> messageRetryTextForTimeout: aTimeoutInSeconds [ 
	^ 'Reached the maximum timeout of {1} {2}. Increase the timeout in the ZnClient and retry the request.' format: {
		aTimeoutInSeconds. 
		'second' asPluralBasedOn: aTimeoutInSeconds}
]

{ #category : #accessing }
GtZnClientConnectionTimedOutRetryElement >> messageWaitTextForTimeout: aTimeoutInSeconds [ 
	^ 'Reached the maximum timeout of {1} {2}. Continue waiting for a given number of seconds.' format: {
		aTimeoutInSeconds. 
		'second' asPluralBasedOn: aTimeoutInSeconds}
]

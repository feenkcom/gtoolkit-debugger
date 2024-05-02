Class {
	#name : #GtZnClientTooManyRedirectsRetryElement,
	#superclass : #GtZnClientExceptionRetryElement,
	#category : #'GToolkit-DebuggerExtensions-Zinc'
}

{ #category : #accessing }
GtZnClientTooManyRedirectsRetryElement >> currentMaxNumberOfRedirects: aCount [ 
	countEditorElement text:  (aCount * 2) asString.
	messageEditorElement text: (self messageTextForRedirectCount: aCount)
]

{ #category : #accessing }
GtZnClientTooManyRedirectsRetryElement >> editLabelText [
	^ 'Maximum redirect count:'
]

{ #category : #accessing }
GtZnClientTooManyRedirectsRetryElement >> initializeForZnClient: aZnClient andDebugger: aDebugger fromSourceElement: aSourceElement [
	super initializeForZnClient: aZnClient andDebugger: aDebugger fromSourceElement: aSourceElement.

	self currentMaxNumberOfRedirects: aZnClient maxNumberOfRedirects
]

{ #category : #accessing }
GtZnClientTooManyRedirectsRetryElement >> messageTextForRedirectCount: aCount [ 
	^ 'Reached the maximum number of {1} {2}. Increase the maximum number of redirects in the HTTP client and retry the request.' format: {
		aCount. 
		'redirect' asPluralBasedOn: aCount}
]

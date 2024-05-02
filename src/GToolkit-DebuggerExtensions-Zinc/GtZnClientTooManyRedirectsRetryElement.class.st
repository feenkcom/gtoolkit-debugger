Class {
	#name : #GtZnClientTooManyRedirectsRetryElement,
	#superclass : #GtZnClientExceptionRetryElement,
	#category : #'GToolkit-DebuggerExtensions-Zinc'
}

{ #category : #accessing }
GtZnClientTooManyRedirectsRetryElement >> currentMaxNumberOfRedirects: anInteger [ 
	countEditorElement text:  (anInteger * 2) asString.
	messageEditorElement text: (self messageTextForRedirectCount: anInteger)
]

{ #category : #accessing }
GtZnClientTooManyRedirectsRetryElement >> editLabelText [
	^ 'Maximum redirect count:'
]

{ #category : #accessing }
GtZnClientTooManyRedirectsRetryElement >> initializeForZnClient: aZnClient andDebugger: aDebugger fromSourceElement: aSourceElement [
	self initializeForDebugger: aDebugger fromSourceElement: aSourceElement.
	
	self currentMaxNumberOfRedirects: aZnClient maxNumberOfRedirects
]

{ #category : #accessing }
GtZnClientTooManyRedirectsRetryElement >> messageTextForRedirectCount: anInteger [ 
	^ 'Reached the maximum number of {1} {2}. Increase the maximum number of redirects in the ZnClient and retry the request.' format: {
		anInteger. 
		'redirect' asPluralBasedOn: anInteger}
]

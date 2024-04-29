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
GtZnClientTooManyRedirectsRetryElement >> initializeForZnClient: aZnClient andDebugger: aDebugger [ 
	super initializeForZnClient: aZnClient andDebugger: aDebugger.
	
	self currentMaxNumberOfRedirects: aZnClient maxNumberOfRedirects
]

{ #category : #accessing }
GtZnClientTooManyRedirectsRetryElement >> messageTextForRedirectCount: anInteger [ 
	^ 'Reached the maximum number of {1} {2}. Retry by increasing the value in the ZnClient.' format: {
		anInteger. 
		'redirect' asPluralBasedOn: anInteger}
]

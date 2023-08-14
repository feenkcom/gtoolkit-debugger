Class {
	#name : #GtExampleExceptionDomainObjectWithDebuggingView,
	#superclass : #Object,
	#instVars : [
		'message',
		'collection',
		'dictionary'
	],
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtExampleExceptionDomainObjectWithDebuggingView >> collection [
	^ collection
]

{ #category : #accessing }
GtExampleExceptionDomainObjectWithDebuggingView >> collection: anObject [
	collection := anObject
]

{ #category : #accessing }
GtExampleExceptionDomainObjectWithDebuggingView >> dictionary [
	^ dictionary
]

{ #category : #accessing }
GtExampleExceptionDomainObjectWithDebuggingView >> dictionary: anObject [
	dictionary := anObject
]

{ #category : #'gt - extensions' }
GtExampleExceptionDomainObjectWithDebuggingView >> gtViewCollectionFor: aView [
	<gtView>
	<gtExceptionDebuggingView>
	
	collection ifNil: [ ^ aView empty ].
	
	^ aView list
		title: 'List';
		items: [ collection ]
]

{ #category : #'gt - extensions' }
GtExampleExceptionDomainObjectWithDebuggingView >> gtViewDictionaryFor: aView [
	<gtView>
	<gtExceptionDebuggingView>
	
	dictionary ifNil: [ ^ aView empty ].
	
	^ aView columnedList
		title: 'Dictionary';
		items: [ dictionary associations ];
		column: 'Key' text: [ :assoc | assoc key ];
		column: 'Value' text: [ :assoc | assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #'gt - extensions' }
GtExampleExceptionDomainObjectWithDebuggingView >> gtViewMessageFor: aView [
	<gtView>
	<gtExceptionDebuggingView>
	
	message ifNil: [ ^ aView empty ].
	
	^ aView textEditor
		title: 'Message';
		text: [ message ]
]

{ #category : #testing }
GtExampleExceptionDomainObjectWithDebuggingView >> hasData [
	^ collection notNil or: [
		dictionary notNil or: [
			message notNil ] ]
]

{ #category : #accessing }
GtExampleExceptionDomainObjectWithDebuggingView >> message [
	^ message
]

{ #category : #accessing }
GtExampleExceptionDomainObjectWithDebuggingView >> message: anObject [
	message := anObject
]

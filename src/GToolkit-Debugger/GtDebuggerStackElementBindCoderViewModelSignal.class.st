Class {
	#name : #GtDebuggerStackElementBindCoderViewModelSignal,
	#superclass : #GtDebuggerSignal,
	#instVars : [
		'coderElement',
		'oldCoderViewModel',
		'newCoderViewModel',
		'coderIndex'
	],
	#category : #'GToolkit-Debugger-Logging'
}

{ #category : #accessing }
GtDebuggerStackElementBindCoderViewModelSignal >> coderElement [

	^ coderElement
]

{ #category : #accessing }
GtDebuggerStackElementBindCoderViewModelSignal >> coderElement: anObject [

	coderElement := anObject
]

{ #category : #accessing }
GtDebuggerStackElementBindCoderViewModelSignal >> coderIndex [

	^ coderIndex
]

{ #category : #accessing }
GtDebuggerStackElementBindCoderViewModelSignal >> coderIndex: anObject [

	coderIndex := anObject
]

{ #category : #accessing }
GtDebuggerStackElementBindCoderViewModelSignal >> newCoderViewModel [

	^ newCoderViewModel
]

{ #category : #accessing }
GtDebuggerStackElementBindCoderViewModelSignal >> newCoderViewModel: anObject [

	newCoderViewModel := anObject
]

{ #category : #accessing }
GtDebuggerStackElementBindCoderViewModelSignal >> oldCoderViewModel [

	^ oldCoderViewModel
]

{ #category : #accessing }
GtDebuggerStackElementBindCoderViewModelSignal >> oldCoderViewModel: anObject [

	oldCoderViewModel := anObject
]

{ #category : #printing }
GtDebuggerStackElementBindCoderViewModelSignal >> printOneLineContentsOn: aStream [
	newCoderViewModel == oldCoderViewModel
		ifTrue: [
			aStream
				nextPutAll: 'Rebind the same coder (id: ';
				print: newCoderViewModel coder id;
				nextPutAll: ') view model' ]
		ifFalse: [
			oldCoderViewModel
				ifNil: [ aStream nextPutAll: 'Bind a new coder view model' ]
				ifNotNil: [ :anOldCoderViewModel |
					aStream
						nextPutAll: 'Bind a different coder (new: ';
						print: newCoderViewModel coder id;
						nextPutAll: ', old: ';
						print: anOldCoderViewModel coder id;
						nextPutAll:') view model' ] ].

	aStream
		nextPutAll: ' at ';
		print: coderIndex
]

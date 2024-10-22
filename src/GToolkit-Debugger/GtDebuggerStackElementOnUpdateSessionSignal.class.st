Class {
	#name : #GtDebuggerStackElementOnUpdateSessionSignal,
	#superclass : #GtDebuggerSignal,
	#instVars : [
		'debuggingSession',
		'debuggingSessionStack'
	],
	#category : #'GToolkit-Debugger-Logging'
}

{ #category : #accessing }
GtDebuggerStackElementOnUpdateSessionSignal >> debuggingSession [
	^ debuggingSession
]

{ #category : #accessing }
GtDebuggerStackElementOnUpdateSessionSignal >> debuggingSession: anObject [
	debuggingSession := anObject
]

{ #category : #accessing }
GtDebuggerStackElementOnUpdateSessionSignal >> debuggingSessionStack [
	^ debuggingSessionStack
]

{ #category : #'as yet unclassified' }
GtDebuggerStackElementOnUpdateSessionSignal >> gtDebuggingSessionStackFor: aView [
	<gtView>
	^ aView tree
		title: 'Debugging Stack';
		items: [ self debuggingSessionStack ifNil: [ #() ] ];
		priority: 1;
		children: [ :anItem | anItem isContext ifTrue: [ anItem gtVariables ] ifFalse: [ #() ] ];
		itemText: [ :anItem | 
			anItem isContext
				ifTrue: [ anItem ]
				ifFalse: [ anItem name asRopedText
						append: ' := ' asRopedText;
						foreground: BrGlamorousColors disabledButtonTextColor;
						append: anItem description ] ];
		send: [ :anItem | anItem isContext ifTrue: [ anItem ] ifFalse: [ anItem value ] ]
]

{ #category : #initialize }
GtDebuggerStackElementOnUpdateSessionSignal >> prepareForDelivery [
	super prepareForDelivery.
	debuggingSession ifNotNil: [ 
		debuggingSessionStack := debuggingSession stack collect: #copy ]
]

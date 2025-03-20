Class {
	#name : #GtFilteredDebugSession,
	#superclass : #DebugSession,
	#instVars : [
		'filters',
		'lastResult',
		'lastMethod'
	],
	#category : #'GToolkit-Debugger-Session'
}

{ #category : #accessing }
GtFilteredDebugSession >> filters [
	^ filters ifNil: [ #() ]
]

{ #category : #accessing }
GtFilteredDebugSession >> filters: aCollection [
	filters := aCollection
]

{ #category : #accessing }
GtFilteredDebugSession >> finishStep [
	(self isContextPostMortem: interruptedContext) ifTrue: [ ^ self ].
	(filters isNil or: [ filters isEmpty ]) ifTrue: [ ^ self ].
	[ (self isMethodIncluded: interruptedContext method method)
		or: [ interruptedContext sender isNil ] ]
		whileFalse: [ super stepInto: interruptedContext ]
]

{ #category : #accessing }
GtFilteredDebugSession >> isMethodIncluded: aCompiledMethod [
	lastMethod == aCompiledMethod ifTrue: [ ^ lastResult ].
	lastMethod := aCompiledMethod.
	^ lastResult := filters
			anySatisfy: [ :each | each matches: aCompiledMethod ]
]

{ #category : #accessing }
GtFilteredDebugSession >> isRootContext: aContext [
	^ aContext sender isNil
		and: [ (self isMethodIncluded: aContext method method) not ]
]

{ #category : #accessing }
GtFilteredDebugSession >> stepInto: aContext [
	super
		stepInto: ((self isRootContext: aContext)
				ifTrue: [ interruptedContext ]
				ifFalse: [ aContext ]).
	self finishStep
]

{ #category : #accessing }
GtFilteredDebugSession >> stepOver: aContext [
	(self isRootContext: aContext) ifTrue: [ ^ self stepInto: aContext ].
	super stepOver: aContext.
	self finishStep
]

{ #category : #accessing }
GtFilteredDebugSession >> stepThrough: aContext [
	(self isRootContext: aContext) ifTrue: [ ^ self stepInto: aContext ].
	super stepThrough: aContext.
	self finishStep
]

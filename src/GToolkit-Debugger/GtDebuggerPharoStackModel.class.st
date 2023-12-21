Class {
	#name : #GtDebuggerPharoStackModel,
	#superclass : #GtDebuggerAbstractStackModel,
	#category : #'GToolkit-Debugger-Models'
}

{ #category : #accessing }
GtDebuggerPharoStackModel >> context: aContext [
	context ~~ aContext
		ifTrue: [ 
			(context notNil and: [ context isDead ])
				ifTrue: [ self resetCoderViewModelCache ].
			context := aContext.
			self updateContextStreams ]
]

{ #category : #accessing }
GtDebuggerPharoStackModel >> createCoderFor: aContext in: aSession [
	| coder |
	coder := GtPharoMethodContextCoder forContext: aContext session: aSession.
	coder announcer weak 
		when: GtCoderRefreshStackAnnouncement send: #forceRefreshStack to: self.
	coder announcer weak 
		when: DebugActionExecuted send: #forceRefreshStack to: self.
	^ coder
]

{ #category : #accessing }
GtDebuggerPharoStackModel >> getCoderViewModelForContext: aContext [
	^ lock
		critical: [ | method entry |
			method := aContext isBlockContext ifFalse: [ aContext compiledCode ].
			entry := coderViewModelCache
					at: aContext
					ifAbsentPut: [ {
						(self createCoderFor: aContext in: session) asCoderViewModel.
						method } ].
			(entry at: 2) ~~ method
				ifTrue: [ 
					entry first coder forMethod: method.
					entry at: 2 put: method ].
			entry at: 1 ]
		ifError: [ nil ]
]

{ #category : #accessing }
GtDebuggerPharoStackModel >> hideVariableValueAnnotations [
	self
		cachedCodersDo: [ :each | 
			each removeStylersOfClass: GtStackContextVariableValueStyler.
			each requestUpdateAddOns ]
]

{ #category : #accessing }
GtDebuggerPharoStackModel >> resetCoderViewModelCache [
	lock
		critical: [ 
			coderViewModelCache keys
				do: [ :each | each isDead ifTrue: [ coderViewModelCache removeKey: each ifAbsent: [  ] ] ] ]
		ifError: [  ]
]

{ #category : #accessing }
GtDebuggerPharoStackModel >> showVariableValueAnnotations [
	self
		cachedCodersDo: [ :viewModel | 
			viewModel
				addStyler: (GtStackContextVariableValueStyler new coderViewModel: viewModel).
			viewModel requestUpdateAddOns ]
]

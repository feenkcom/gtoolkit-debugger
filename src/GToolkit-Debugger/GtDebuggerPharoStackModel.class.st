Class {
	#name : #GtDebuggerPharoStackModel,
	#superclass : #GtDebuggerAbstractStackModel,
	#instVars : [
		'currentContextMethodIndicator'
	],
	#category : #'GToolkit-Debugger-Models'
}

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
GtDebuggerPharoStackModel >> currentContextMethodIndicator [
	<return: #GtDebuggerPharoMethodIndicator or: nil>
	^ currentContextMethodIndicator
]

{ #category : #'gt-extensions' }
GtDebuggerPharoStackModel >> gtCachedCoders: aView [
	<gtView>
	
	^ aView list
		title: 'Cached coders';
		priority: 5;
		items: [ Array streamContents: [ :aStream | self cachedCodersDo: [ :eachCoder | aStream nextPut: eachCoder ] ] ];
		actionUpdateButton
]

{ #category : #'gt-extensions' }
GtDebuggerPharoStackModel >> gtContextCoderViewModelsFor: aView [
	<gtView>
	
	^ aView list
		title: 'Context coders';
		priority: 4;
		items: [ self coderViewModelStream ];
		actionUpdateButton
]

{ #category : #'gt-extensions' }
GtDebuggerPharoStackModel >> gtContextsFor: aView [
	<gtView>
	
	^ aView list
		title: 'Contexts';
		priority: 3;
		items: [ self contextStream ];
		actionUpdateButton
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
	coderViewModelCache keys
		do: [ :each | each isDead ifTrue: [ coderViewModelCache removeKey: each ifAbsent: [  ] ] ]
]

{ #category : #updating }
GtDebuggerPharoStackModel >> setCurrentContext: aContext [
	"Changes the Context to a given one trying to preserve
	cached coders for each stack frame.
	Return true if the context changed"
	<return: #Boolean>
	currentContextMethodIndicator := GtDebuggerPharoMethodIndicator 
		previousIndicator: currentContextMethodIndicator
		newContext: aContext.
	GtDebuggerPharoMethodIndicatorSignal new
		indicator: currentContextMethodIndicator;
		previousContext: currentContext;
		newContext: aContext;
		emit.
	
	currentContext == aContext
		ifTrue: [ ^ false ].

	(currentContext notNil and: [ currentContext isDead ])
		ifTrue: [ self resetCoderViewModelCache ].
	
	currentContext := aContext.
	^ true
]

{ #category : #accessing }
GtDebuggerPharoStackModel >> showVariableValueAnnotations [
	self
		cachedCodersDo: [ :viewModel | 
			viewModel
				addStyler: (GtStackContextVariableValueStyler new coderViewModel: viewModel).
			viewModel requestUpdateAddOns ]
]

{ #category : #updating }
GtDebuggerPharoStackModel >> updateBasedOnCurentContext: aContext [
	"Changes the Context to a given one trying to preserve
	cached coders for each stack frame"
	(self setCurrentContext: aContext)
		ifTrue: [ self notifyDebuggerStackChanged ]
]

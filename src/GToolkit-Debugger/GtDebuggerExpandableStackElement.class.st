Class {
	#name : #GtDebuggerExpandableStackElement,
	#superclass : #BlElement,
	#instVars : [
		'selectedCoder',
		'annotationsEnabled'
	],
	#category : #'GToolkit-Debugger'
}

{ #category : #callbacks }
GtDebuggerExpandableStackElement >> actOnCoderInFocusFor: aCoder [
	selectedCoder := aCoder.
	self debuggerElement actOnSelectedContextChangedFor: aCoder context.
]

{ #category : #testing }
GtDebuggerExpandableStackElement >> areAnnotationsEnabled [
	^ annotationsEnabled ifNil: [ false ]
]

{ #category : #'building elements' }
GtDebuggerExpandableStackElement >> buildElementForCoder: aMethodCoder [
	| element |
	element := aMethodCoder asElement.
	element when: BlFocusInEvent do: [ :event | 
		self actOnCoderInFocusFor: aMethodCoder ].
	aMethodCoder == selectedCoder ifTrue: [
		element requestFocus ].
	^ element
]

{ #category : #'building elements' }
GtDebuggerExpandableStackElement >> buildStackFramesList [
	| stackFramesList |
	stackFramesList := BrSimpleList new.
	stackFramesList stencil: [ :each | self buildElementForCoder: each ].
	stackFramesList padding: (BlInsets all: 10).
	stackFramesList
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	^ stackFramesList
]

{ #category : #private }
GtDebuggerExpandableStackElement >> codersToDisplayFrom: aSession preservingContexts: currenCoders [
	| methodCoders context firstContext newCoder newCoders |
	
	methodCoders := currenCoders reject: [ :each | each isDead ].
	firstContext := methodCoders isEmpty
		ifTrue: [ nil ]
		ifFalse: [ methodCoders first context ].
	
	context := aSession interruptedContext.
	newCoders := OrderedCollection new.
	[ context notNil and: [ context ~~ firstContext ] ]
		whileTrue: [ 
			newCoder := self createCoderFor: context in: aSession.
			newCoders add: newCoder.
			context := context sender ].
		
	"For the moment look only for a new on:do: context that does not have a coder. 
	Those contexts can be added by a Step Through action. This is mostly a hack.
	A better solution would be to iterate over the stack and determine if there are
	new contexts at any point in the stack. "
	(context notNil and: [ context sender notNil and: [ 
		 "The next context should be BlockClosure>>#on:do:"
		(context sender method = (BlockClosure>>#on:do:)) and: [
			"There should be no coder for the context: either we just have a coder 
			or the coder after firstContext is for another context "
			  methodCoders size = 1 or: [ methodCoders second context ~~ context sender ] ] ] ]) ifTrue: [ 
				
		"Insert a new coder after the first context for the new context."	
		newCoder := self createCoderFor: context sender in: aSession.
		methodCoders 
			add: newCoder
			afterIndex: 1 ].
	
	methodCoders addAllFirst: newCoders.
	^ methodCoders
]

{ #category : #private }
GtDebuggerExpandableStackElement >> createCoderFor: aContext in: aSession [
	| coder |
	coder := GtMethodContextCoder forContext: aContext session: aSession.
	self areAnnotationsEnabled ifTrue: [
		coder addOns addStyler: (GtCoderContextVariableValueStyler new methodCoder: coder) ].
	coder announcer weak when: GtCoderRefreshStackAnnouncement send: #updateContent to: self.
	^ coder
]

{ #category : #'accessing elements' }
GtDebuggerExpandableStackElement >> debuggerElement [
	| currentElement |
	currentElement := self.
	[ currentElement hasParent ] whileTrue: [ 
		| containerName |
		currentElement := 	currentElement parent.
		containerName := currentElement userData at: #debuggerContainer ifAbsent: [ nil ].
		containerName = #debuggerElement ifTrue: [ 
			^ currentElement ] ].
	^ nil
]

{ #category : #actions }
GtDebuggerExpandableStackElement >> disableVariableAnnotations [
	annotationsEnabled := false.
	self stackFramesList items do: [ :aCoder |
		aCoder addOns removeStylerOfType: GtCoderContextVariableValueStyler ].
	self updateContent
]

{ #category : #actions }
GtDebuggerExpandableStackElement >> enableVariableAnnotations [
	annotationsEnabled := true.
	self stackFramesList items do: [ :aCoder |
		aCoder addOns addStyler: (GtCoderContextVariableValueStyler new methodCoder: aCoder) ].
	self updateContent.
]

{ #category : #initialization }
GtDebuggerExpandableStackElement >> initialize [
	super initialize.
	self constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	self initializeStackList.
]

{ #category : #initialization }
GtDebuggerExpandableStackElement >> initializeStackList [
	| stackFramesList |
	stackFramesList := self buildStackFramesList.
	stackFramesList items: OrderedCollection new.
	self addChild: stackFramesList
]

{ #category : #actions }
GtDebuggerExpandableStackElement >> selectCoder: aContextCoder [
	selectedCoder := aContextCoder.
	selectedCoder expanded: true.
	
	"Update the content as some actions (for example save)
	can change the compiled method stored in the context."
	selectedCoder updateContent
]

{ #category : #actions }
GtDebuggerExpandableStackElement >> selectContext: aContext [
	self stackFramesList items 
		detect:  [ :aCoder | aCoder context = aContext ]
		ifFound: [ :aCoder | self selectCoder: aCoder ] 
		ifNone: [  ]
]

{ #category : #accessing }
GtDebuggerExpandableStackElement >> selectedCoder [
	^ selectedCoder
]

{ #category : #'accessing elements' }
GtDebuggerExpandableStackElement >> stackFramesList [
	^ self children first.
]

{ #category : #updating }
GtDebuggerExpandableStackElement >> updateContent [
	self updateForSession: self debuggerElement session
]

{ #category : #updating }
GtDebuggerExpandableStackElement >> updateForSession: aDebuggingSession [
	self stackFramesList
		items:
			(self
				codersToDisplayFrom: aDebuggingSession
				preservingContexts: self stackFramesList items).
	self stackFramesList items
		ifNotEmpty: [ :methodCoders | self selectCoder: methodCoders first ]
]

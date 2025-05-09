Class {
	#name : #GtDebuggerStackElement,
	#superclass : #BlElement,
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #initialization }
GtDebuggerStackElement >> initialize [
	super initialize.
	
	self
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent].
	self initializeStackFramesList.
]

{ #category : #initialization }
GtDebuggerStackElement >> initializeStackFramesList [
	| stackFrames |
	stackFrames := BrColumnedList new 
		constraintsDo: [ :c | 
			c padding: (BlInsets top: 10) ];
		rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new).
			
	stackFrames column
		title: 'Class';
		stencil: [ :aContext :index |
			| textElement |
			textElement := (BrColumnCellLabelStencil matchParent: (self printStackClassColumnForContext: aContext)) asElement.
			textElement constraintsDo: [ :c | c padding: (BlInsets left: 10)] ].

	stackFrames column
		title: 'Selector';
		stencil: [ :aContext :index | 
			| textElement |
			textElement := (BrColumnCellLabelStencil matchParent: (self printStackMethodColumnForContext: aContext)) asElement.
			textElement constraintsDo: [ :c | c padding: (BlInsets left: 10) ] ].
		
	stackFrames column
		title: 'Other';
		stencil: [ :aContext :index | 
			| textElement |
			textElement := (BrColumnCellLabelStencil matchParent: (self printStackExtraColumnForContext: aContext)) asElement.
			textElement constraintsDo: [ :c | c padding: (BlInsets left: 10) ] ].
		
	self addChild: stackFrames.
]

{ #category : #printing }
GtDebuggerStackElement >> printStackClassColumnForContext: aContext [
	| outer class methodClass |
	
	outer := aContext outerMostContext.
	^ String streamContents: [ :aStream |
		class := outer receiver class.
		aStream nextPutAll: class name.
		methodClass := outer methodClass.
		methodClass == class
			ifFalse:
				[ aStream 
						nextPut: $(;
						nextPutAll: methodClass name;
						nextPut: $) ] ]  
]

{ #category : #printing }
GtDebuggerStackElement >> printStackExtraColumnForContext: aContext [ 

	| selector |
	^ aContext outerContext 
		ifNil: [ 
			String streamContents: [ :aStream |
				selector := aContext selector ifNil: [ aContext method defaultSelector ].
				selector = #doesNotUnderstand:
					ifTrue:[ 
						aStream space.
						(aContext tempAt: 1) selector printOn: aStream ]
					ifFalse: [ '' ] ] ]
		ifNotNil: [ aContext closure printString  ]
]

{ #category : #printing }
GtDebuggerStackElement >> printStackMethodColumnForContext: aContext [ 
	| outer selector |
	
	outer := aContext outerMostContext.
	^ String streamContents: [ :aStream |
		selector := outer selector ifNil: [ outer method defaultSelector ].
		aStream nextPutAll: selector ]
]

{ #category : #accessing }
GtDebuggerStackElement >> retrieveStackFrom: aSession [
	^ aSession stack
]

{ #category : #accessing }
GtDebuggerStackElement >> stackFramesWidget [
	^ self children first
]

{ #category : #updating }
GtDebuggerStackElement >> updateForSession: aDebuggingSession [
	self stackFramesWidget items: (self retrieveStackFrom: aDebuggingSession).
	self stackFramesWidget selectOne: 1.
]

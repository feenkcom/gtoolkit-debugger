Extension { #name : #Context }

{ #category : #'*GToolkit-Debugger' }
Context >> gtBytecodeDebuggerRetrieveContextValues [
	|fieldList displayedTemp slotsSize tempNames |

	fieldList := OrderedCollection new.
	displayedTemp := OrderedCollection new.
	tempNames := self tempNames.
	
	self stackPtr to: 1 by: -1 do: [ :tempIndex ||tempNode|
		fieldList add:
			(tempIndex <= tempNames size
				ifTrue: [ 
					displayedTemp add: (tempNames at: tempIndex).
					tempNode := GTInspectorContextNamedTempNode 
						hostObject: self 
						tempName: (tempNames at: tempIndex) 
						tempIndex: tempIndex.
					GTInspectorWrapperNode 
						hostObject: tempNode
						label: (tempIndex - 1) asString, ' [', (tempNames at: tempIndex), ']'  ]
				ifFalse: [
					 tempNode := GTInspectorContextIndexedTempNode hostObject: self tempIndex: tempIndex.
					 GTInspectorWrapperNode 
					 	hostObject: tempNode
						label: (tempIndex - 1) asString ]) ].
	
	(tempNames copy asOrderedCollection removeAll: displayedTemp; yourself) ifNotEmpty: [ :uninitializedTemps |
		uninitializedTemps do: [ :each |
			GTInspectorDynamicNode hostObject: self label: ('- [', each, ']') value: nil ] ].
	
	fieldList addAll: (self gtDebuggerDoItBindings collect: [:aBinding |
		(GTInspectorDynamicNode hostObject: self label: aBinding key value: aBinding value)
			variableTag: 'temp';
			yourself ]).
	
	slotsSize := self receiver class allSlots size.
	fieldList 
		addAll: ((self receiver class allSlots reverse) collect: [:slot ||slotNode|
			slotNode :=  GTInspectorSlotNode hostObject: self receiver slot: slot.
			GTInspectorWrapperNode 
				hostObject: slotNode
				label: ('rcv', (slotsSize := slotsSize - 1) asString, ' [', slot name , ']')  ]).
	
	^ fieldList asOrderedCollection 
		addFirst: (GTInspectorSelfNode hostObject: self receiver);
		addLast: (GTInspectorDynamicNode hostObject: self label: 'thisContext' value: self);
		yourself
]

{ #category : #'*GToolkit-Debugger' }
Context >> gtDebuggerDoItBindings [
	^ (self compiledCode isDoIt and: [ self receiver isNil ]) 
		ifTrue: [ self compiledCode literals select: [ :each | 
			each class = WorkspaceVariable ] ]
		ifFalse: [ #() ]
]

{ #category : #'*GToolkit-Debugger' }
Context >> gtDebuggerRetrieveVariableValuePairs [
	|fieldList|

	fieldList := SortedCollection 
						sortBlock: [:variablePair1 :variablePair2 | 
							variablePair1 key < variablePair2 key].
	fieldList
		addAll: ((self receiver class allSlots collect: [ :slot | 
			GTInspectorSlotNode hostObject: self receiver slot: slot ])).
		
	fieldList addAll: self gtInspectorTempNodes.
	fieldList addAll: (self gtDebuggerDoItBindings collect: [:aBinding |
		(GTInspectorDynamicNode hostObject: self label: aBinding key value: aBinding value)
			variableTag: 'temp';
			yourself ]).
	
	^ fieldList asOrderedCollection 
		addFirst: (GTInspectorSelfNode hostObject: self receiver);
		addLast: (GTInspectorDynamicNode hostObject: self label: 'thisContext' value: self);
		addLast: (GTInspectorDynamicNode hostObject: self label: 'stack top' value: ( self stackPtr > 0 ifTrue: [ self top]));
		yourself

]

{ #category : #'*GToolkit-Debugger' }
Context >> isContextDoesNotUnderstand [
	^ self selector == #doesNotUnderstand:
]

{ #category : #'*GToolkit-Debugger' }
Context >> shortDebugStackOn: aStream [
	"print the top 100 contexts on my sender chain."

	^ self debugStack: 100 on: aStream
]

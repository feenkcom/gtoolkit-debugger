Extension { #name : #RBPatternBlockNode }

{ #category : #'*GToolkit-Debugger-RB' }
RBPatternBlockNode >> replacePatternNodesIn: aRBBlockNode [
	aRBBlockNode body
		nodesDo: [ :each | 
			(each isVariable and: [ each isPatternNode ])
				ifTrue: [ | lookupNode |
					lookupNode := self constructLookupNodeFor: each name in: aRBBlockNode.
					lookupNode
						nodesDo: [ :node | node propertyAt: #debuggerSourceInterval put: each sourceInterval ].
					each replaceWith: lookupNode ] ]
]

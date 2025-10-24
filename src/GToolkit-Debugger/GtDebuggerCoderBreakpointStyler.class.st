Class {
	#name : #GtDebuggerCoderBreakpointStyler,
	#superclass : #GtGenericPharoStyler,
	#category : #'GToolkit-Debugger-Breakpoints'
}

{ #category : #actions }
GtDebuggerCoderBreakpointStyler >> showBreakpointFor: aNode at: position [
	| attribute breakpoint |
	self assert: aNode breakpoints size = 1.
	
	breakpoint := aNode breakpoints anyOne.
	attribute := BrTextAdornmentDynamicAttribute new beAppend.
	^ self
		attribute: (attribute
				stencil: [ GtDebuggerBreakpointMenu on: breakpoint coderModel: coderViewModel coderModel ])
		from: position
		to: position
]

{ #category : #visiting }
GtDebuggerCoderBreakpointStyler >> visitLiteral: aLiteral [
	super visitLiteral: aLiteral.
	
	coderViewModel compiledMethod hasBreakpoint ifFalse: [^self].
	(coderViewModel compiledMethod ast allChildren
		select: [:each | each isLiteralNode]) detect: 
				[:each |
				each hasBreakpoint and: 
						[each start = aLiteral startPosition
							and: [each stop = aLiteral stopPosition]]]
			ifFound: [:node | self showBreakpointFor: node at: aLiteral startPosition - 1]
]

{ #category : #visiting }
GtDebuggerCoderBreakpointStyler >> visitMessage: aMessage [
	super visitMessage: aMessage.
	
	coderViewModel compiledMethod hasBreakpoint ifFalse: [^self].
	coderViewModel compiledMethod ast sendNodes detect: 
			[:each |
			each hasBreakpoint and: 
					[each selectorNode start = aMessage startPosition
						and: [each stop = aMessage stopPosition]]]
		ifFound: [:node | self showBreakpointFor: node at: aMessage startPosition - 1]
]

{ #category : #visiting }
GtDebuggerCoderBreakpointStyler >> visitVariable: aVariable [
	super visitVariable: aVariable.
	
	(Breakpoint gtIsInstalledIn: coderViewModel compiledMethod)
		ifFalse: [ ^ self ].
	
	coderViewModel compiledMethod ast allVariables detect: 
			[:each |
			each hasBreakpoint and: 
					[each start = aVariable startPosition
						and: [each stop = aVariable stopPosition]]]
		ifFound: [:node | self showBreakpointFor: node at: aVariable startPosition - 1]
]

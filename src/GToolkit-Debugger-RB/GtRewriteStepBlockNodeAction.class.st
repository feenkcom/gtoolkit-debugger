Class {
	#name : #GtRewriteStepBlockNodeAction,
	#superclass : #GtRewriteStepNodeAction,
	#category : #'GToolkit-Debugger-RB'
}

{ #category : #registration }
GtRewriteStepBlockNodeAction class >> gt2ContextDebuggingActionFor: aDebugger [
	^ (self forDebugger: aDebugger)
		icon: BrGlamorousVectorIcons through;
		keymap: (BlKeyCombination builder
				key: BlKeyboardKey F12;
				build) gtDisplayString
]

{ #category : #accessing }
GtRewriteStepBlockNodeAction >> defaultLabel [
	^ 'Step inside pattern block'
]

{ #category : #actions }
GtRewriteStepBlockNodeAction >> executeAction [
	| context lastMethod ignoredMethods patternContext interval patternContextMethod |
	context := self session foundMatchContext.
	context ifNil: [ ^ self ].
	ignoredMethods := IdentitySet new.
	(patternContext := self session patternBlockContext)
		ifNotNil: [ patternContextMethod := patternContext method method.
			self session node
				ifNotNil: [ :node | 
					(patternContext method sourceNodeForPC: patternContext pc)
						ifNotNil: [ :debuggerNode | interval := debuggerNode gtDebugHighlightRange ] ] ].
	self
		stepUntil: [ :each | 
			| contextMethod |
			contextMethod := each method method.
			patternContextMethod == contextMethod
				ifTrue: [ (each method sourceNodeForPC: each pc)
						ifNil: [ true ]
						ifNotNil: [ :node | node gtDebugHighlightRange ~= interval ] ]
				ifFalse: [ contextMethod ~~ lastMethod
						and: [ (ignoredMethods includes: contextMethod) not
								and: [ lastMethod := contextMethod.
									ignoredMethods add: lastMethod.
									(debugger session isPatternBlockContext: each)
										and: [ each ~~ patternContext
												or: [ (each method sourceNodeForPC: each pc)
														ifNil: [ true ]
														ifNotNil: [ :node | node gtDebugHighlightRange ~= interval ] ] ] ] ] ] ]
		context: context
]

{ #category : #accessing }
GtRewriteStepBlockNodeAction >> help [
	^ 'Step inside a pattern block node'
]

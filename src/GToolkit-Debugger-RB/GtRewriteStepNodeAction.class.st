Class {
	#name : #GtRewriteStepNodeAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-Debugger-RB'
}

{ #category : #registration }
GtRewriteStepNodeAction class >> gt2ContextDebuggingActionFor: aDebugger [
	^ (self forDebugger: aDebugger)
		icon: BrGlamorousVectorIcons over;
		keymap: (BlKeyCombination builder
				key: BlKeyboardKey F10;
				build) gtDisplayString
]

{ #category : #accessing }
GtRewriteStepNodeAction >> defaultLabel [
	^ 'Step to next node'
]

{ #category : #accessing }
GtRewriteStepNodeAction >> enabled [
	^ self session isValid
]

{ #category : #actions }
GtRewriteStepNodeAction >> executeAction [
	| context nodeContext |
	context := self session foundMatchContext.
	context ifNil: [ ^ self ].
	nodeContext := self session nodeContext.
	self
		stepUntil: [ :each | each ~~ nodeContext and: [ self session isNodeContext: each ] ]
		context: context
]

{ #category : #accessing }
GtRewriteStepNodeAction >> help [
	^ 'Step until next node'
]

{ #category : #private }
GtRewriteStepNodeAction >> stepUntil: aBlock context: rootContext [
	| context process previousContext |
	process := self session process.
	context := self currentContext.
	(process suspendedContext findContextSuchThat: [ :c | c == context ])
		ifNil: [ ^ self ].
	previousContext := nil.
	[ context notNil
		and: [ process isTerminating not
				and: [ process isTerminated not
						and: [ process suspendedContext notNil
								and: [ previousContext notNil and: [ aBlock value: context ] ] ] ] ] ]
		whileFalse: [ previousContext == context
				ifFalse: [ (context findContextSuchThat: [ :c | c == rootContext ]) isNil
						ifTrue: [ ^ self session updateContextTo: context ].
					previousContext := context ].
			context := process step: context ].
	self session updateContextTo: context
]

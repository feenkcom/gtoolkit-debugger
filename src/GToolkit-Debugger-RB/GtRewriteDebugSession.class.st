Class {
	#name : #GtRewriteDebugSession,
	#superclass : #DebugSession,
	#category : #'GToolkit-Debugger-RB'
}

{ #category : #debugging }
GtRewriteDebugSession class >> debugCurrentProcess [
	| suspended process session foundMatchContext debugContext |
	suspended := thisContext.
	foundMatchContext := self findContext: suspended max: SmallInteger maxVal.
	foundMatchContext ifNil: [ ^ self error: 'Cannot find rewrite' ].
	process := Processor activeProcess.
	[ process suspend.
	debugContext := suspended sender.
	process return: suspended value: suspended receiver.
	session := self
			named: 'RBParseTreeRewriter'
			on: process
			startedAt: debugContext.
	session
		stepIntoUntil: [ :context | context isNil or: [ context method methodClass isAnonymous not ] ].
	(OupsDebugRequest newForContext: session interruptedContext)
		process: process;
		label: 'RBParseTreeRewriter';
		submit ] fork.
	process suspend
]

{ #category : #private }
GtRewriteDebugSession class >> findContext: aContext max: anInteger [
	| count |
	count := 1.
	^ aContext
		findContextSuchThat: [ :each | 
			count := count + 1.
			count > anInteger ifTrue: [ ^ nil ].
			self isRewriteContext: each ]
]

{ #category : #testing }
GtRewriteDebugSession class >> handlesContext: aContext [
	^ (self findContext: aContext max: 50) notNil
]

{ #category : #testing }
GtRewriteDebugSession class >> isRewriteContext: aContext [
	^ aContext selector = #foundMatchFor:
		and: [ aContext receiver isKindOf: RBParseTreeRule ]
]

{ #category : #accessing }
GtRewriteDebugSession >> ast [
	^ self executeTreeContext ifNotNil: [ :context | context tempAt: 1 ]
]

{ #category : #accessing }
GtRewriteDebugSession >> astSource [
	^ self ast ifNil: [ '' ] ifNotNil: [ :ast | ast sourceCode ]
]

{ #category : #accessing }
GtRewriteDebugSession >> context [
	^ self rule ifNotNil: [ :rule | rule context ]
]

{ #category : #accessing }
GtRewriteDebugSession >> executeTreeContext [
	| current |
	current := interruptedContext.
	[ current notNil
		and: [ (current selector = #executeTree:
				and: [ current receiver isKindOf: RBParseTreeRewriter ]) not ] ]
		whileTrue: [ current := current sender ].
	^ current
]

{ #category : #accessing }
GtRewriteDebugSession >> foundMatchContext [
	| current |
	current := interruptedContext.
	[ current notNil
		and: [ (current selector = #foundMatchFor:
				and: [ current receiver isKindOf: RBParseTreeRule ]) not ] ]
		whileTrue: [ current := current sender ].
	^ current
]

{ #category : #testing }
GtRewriteDebugSession >> isForMethod [
	^ self executeTreeContext
		ifNil: [ true ]
		ifNotNil: [ :context | (context tempAt: 1) isMethod ]
]

{ #category : #testing }
GtRewriteDebugSession >> isNodeContext: aContext [
	^ aContext selector = #copyInContext:
		and: [ aContext receiver isKindOf: RBProgramNode ]
]

{ #category : #testing }
GtRewriteDebugSession >> isPatternBlockContext: aContext [
	^ (aContext receiver isKindOf: RBPatternBlockNode)
		and: [ aContext method method = aContext receiver replacingBlock method method ]
]

{ #category : #testing }
GtRewriteDebugSession >> isValid [
	^ self foundMatchContext notNil
]

{ #category : #accessing }
GtRewriteDebugSession >> matchedNode [
	^ self foundMatchContext ifNotNil: [ :context | context tempAt: 1 ]
]

{ #category : #accessing }
GtRewriteDebugSession >> node [
	^ self nodeContext ifNotNil: [ :context | context receiver ]
]

{ #category : #accessing }
GtRewriteDebugSession >> nodeContext [
	| current |
	current := interruptedContext.
	[ current notNil and: [ (self isNodeContext: current) not ] ]
		whileTrue: [ current := current sender ].
	^ current
]

{ #category : #accessing }
GtRewriteDebugSession >> patternBlockContext [
	| current |
	current := interruptedContext.
	[ current notNil and: [ (self isPatternBlockContext: current) not ] ]
		whileTrue: [ (self isNodeContext: current) ifTrue: [ ^ nil ].
			current := current sender ].
	^ current
]

{ #category : #accessing }
GtRewriteDebugSession >> replaceTree [
	^ self rule
		ifNotNil: [ :rule | (rule isKindOf: RBStringReplaceRule) ifTrue: [ rule replaceTree ] ]
]

{ #category : #accessing }
GtRewriteDebugSession >> rule [
	^ self foundMatchContext ifNotNil: [ :context | context receiver ]
]

{ #category : #accessing }
GtRewriteDebugSession >> searchTree [
	^ self rule ifNotNil: [ :rule | rule searchTree ]
]

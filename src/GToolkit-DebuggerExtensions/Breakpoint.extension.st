Extension { #name : #Breakpoint }

{ #category : #'*GToolkit-DebuggerExtensions' }
Breakpoint >> breakInContext: aContext node: aNode [
	<debuggerCompleteToSender>
	<gtPharoPatch: #Pharo>
	
	| isHit shouldBreak |
	isHit := false.
	shouldBreak := false.
	
	"Running a method with a breakpoint from multiple processes can open multiple debuggers.
	https://github.com/feenkcom/gtoolkit/issues/5211"
	hitMutex
		critical: [ 
			self isEnabled
				ifTrue: [ 
					isHit := true.
					shouldBreak := true.
					self onCount ifTrue: [
						shouldBreak := self increaseCount = self breakOnCount ].
					(shouldBreak and: [ self once ]) ifTrue: [ self disable ] ] ].
	isHit ifFalse: [ ^ self ].
	
	"Only announce that the breakpoint was hit if it is enabled 
	https://github.com/feenkcom/gtoolkit/issues/5137"
	self class
		notifyBreakpointHit: self
		inContext: aContext
		node: aNode.
		
	shouldBreak ifFalse: [ ^ self ].
	
	Break break
]

{ #category : #'*GToolkit-DebuggerExtensions' }
Breakpoint >> initialize [

	self class initializeSlots: self.
	hitMutex := Mutex new.
	options := #(+ optionCompileOnLinkInstallation).
	BreakpointGroup newBreakpoint: self.
	group := BreakpointGroup ungroupedBreakpointsGroup
]

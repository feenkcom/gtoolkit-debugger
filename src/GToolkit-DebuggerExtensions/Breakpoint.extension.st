Extension { #name : #Breakpoint }

{ #category : #'*GToolkit-DebuggerExtensions' }
Breakpoint >> breakInContext: aContext node: aNode [
	 <debuggerCompleteToSender>
	 <gtPharoPatch: #Pharo>
	 
	 self isEnabled ifFalse: [ ^ self ].
	 
	 "Only announce that the breakpoint was hit if it is enabled https://github.com/feenkcom/gtoolkit/issues/5137"
	 self class notifyBreakpointHit: self inContext: aContext node: aNode.
	 
	 self onCount ifTrue: [ (self increaseCount = self breakOnCount) ifFalse: [^ self]].
	 self once ifTrue: [ self disable ].
	 Break break
]

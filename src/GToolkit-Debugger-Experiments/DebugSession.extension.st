Extension { #name : #DebugSession }

{ #category : #'*GToolkit-Debugger-Experiments' }
DebugSession >> stepToHomeThroughException: aContext [ 
	"Send messages until you return to selectedContext.
	 Used to step into a block in the method."
	aContext stepIntoQuickMethod: false.
	(self isContextPostMortem: aContext) ifTrue: [^ self].
	
	interruptedProcess stepToHomeThroughException: aContext.
	self updateContextTo: (self 
		stepToFirstInterestingBytecodeIn: interruptedProcess).
			
	self triggerEvent: #stepThrough
]

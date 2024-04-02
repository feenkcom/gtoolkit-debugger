Extension { #name : #Process }

{ #category : #'*GToolkit-Debugger-Experiments' }
Process >> stepToHomeThroughException: aContext [ 
	| blockClosureArguments callee ctxt pair error |
	
	blockClosureArguments := aContext argumentsForNextMessageSend
		select: [ :each | each class = FullBlockClosure ].
	
	callee := self step.
	callee == aContext ifTrue: [^ callee].
	
	blockClosureArguments do: [ :aBlockClosure |
		aBlockClosure 
			primitiveChangeClassTo: GtDebugStepThroughFullBlockClosure new ].
	
	ctxt := suspendedContext.
	suspendedContext := nil.
	
	pair := Processor activeProcess
		evaluate: [ ctxt runUntilErrorOrReturnFrom: callee ]
		onBehalfOf: self.
	suspendedContext := pair first.
	error := pair second.
	
	blockClosureArguments do: [ :aBlockClosure |
		aBlockClosure 
			primitiveChangeClassTo: FullBlockClosure new ].

	error ifNotNil: [
		error class = GtDebugStepThroughFromBlockClosureRequest
			ifTrue: [

				suspendedContext := error signalerContext.
				"suspendedContext push: nil"
				
				self stepToSendOrReturn.
				self step.
				suspendedContext privSender: suspendedContext sender sender.
				
				^ suspendedContext ].
		
		suspendedContext := error signalerContext ].
	^ suspendedContext
]

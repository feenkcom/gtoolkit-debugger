Extension { #name : #GtFilteredDebugSession }

{ #category : #'*GToolkit-Debugger-Experiments' }
GtFilteredDebugSession >> stepToHomeThroughException: aContext [
	super stepToHomeThroughException: aContext.
	self finishStep
]

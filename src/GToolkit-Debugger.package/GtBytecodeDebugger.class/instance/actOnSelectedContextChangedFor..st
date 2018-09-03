callbacks
actOnSelectedContextChangedFor: aContext
	super actOnSelectedContextChangedFor: aContext.
	self updateBytecodePaneFor: aContext.
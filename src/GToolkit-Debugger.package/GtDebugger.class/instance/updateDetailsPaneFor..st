updating
updateDetailsPaneFor: aContext
	| contextVariablesList |
	
	contextVariablesList := self createContextVariablesList.
	contextVariablesList display: aContext gtDebuggerRetrieveVariableValuePairs.
	
	self detailsPane 
		removeChildren;
		addChild: contextVariablesList.
	
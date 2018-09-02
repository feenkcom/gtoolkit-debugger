updating panes
updateDetailsPaneFor: aContext
	| contextVariablesList |
	
	contextVariablesList := self buildContextVariablesList.
	contextVariablesList display: aContext gtDebuggerRetrieveVariableValuePairs.
	
	self detailsPane 
		removeChildren;
		addChild: contextVariablesList.
	
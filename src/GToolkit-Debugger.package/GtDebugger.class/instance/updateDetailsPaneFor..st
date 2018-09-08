updating panes
updateDetailsPaneFor: aContext
	| contextVariablesList |
	
	contextVariablesList := self buildContextVariablesList.
	contextVariablesList display: (self variablesListForContext: aContext).
	
	self detailsPane 
		removeChildren;
		addChild: contextVariablesList.
	
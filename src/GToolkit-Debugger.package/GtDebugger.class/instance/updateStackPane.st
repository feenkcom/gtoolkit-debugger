updating panes
updateStackPane
	| tabGroup |

	stackElement := self buildStackElement.
	tabGroup := self buildStackTabGroupForElement: stackElement.
	
	self stackPane 
		removeChildren;
		addChild: tabGroup.
	self initializeStackTransmissions.
	self updateStackWidget.
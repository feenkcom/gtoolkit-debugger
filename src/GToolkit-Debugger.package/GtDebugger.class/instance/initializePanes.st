initialization
initializePanes
	stackPane := self buildPaneElement.
	codePane := self buildPaneElement
		border: (BlBorder paint: (BrGlamorousColors lightBorderColor)).
	detailsPane := self buildPaneElement.
	self addChildren: {stackPane . codePane . detailsPane}.
initialization
initializePanes
	stackPane := self buildPaneElement.
	codePane := self buildPaneElement.
	detailsPane := self buildPaneElement.
	self addChildren: {stackPane . codePane . detailsPane}.
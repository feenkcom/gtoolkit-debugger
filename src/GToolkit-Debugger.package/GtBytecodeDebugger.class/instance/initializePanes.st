initialization
initializePanes
	| secondPane |
	stackPane := self buildPaneElement.
	codePane := self buildPaneElement.
	bytecodesPane := self buildPaneElement.
	detailsPane := self buildPaneElement.
	
	secondPane := BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ].
	secondPane addChildren: {codePane. bytecodesPane}.
	
	self addChildren: {stackPane . secondPane . detailsPane}.
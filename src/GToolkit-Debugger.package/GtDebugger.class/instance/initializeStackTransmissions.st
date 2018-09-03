initialization
initializeStackTransmissions
	self stackElement stackFramesWidget
		when: BrSelectionChanged
		do: [ :anEvent | anEvent selectedDo: [ :anInterval |
			| anIndex anItemValue |
			anIndex := anInterval first.
			anItemValue := self stackElement stackFramesWidget items at: anIndex.
			self actOnSelectedContextChangedFor: anItemValue ] ]
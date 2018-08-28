initialization
initializeTransmissions
	self stackWidget stackFramesWidget
		when: BrSelectionChanged
		do: [ :anEvent | anEvent selectedDo: [ :anInterval |
				| anIndex anItemValue |
				anIndex := anInterval first.
				anItemValue := self stackWidget stackFramesWidget items at: anIndex.
				self updateCodePaneFor: anItemValue.
				self updateDetailsPaneFor: anItemValue ] ].
	
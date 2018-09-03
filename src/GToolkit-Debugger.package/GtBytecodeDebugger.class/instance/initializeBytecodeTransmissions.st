initialization
initializeBytecodeTransmissions
	self bytecodesListElement
		when: BrSelectionChanged
		do: [ :anEvent | anEvent selectedDo: [ :anInterval |
			| anIndex anItemValue |
			anIndex := anInterval first.
			anItemValue := self bytecodesListElement items at: anIndex.
			self actOnSelectedBytecodeChangedFor: anItemValue ] ]
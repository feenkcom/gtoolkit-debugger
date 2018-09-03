updating panes
updateBytecodePaneFor: aContext
	| bytecodeToSelect |
	bytecodesListElement := self buildBytecodesListElement.

	self bytecodesPane
		removeChildren;
		addChild: bytecodesListElement.
	self initializeBytecodeTransmissions.
	
	bytecodeToSelect := self session symbolicBytecodeForCurrentPCFrom: self currentContext.
	self bytecodesListElement display: aContext method symbolicBytecodes.
	self bytecodesListElement selectOne: (self bytecodesListElement items indexOf: bytecodeToSelect)
	
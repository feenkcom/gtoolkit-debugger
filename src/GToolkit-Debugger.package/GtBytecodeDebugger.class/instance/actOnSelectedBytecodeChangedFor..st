callbacks
actOnSelectedBytecodeChangedFor: aSymbolicBytecode
	| selectionForBytecode |
	selectionForBytecode := aSymbolicBytecode sourceInterval.
	self editorElement editor selecter
		overwrite;
		from: selectionForBytecode first - 1 to: selectionForBytecode last;
		withoutCursorUpdate;
		select
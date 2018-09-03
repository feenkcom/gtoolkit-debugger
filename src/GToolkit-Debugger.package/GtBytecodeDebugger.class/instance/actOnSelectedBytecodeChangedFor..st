callbacks
actOnSelectedBytecodeChangedFor: aSymbolicBytecode
	| selectionForBytecode |
	selectionForBytecode := aSymbolicBytecode sourceInterval.
	self editorElement editor selecter
		overwrite;
		from: selectionForBytecode first to: selectionForBytecode last;
		withoutCursorUpdate;
		select
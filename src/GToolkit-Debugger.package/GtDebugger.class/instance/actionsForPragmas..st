building actions
actionsForPragmas: aSymbolsCollection
	^ (self session class
		debuggingActionsForPragmas: aSymbolsCollection 
		for: self)
	
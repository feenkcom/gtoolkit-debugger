building actions
actionsForPragmas: aSymbolsCollection
	^ ("self session class " DebugSession
		debuggingActionsForPragmas: aSymbolsCollection 
		for: self)
	
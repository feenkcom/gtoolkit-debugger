adding elements
addGenericDebugger: aGenericDebugger
	genericDebugger := aGenericDebugger.
	debuggerContainer addChild: genericDebugger.
	debuggerContainer addChild: bytecodeDebuggerButton.			
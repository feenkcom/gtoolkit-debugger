actions
switchFrom: currentDebugger toDebuggerType: aDebuggerClass
	| currentSession newDebugger |
	
	currentSession := currentDebugger session.
	currentDebugger detachSession.
	newDebugger := aDebuggerClass new
		session: (aDebuggerClass spanNewSessionFrom: currentSession).	
	^ newDebugger
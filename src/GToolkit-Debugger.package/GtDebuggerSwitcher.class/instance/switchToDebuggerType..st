actions
switchToDebuggerType: aDebuggerClass
	| currentSession newDebugger |
	
	currentSession := self session.
	self detachSession.
	self browser close.
	currentSession updateContextTo: nil.
	newDebugger := aDebuggerClass new
		session: (aDebuggerClass spanNewSessionFrom: currentSession).
	
		
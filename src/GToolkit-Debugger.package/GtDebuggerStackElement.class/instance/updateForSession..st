updating
updateForSession: aDebuggingSession
	self stackFramesWidget display: (self retrieveStackFrom: aDebuggingSession).
	self stackFramesWidget selectOne: 1.
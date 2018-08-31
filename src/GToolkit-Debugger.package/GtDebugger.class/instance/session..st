accessing
session: aDebuggingSession
	debuggingSession := aDebuggingSession.
	self updateStackFor:  debuggingSession.
	self stackWidget updateForSession: debuggingSession.
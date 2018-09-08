instance creation
openInSwitcherOn: aDebuggingSession
	| switcher aDebugger aSpace |

	aDebugger := self new.
	aDebugger constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	aDebugger session: aDebuggingSession.
	
	switcher := GtDebuggerSwitcher new.
	switcher addGenericDebugger: aDebugger.
	switcher constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aDebuggingSession name.
	aSpace extent: 1200@600.
	aSpace addChild: switcher.
	aSpace show.
	
	^ switcher
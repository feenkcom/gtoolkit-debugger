instance creation
openOn: aDebuggingSession
	| aDebugger aSpace |

	aDebugger := self new.
	aDebugger constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	aDebugger session: aDebuggingSession.

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aDebuggingSession name.
	aSpace extent: 1200@600.
	aSpace addChild: aDebugger.
	aSpace show.
	
	^ aDebugger
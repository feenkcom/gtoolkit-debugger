instance creation
openSwitcherInInspectorOn: aDebuggingSession
	| switcher aDebugger anInspector aSpace |

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
	
	anInspector := GtInspector new.
	anInspector constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	anInspector addPageWithContent: switcher for: aDebuggingSession.

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: aDebuggingSession name.
	aSpace extent: 1200@600.
	aSpace addChild: anInspector.
	aSpace show.
	
	^ aDebugger
instance creation
openInspectorOn: aDebuggingSession
	| aDebugger anInspector aSpace |

	aDebugger := self new.
	aDebugger constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].
	aDebugger debuggingSession: aDebuggingSession.
	
	anInspector := GtInspector new.
	anInspector constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical matchParent ].

	anInspector addPageWithContent: aDebugger for: aDebuggingSession.

	aSpace := BlSpace new.
	aSpace withHalos.
	aSpace title: 'Debugger'.
	aSpace extent: 1200@600.
	aSpace addChild: anInspector.
	aSpace show.
	
	^ aDebugger
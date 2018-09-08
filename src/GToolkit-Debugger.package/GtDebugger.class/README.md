process ifNotNil: [process terminate].
context := [ '11211212' printString ] asContext.
process := Process
	forContext: context
	priority: Processor userInterruptPriority.	
debuggingSession := (process 
	newDebugSessionNamed: 'test debugging' 
	startedAt: process suspendedContext).
20 timesRepeat: [ 
	debuggingSession stepInto ].
GtDebugger openSwitcherInInspectorOn: debuggingSession.
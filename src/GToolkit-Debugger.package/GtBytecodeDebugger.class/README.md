process ifNotNil: [process terminate].
context := [ '11211212' printString ] asContext.
process := Process
	forContext: context
	priority: Processor userInterruptPriority.	
debuggingSession := GTBytecodeDebuggerSession 
	named: 'test debugging' 
	on: process 
	startedAt: process suspendedContext.
21 timesRepeat: [ 
	debuggingSession stepInto ].
GtBytecodeDebugger openInspectorOn: debuggingSession.

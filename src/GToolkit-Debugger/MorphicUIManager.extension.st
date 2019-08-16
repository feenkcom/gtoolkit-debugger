Extension { #name : #MorphicUIManager }

{ #category : #'*GToolkit-Debugger' }
MorphicUIManager >> gtDebugProcess: process context: context withEmbeddedDebuggerIn: sourceCoder forException: exception [
	"This is a copy of the standard method for opening the debugger with the difference that
	the embedeable debugger is opened instead of the standard one."
	| debugSession |

	debugSession := process newDebugSessionNamed: exception description startedAt: context.
	
	debugSession logStackToFileIfNeeded.
	debugSession isAboutUIProcess ifTrue: [ 
		DefaultExecutionEnvironment beActiveDuring: [self spawnNewProcess]].
	
	self defer:	[ 
			"Opened the embeddeable debugger instead of the default one."
		[ GtEmbeddedDebuggerElement   
				openOn: debugSession dueTo: exception embeddedIn: sourceCoder
		] on: Error do: [ :ex | 	debugSession signalDebuggerError: ex] 
	].
	
	process suspend.

]

Extension { #name : #MorphicUIManager }

{ #category : #'*GToolkit-Debugger' }
MorphicUIManager >> gtDebugProcess: process context: context label: title fullView: bool notification: notificationString [
	^ self 
		gtDebugProcess: process 
		context: context 
		label: title 
		fullView: bool 
		notification: notificationString 
		forException: nil
]

{ #category : #'*GToolkit-Debugger' }
MorphicUIManager >> gtDebugProcess: process context: context label: title fullView: bool notification: notificationString forException: anException [
	"Open a notifier in response to an error, halt, or notify. A notifier view
	just shows a short view of the sender stack and provides a menu that
	lets the user open a full debugger."

	| debugSession |

	debugSession := process newDebugSessionNamed: title startedAt: context.
	anException ifNotNil: [
		debugSession exception: anException ].
	debugSession logStackToFileIfNeeded.
	debugSession isAboutUIProcess ifTrue: [ 
		DefaultExecutionEnvironment beActiveDuring: [self spawnNewProcess]].
		
	self defer:	[ 
			"schedule debugger in deferred UI message to address
			redraw problems after opening a debugger e.g. from
			the testrunner."
		[ GtMoldableDebugger openInspectorOn: debugSession.
		] on: Error do: [ :ex | 	debugSession signalDebuggerError: ex] 
	].

	process suspend.
]

{ #category : #'*GToolkit-Debugger' }
MorphicUIManager >> gtDebugProcess: process context: context withEmbeddedDebuggerIn: aCoderRequesterObject withSourceString: aSourceString withSourceInterval: aSourceInterval forException: exception [
	"This is a copy of the standard method for opening the debugger with the difference that
	the embedeable debugger is opened instead of the standard one."

	| debugSession |
	debugSession := process
		newDebugSessionNamed: exception description
		startedAt: context.
	debugSession exception: exception.
	debugSession logStackToFileIfNeeded.
	debugSession isAboutUIProcess
		ifTrue:
			[ DefaultExecutionEnvironment beActiveDuring: [ self spawnNewProcess ] ].
	self
		defer: [ "Opened the embeddeable debugger instead of the default one."
			[ GtCoderEmbeddedDebuggerElement
				openOn: debugSession
				dueTo: exception
				embeddedIn: aCoderRequesterObject
				withSourceString: aSourceString
				withSourceInterval: aSourceInterval ]
				on: Error
				do: [ :ex | debugSession signalDebuggerError: ex ] ].
	process suspend
]

Extension { #name : #GtPhlowContext }

{ #category : #'*GToolkit-DebuggerExtensions' }
GtPhlowContext >> currentDebuggingSession [
	^ self 
		optionAt: #debuggingSession 
		ifAbsent: [ nil ]
]

{ #category : #'*GToolkit-DebuggerExtensions' }
GtPhlowContext >> currentDebuggingSession: aDebuggingSession [
	self 
		optionAt: #debuggingSession put: aDebuggingSession
]

{ #category : #'*GToolkit-DebuggerExtensions' }
GtPhlowContext >> isForDebugging [
	^ self hasOptionAt: #debuggingSession
]

Extension { #name : #GtPhlowContext }

{ #category : #'*GToolkit-DebuggerExtensions' }
GtPhlowContext >> currentDebugger [
	^ self 
		optionAt: #currentDebugger 
		ifAbsent: [ nil ]
]

{ #category : #'*GToolkit-DebuggerExtensions' }
GtPhlowContext >> currentDebugger: aDebuggerElement [
	self 
		optionAt: #currentDebugger put: aDebuggerElement
]

{ #category : #'*GToolkit-DebuggerExtensions' }
GtPhlowContext >> currentDebuggingSession [
	^ self 
		optionAt: #debuggingSession 
		ifPresent: [ :aDebugger | aDebugger debugSession ]
		ifAbsent: [ nil ]
]

{ #category : #'*GToolkit-DebuggerExtensions' }
GtPhlowContext >> isForDebugging [
	^ self hasOptionAt: #currentDebugger
]

Class {
	#name : #GtBytecodeDebuggerSession,
	#superclass : #DebugSession,
	#category : #'GToolkit-Debugger'
}

{ #category : #'debugging actions' }
GtBytecodeDebuggerSession >> runToBytecode: aSymbolicBytecode inContext: aContext [ 
	"Attempt to step over instructions in selectedContext until the 
	execution reaches the selected instruction. This happens when the
	program counter passes the begining of selectionInterval." 
	
	aSymbolicBytecode offset <= aContext pc 
		ifTrue: [ ^self ].
	self stepOver: aContext.
	[ aContext == self interruptedContext and: [ aContext pc < aSymbolicBytecode offset ] ] 
		whileTrue: [ self stepOver: aContext ]
]

{ #category : #private }
GtBytecodeDebuggerSession >> stepToFirstInterestingBytecodeIn: aProcess [
	"Do not step over any bytecode."
	
	^ aProcess suspendedContext
]

{ #category : #accessing }
GtBytecodeDebuggerSession >> symbolicBytecodeForCurrentPCFrom: aContext [
	| pc |
	
	pc := aContext pc.
	^ aContext compiledCode symbolicBytecodes 
		detect: [ :each | each offset = pc ]
		ifNone: [ nil ]
]

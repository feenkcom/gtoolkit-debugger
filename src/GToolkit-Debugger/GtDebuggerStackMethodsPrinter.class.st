"
I print the methods on a stack of (local) contexts, one per line: Receiver(MethodClass)>>selector, prefixed with '[] in ' for each block that encloses the executed code.

I print at most {{gtMethod:GtDebuggerStackMethodsPrinter>>#stackLimit|label=#selector}} frames, followed by a line indicating that more frames exist.

I am used by {{gtMethod:GtDebugSession>>#stackMethodsString}}. Examples: {{gtMethod:GtDebuggerContextMenuExamples>>#stackMethodsOfDebugSession}}, {{gtMethod:GtDebuggerContextMenuExamples>>#stackMethodsWithCustomLimit}}.
"
Class {
	#name : #GtDebuggerStackMethodsPrinter,
	#superclass : #Object,
	#instVars : [
		'stackLimit'
	],
	#category : #'GToolkit-Debugger-Session'
}

{ #category : #'accessing - defaults' }
GtDebuggerStackMethodsPrinter >> defaultStackLimit [
	^ 1000
]

{ #category : #initialization }
GtDebuggerStackMethodsPrinter >> initialize [
	super initialize.
	stackLimit := self defaultStackLimit
]

{ #category : #printing }
GtDebuggerStackMethodsPrinter >> printMethodOf: aContext on: aStream [
	"Print the method of aContext as Receiver(MethodClass)>>selector,
	prefixed with '[] in ' for each block that encloses the executed code"

	| aCompiledCode aReceiverClass aMethodClass |
	aCompiledCode := aContext method.
	[ aCompiledCode isCompiledBlock ]
		whileTrue: [ aStream nextPutAll: '[] in '.
			aCompiledCode := aCompiledCode outerCode ].	"Do not send #class to the receiver, as it can be a proxy"
	aReceiverClass := aContext objectClass: aContext receiver.
	aMethodClass := aCompiledCode methodClass.
	aStream nextPutAll: aReceiverClass name.
	aReceiverClass == aMethodClass
		ifFalse: [ aStream
				nextPut: $(;
				nextPutAll: aMethodClass name;
				nextPut: $) ].
	aStream
		nextPutAll: '>>';
		nextPutAll: aCompiledCode selector
]

{ #category : #printing }
GtDebuggerStackMethodsPrinter >> printStackOf: aContext [
	"Return the methods on the stack of aContext, one per line"

	^ String streamContents: [ :aStream | self printStackOf: aContext on: aStream ]
]

{ #category : #printing }
GtDebuggerStackMethodsPrinter >> printStackOf: aContext on: aStream [
	"Print the methods on the stack of aContext, one per line, for at most #stackLimit frames"

	| contexts |
	contexts := aContext stackOfSize: self stackLimit.
	contexts
		do: [ :eachContext | self printMethodOf: eachContext on: aStream ]
		separatedBy: [ aStream cr ].
	(contexts notEmpty and: [ contexts last sender notNil ])
		ifTrue: [ aStream
				cr;
				nextPutAll: '-- and more not shown --' ]
]

{ #category : #accessing }
GtDebuggerStackMethodsPrinter >> stackLimit [
	"Return the maximum number of stack frames that are printed"

	^ stackLimit
]

{ #category : #accessing }
GtDebuggerStackMethodsPrinter >> stackLimit: anInteger [
	stackLimit := anInteger
]

Class {
	#name : #GtScripterDebuggerBreakpointActionsExamples,
	#superclass : #Object,
	#traits : 'TGtScripterDebuggerExamples',
	#classTraits : 'TGtScripterDebuggerExamples classTrait',
	#instVars : [
		'theBreakpoint'
	],
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #testing }
GtScripterDebuggerBreakpointActionsExamples class >> isAbstract [
	^ self name = #GtScripterDebuggerBreakpointActionsExamples
]

{ #category : #'examples - debugger' }
GtScripterDebuggerBreakpointActionsExamples >> debuggerOnBreakpoint [
	<gtExample>
	<return: #BlScripter>
	
	self subclassResponsibility
]

{ #category : #'examples - support' }
GtScripterDebuggerBreakpointActionsExamples >> installBreakpointOnTargetMethod [
	| method messageNode |
	theBreakpoint ifNotNil: [ ^ theBreakpoint ].
	method := self class lookupSelector: #targetMethod_withBreakpointSend.
	messageNode := method ast sendNodes 
		detect: [:each | each selector = #factorial].
	theBreakpoint := Breakpoint new.
	theBreakpoint node: messageNode.
	theBreakpoint once: true.
	theBreakpoint install.
	^ theBreakpoint
]

{ #category : #'examples - support' }
GtScripterDebuggerBreakpointActionsExamples >> removeBreakpoint [
	theBreakpoint ifNotNil: [ :aBreakpoint |
		theBreakpoint := nil.
		aBreakpoint remove ]
]

{ #category : #'examples - support' }
GtScripterDebuggerBreakpointActionsExamples >> targetMethodCallingBreakpointSend [
	^ self targetMethod_withBreakpointSend
]

{ #category : #'examples - target' }
GtScripterDebuggerBreakpointActionsExamples >> targetMethod_withBreakpointSend [
	| x |
	x := 42 factorial.
	^ x
]

Class {
	#name : #BreakpointExamples,
	#superclass : #Object,
	#instVars : [
		'instVarA',
		'breakpoint'
	],
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #examples }
BreakpointExamples >> conditionBreakpoint [
	<gtExample>
	<after: #removeBreakpoint>
	| isHalted |
	breakpoint := Breakpoint new.
	breakpoint node: self methodWithBreakpointInstVarANode.
	breakpoint once: true.
	breakpoint condition: [ :aContext | aContext receiver == self ].
	breakpoint install.

	self
		assert: (Breakpoint isInstalledIn: self methodWithBreakpointCompiledMethod).
	self
		assert: (Breakpoint gtIsInstalledIn: self methodWithBreakpointCompiledMethod).

	isHalted := false.
	[ self class new methodWithBreakpoint ]
		on: Halt
		do: [ :anException | 
			isHalted := true.
			anException return ].

	self assert: isHalted not.

	[ self methodWithBreakpoint ]
		on: Halt
		do: [ :anException | 
			isHalted := true.
			anException return ].

	self assert: isHalted.

	^ breakpoint
]

{ #category : #'examples - demo' }
BreakpointExamples >> methodWithBreakpoint [
	^ instVarA
]

{ #category : #examples }
BreakpointExamples >> methodWithBreakpointCompiledMethod [
	<gtExample>
	^ self class >> #methodWithBreakpoint
]

{ #category : #examples }
BreakpointExamples >> methodWithBreakpointInstVarANode [
	<gtExample>
	| aNode |
	aNode := self methodWithBreakpointCompiledMethod ast allVariables anyOne.
	
	self assert: aNode isNotNil.
	self assert: aNode isVariable.
	self assert: aNode isInstanceVariable.
	self assert: aNode name equals: #instVarA.
	
	^ aNode
]

{ #category : #examples }
BreakpointExamples >> normalBreakpoint [
	<gtExample>
	<after: #removeBreakpoint>
	breakpoint := Breakpoint new.
	breakpoint node: self methodWithBreakpointInstVarANode.
	breakpoint once: true.
	breakpoint install.

	self
		assert: (Breakpoint isInstalledIn: self methodWithBreakpointCompiledMethod).
	self
		assert: (Breakpoint gtIsInstalledIn: self methodWithBreakpointCompiledMethod).

	^ breakpoint
]

{ #category : #examples }
BreakpointExamples >> objectBreakpoint [
	<gtExample>
	<after: #removeBreakpoint>
	| isHalted |
	breakpoint := Breakpoint new.
	breakpoint node: self methodWithBreakpointInstVarANode.
	breakpoint once: true.
	breakpoint scopeTo: self.
	breakpoint install.

	self
		assert: (Breakpoint isInstalledIn: self methodWithBreakpointCompiledMethod) not.

	self
		assert: (Breakpoint gtIsInstalledIn: self methodWithBreakpointCompiledMethod).

	isHalted := false.
	[ self class new methodWithBreakpoint ]
		on: Halt
		do: [ :anException | 
			isHalted := true.
			anException return ].
			
	self assert: isHalted not.
	
	[ self methodWithBreakpoint ]
		on: Halt
		do: [ :anException | 
			isHalted := true.
			anException return ].

	self assert: isHalted.

	^ breakpoint
]

{ #category : #after }
BreakpointExamples >> removeBreakpoint [
	breakpoint ifNotNil: [ :aBreakpoint | aBreakpoint remove ]
]

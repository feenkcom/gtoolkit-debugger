Class {
	#name : #GtPharoStackModelExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtPharoStackModelExamples >> createStackModel [
	<gtExample>
	<return: #GtDebuggerPharoStackModel>
	| context debuggingSession process |
	context := [ self testMethod1 ] asContext.
	process := Process
			forContext: context
			priority: Processor userInterruptPriority.
	debuggingSession := DebugSession
			named: 'Debug'
			on: process
			startedAt: process suspendedContext.
	4 timesRepeat: [ debuggingSession stepInto ].
	^ GtDebuggerPharoStackModel onSession: debuggingSession
]

{ #category : #accessing }
GtPharoStackModelExamples >> stepOutOfTestMethod3InModel: model [
	| session |
	session := model session.
	session
		stepIntoUntil: [ :context | context method ~= (self class >> #testMethod3) ].
	model updateBasedOnCurentSession
]

{ #category : #accessing }
GtPharoStackModelExamples >> testMethod1 [
	self testMethod2
]

{ #category : #accessing }
GtPharoStackModelExamples >> testMethod2 [
	self testMethod3
]

{ #category : #accessing }
GtPharoStackModelExamples >> testMethod3 [
	^42
]

{ #category : #accessing }
GtPharoStackModelExamples >> testStackModelCoderViewModelStream [
	<gtExample>
	<return: #GtDebuggerPharoStackModel>
	| model stream |
	model := self createStackModel.
	stream := model coderViewModelStream.
	self
		assert: stream next wait value compiledMethod
		equals: self class >> #testMethod3.
	self
		assert: stream next wait value compiledMethod
		equals: self class >> #testMethod2.
	self
		assert: stream next wait value compiledMethod
		equals: self class >> #testMethod1.
	^ model
]

{ #category : #accessing }
GtPharoStackModelExamples >> testStackModelCoderViewModelStreamIndependence [
	"Test that streams are independent"

	<gtExample>
	<return: #GtPharoStackModelExamples>
	| model stream |
	model := self testStackModelCoderViewModelStream.
	2
		timesRepeat: [ stream := model coderViewModelStream.
			self
				assert: stream next wait value compiledMethod
				equals: self class >> #testMethod3.
			self
				assert: stream next wait value compiledMethod
				equals: self class >> #testMethod2.
			self
				assert: stream next wait value compiledMethod
				equals: self class >> #testMethod1 ]
]

{ #category : #accessing }
GtPharoStackModelExamples >> testStackModelContextStream [
	<gtExample>
	<return: #GtDebuggerPharoStackModel>
	| model stream |
	model := self createStackModel.
	stream := model contextStream.
	self assert: stream next wait value method equals: self class >> #testMethod3.
	self assert: stream next wait value method equals: self class >> #testMethod2.
	self assert: stream next wait value method equals: self class >> #testMethod1.
	^ model
]

{ #category : #accessing }
GtPharoStackModelExamples >> testStackModelContextStreamIndependence [
	"Test that streams are independent"

	<gtExample>
	<return: #GtPharoStackModelExamples>
	| model stream |
	model := self testStackModelContextStream.
	2
		timesRepeat: [ stream := model contextStream.
			self assert: stream next wait value method equals: self class >> #testMethod3.
			self assert: stream next wait value method equals: self class >> #testMethod2.
			self assert: stream next wait value method equals: self class >> #testMethod1 ]
]

{ #category : #accessing }
GtPharoStackModelExamples >> testStep [
	<gtExample>
	<return: #GtPharoStackModelExamples>
	| model stream |
	model := self createStackModel.
	self stepOutOfTestMethod3InModel: model.
	stream := model contextStream.
	self assert: stream next wait value method equals: self class >> #testMethod2.
	self assert: stream next wait value method equals: self class >> #testMethod1
]

{ #category : #accessing }
GtPharoStackModelExamples >> testStepWithCoderViewModels [
	"Test to see if CoderViewModels are cached"

	<gtExample>
	<return: #GtPharoStackModelExamples>
	| model originalCoderViewModels currentCoderViewModels |
	model := self createStackModel.
	originalCoderViewModels := model coderViewModelStream toArray wait.
	self stepOutOfTestMethod3InModel: model.
	currentCoderViewModels := model coderViewModelStream toArray wait.
	self
		assert: originalCoderViewModels size - currentCoderViewModels size
		equals: 1.
	2
		to: originalCoderViewModels size
		do: [ :i | 
			self
				assert: (originalCoderViewModels at: i) == (currentCoderViewModels at: i - 1) ]
]

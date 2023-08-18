"
An example of an exception that defined debugging views in other domain objects through a custom debugging configuration ({{gtMethod:GtExampleExceptionWithForwardedDebuggingView>>gtDebuggingExtensionConfiguration|label=#selector}}).

The following examples creates an example instance of the exception:
{{gtExample:GtExceptionsWithExtensionsExamples>>exampleExceptionWithForwardedDebuggingViews}}
"
Class {
	#name : #GtExampleExceptionWithForwardedDebuggingView,
	#superclass : #Exception,
	#instVars : [
		'objectOne',
		'objectTwo',
		'objectThree'
	],
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #signals }
GtExampleExceptionWithForwardedDebuggingView class >> signalWithDomainData [
	^ self new 
		initializeWithDomainData;
		signal
]

{ #category : #accessing }
GtExampleExceptionWithForwardedDebuggingView >> gtDebuggingExtensionConfiguration [
	"Create a debugging configuration that add three extra domain
	objects where to look for debugging views, and that only enables
	the debugging extension if any of the three debugging objects has data."
	
	^ super gtDebuggingExtensionConfiguration
		addDebuggingTargetFor: self objectOne;
		addDebuggingTargetFor: self objectTwo;
		addDebuggingTargetFor: self objectThree;
		enableDebuggingViewExtension: [ 
			self objectOne hasData or: [
				self objectTwo hasData or: [
					self objectThree hasData ] ] ] 
]

{ #category : #initialization }
GtExampleExceptionWithForwardedDebuggingView >> initializeWithDomainData [
	self objectOne: (GtExampleExceptionDomainObjectWithDebuggingView new
		message: 'I am a message comming from a domain object stored by the exception').
	self objectTwo: (GtExampleExceptionDomainObjectWithDebuggingView new
		collection: (1 to: 10) asOrderedCollection).
	self objectThree: (GtExampleExceptionDomainObjectWithDebuggingView new
		dictionary: {
			'one' -> 1.
			'two' -> 2.
			'three' -> 3.
			'four' -> 4.
		} asOrderedDictionary).
]

{ #category : #accessing }
GtExampleExceptionWithForwardedDebuggingView >> objectOne [
	^ objectOne
]

{ #category : #accessing }
GtExampleExceptionWithForwardedDebuggingView >> objectOne: anObject [
	objectOne := anObject
]

{ #category : #accessing }
GtExampleExceptionWithForwardedDebuggingView >> objectThree [
	^ objectThree
]

{ #category : #accessing }
GtExampleExceptionWithForwardedDebuggingView >> objectThree: anObject [
	objectThree := anObject
]

{ #category : #accessing }
GtExampleExceptionWithForwardedDebuggingView >> objectTwo [
	^ objectTwo
]

{ #category : #accessing }
GtExampleExceptionWithForwardedDebuggingView >> objectTwo: anObject [
	objectTwo := anObject
]

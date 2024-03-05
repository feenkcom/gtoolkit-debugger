"
{{gtClass:GtMoldableExceptionDebugingExtensionConfiguration}} allows exceptions to configure a domain-specific debugger shown when the exception is raised.

The domain-specific debugger uses this configuration to locate debugging views and actions specific to an exception.

The main API methods for configuring the debugger are:
	- {{gtMethod:name=GtMoldableExceptionDebugingExtensionConfiguration>>debuggingViewPragmas:|label=#selector}} - by default `<gtExceptionDebuggingView>` is used {{gtMethod:name=GtMoldableExceptionDebugingExtensionConfiguration>>defaultDebuggingViewPragmaNames|label=#selector}}
	- {{gtMethod:name=GtMoldableExceptionDebugingExtensionConfiguration>>globalDebuggingActionPragmas:|label=#selector}} - there is no default value as this looks for global actions that subclass {{gtClass:DebugAction}}; each exception should use a different pragma for defining its global values
	- {{gtMethod:GtMoldableExceptionDebugingExtensionConfiguration>>enableDebuggingViewExtension:|label=#selector}} - by default all exceptions have the attached domain-specific debugger enabled
	- {{gtMethod:name=GtMoldableExceptionDebugingExtensionConfiguration>>withDebuggingExceptionTargetFor:|label=#selector}} 
	- {{gtMethod:name=GtMoldableExceptionDebugingExtensionConfiguration>>withoutDebuggingExceptionTarget|label=#selector}}
	- {{gtMethod:name=GtMoldableExceptionDebugingExtensionConfiguration>>addDebuggingTargetFor:|label=#selector}}
	
To instantiate the configuration  {{gtMethod:GtMoldableExceptionDebuggingToolConfiguration class>>forException:}} is used, which  for {{gtClass:GtMoldableExceptionDebugingExtensionConfiguration}} adds by default the current exception as a target for looking for views.
"
Class {
	#name : #GtMoldableExceptionDebuggingExtensionConfiguration,
	#superclass : #GtMoldableExceptionDebuggerConfiguration,
	#instVars : [
		'debuggingViewPragmaNames',
		'globalDebuggingActionPragmaNames',
		'enableDebuggingViewExtensionComputation',
		'debuggingTargets'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #configuration }
GtMoldableExceptionDebuggingExtensionConfiguration >> addDebuggingTargetFor: anObject [
	"Add a debugging target used to look for debugging views. It is possible to register multiple target objects, apart from the exception object."
	debuggingTargets addDebuggingTargetFor: anObject
]

{ #category : #testing }
GtMoldableExceptionDebuggingExtensionConfiguration >> canShowDebuggingExtension [
	^ self enableDebuggingViewExtension and: [
		self debuggingViewPragmas notEmpty and: [
			self hasDebuggingViewMethods ] ] 
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggingExtensionConfiguration >> collectTargetDebuggingViews [
	^ debuggingTargets collectTargetDebuggingViewsForPragmaNames: self debuggingViewPragmas
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggingExtensionConfiguration >> debuggingViewPragmas [
	^ debuggingViewPragmaNames ifNil: [
		self defaultDebuggingViewPragmaNames ]
]

{ #category : #configuration }
GtMoldableExceptionDebuggingExtensionConfiguration >> debuggingViewPragmas: aCollection [
	"Configure the list of pragmas used to look for debugging views."
	debuggingViewPragmaNames := aCollection
]

{ #category : #'accessing - defaults' }
GtMoldableExceptionDebuggingExtensionConfiguration >> defaultDebuggingViewPragmaNames [
	^ #(gtExceptionDebuggingView)
]

{ #category : #'accessing - defaults' }
GtMoldableExceptionDebuggingExtensionConfiguration >> defaultEnableDebuggingViewExtensionComputation [
	^ [ true ]
]

{ #category : #'accessing - defaults' }
GtMoldableExceptionDebuggingExtensionConfiguration >> defaultGlobalDebuggingActionPragmas [
	^ #()
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggingExtensionConfiguration >> enableDebuggingViewExtension [
	^ self enableDebuggingViewExtensionComputation value
]

{ #category : #configuration }
GtMoldableExceptionDebuggingExtensionConfiguration >> enableDebuggingViewExtension: aBlock [
	"Configure the block used to determine is to enable the domain-specific debugger associated with this exception."
	enableDebuggingViewExtensionComputation := aBlock
]

{ #category : #utils }
GtMoldableExceptionDebuggingExtensionConfiguration >> enableDebuggingViewExtensionComputation [
	^ enableDebuggingViewExtensionComputation ifNil: [
		self defaultEnableDebuggingViewExtensionComputation]
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggingExtensionConfiguration >> globalDebuggingActionPragmas [
	^ globalDebuggingActionPragmaNames ifNil: [
		self defaultGlobalDebuggingActionPragmas ]
]

{ #category : #configuration }
GtMoldableExceptionDebuggingExtensionConfiguration >> globalDebuggingActionPragmas: aCollection [
	"Configure the pragmas used to look for global debugging actions. These actions are specific to the exception."
	globalDebuggingActionPragmaNames := aCollection
]

{ #category : #testing }
GtMoldableExceptionDebuggingExtensionConfiguration >> hasDebuggingViewMethods [
	^ debuggingTargets hasDebuggingViewMethodsWithPragmaNames: self debuggingViewPragmas
]

{ #category : #initialization }
GtMoldableExceptionDebuggingExtensionConfiguration >> initialize [
	super initialize.
	
	debuggingTargets := GtMoldableExceptionDebuggingViewTargets new
]

{ #category : #initialization }
GtMoldableExceptionDebuggingExtensionConfiguration >> initializeForException: anException [
	super initializeForException: anException.
	
	self withDebuggingExceptionTargetFor: anException
]

{ #category : #configuration }
GtMoldableExceptionDebuggingExtensionConfiguration >> withDebuggingExceptionTargetFor: aTargetException [
	"Use the given exception to look for debugging views"
	debuggingTargets withDebuggingExceptionTargetFor: aTargetException
]

{ #category : #configuration }
GtMoldableExceptionDebuggingExtensionConfiguration >> withoutDebuggingExceptionTarget [
	"Indicate that the current exception should not be used for looking for debugging views"
	debuggingTargets withoutDebuggingExceptionTarget
]

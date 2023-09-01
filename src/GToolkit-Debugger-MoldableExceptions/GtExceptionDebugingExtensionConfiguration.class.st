"
{{gtClass:GtExceptionDebugingExtensionConfiguration}} allows exceptions to configure a domain-specific debugger shown when the exception is raised.

The domain-specific debugger uses this configuration to locate debugging views and actions specific to an exception.

The main API methods for configuring the debugger are:
	- {{gtMethod:name=GtExceptionDebugingExtensionConfiguration>>debuggingViewPragmas:|label=#selector}} - by default `<gtExceptionDebuggingView>` is used {{gtMethod:name=GtExceptionDebugingExtensionConfiguration>>defaultDebuggingViewPragmaNames|label=#selector}}
	- {{gtMethod:name=GtExceptionDebugingExtensionConfiguration>>globalDebuggingActionPragmas:|label=#selector}} - there is no default value as this looks for global actions that subclass {{gtClass:DebugAction}}; each exception should use a different pragma for defining its global values
	- {{gtMethod:GtExceptionDebugingExtensionConfiguration>>enableDebuggingViewExtension:|label=#selector}} - by default all exceptions have the attached domain-specific debugger enabled
	- {{gtMethod:name=GtExceptionDebugingExtensionConfiguration>>withDebuggingExceptionTargetFor:|label=#selector}} 
	- {{gtMethod:name=GtExceptionDebugingExtensionConfiguration>>withoutDebuggingExceptionTarget|label=#selector}}
	- {{gtMethod:name=GtExceptionDebugingExtensionConfiguration>>addDebuggingTargetFor:|label=#selector}}
	
To instantiate the configuration  {{gtMethod:GtExceptionDebugingExtensionConfiguration class>>forException:}} is used, which adds by default the current exception as a target for looking for views.
"
Class {
	#name : #GtExceptionDebugingExtensionConfiguration,
	#superclass : #Object,
	#instVars : [
		'debuggingViewPragmaNames',
		'globalDebuggingActionPragmaNames',
		'enableDebuggingViewExtensionComputation',
		'debuggingTargets'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'instace creation' }
GtExceptionDebugingExtensionConfiguration class >> forException: anException [
	^ self new
		 withDebuggingExceptionTargetFor: anException
]

{ #category : #configuration }
GtExceptionDebugingExtensionConfiguration >> addDebuggingTargetFor: anObject [
	"Add a debugging target used to look for debugging views. It is possible to register multiple target objects, apart from the exception object."
	debuggingTargets addDebuggingTargetFor: anObject
]

{ #category : #testing }
GtExceptionDebugingExtensionConfiguration >> canShowDebuggingExtension [
	^ self enableDebuggingViewExtension and: [
		self debuggingViewPragmas notEmpty and: [
			self hasDebuggingViewMethods ] ] 
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingExtensionConfiguration >> collectTargetDebuggingViews [
	^ debuggingTargets collectTargetDebuggingViewsForPragmaNames: self debuggingViewPragmas
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingExtensionConfiguration >> debuggingViewPragmas [
	^ debuggingViewPragmaNames ifNil: [
		self defaultDebuggingViewPragmaNames ]
]

{ #category : #configuration }
GtExceptionDebugingExtensionConfiguration >> debuggingViewPragmas: aCollection [
	"Configure the list of pragmas used to look for debugging views."
	debuggingViewPragmaNames := aCollection
]

{ #category : #'accessing - defaults' }
GtExceptionDebugingExtensionConfiguration >> defaultDebuggingViewPragmaNames [
	^ #(gtExceptionDebuggingView)
]

{ #category : #'accessing - defaults' }
GtExceptionDebugingExtensionConfiguration >> defaultEnableDebuggingViewExtensionComputation [
	^ [ true ]
]

{ #category : #'accessing - defaults' }
GtExceptionDebugingExtensionConfiguration >> defaultGlobalDebuggingActionPragmas [
	^ #()
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingExtensionConfiguration >> enableDebuggingViewExtension [
	^ self enableDebuggingViewExtensionComputation value
]

{ #category : #configuration }
GtExceptionDebugingExtensionConfiguration >> enableDebuggingViewExtension: aBlock [
	"Configure the block used to determine is to enable the domain-specific debugger associated with this exception."
	enableDebuggingViewExtensionComputation := aBlock
]

{ #category : #utils }
GtExceptionDebugingExtensionConfiguration >> enableDebuggingViewExtensionComputation [
	^ enableDebuggingViewExtensionComputation ifNil: [
		self defaultEnableDebuggingViewExtensionComputation]
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingExtensionConfiguration >> globalDebuggingActionPragmas [
	^ globalDebuggingActionPragmaNames ifNil: [
		self defaultGlobalDebuggingActionPragmas ]
]

{ #category : #configuration }
GtExceptionDebugingExtensionConfiguration >> globalDebuggingActionPragmas: aCollection [
	"Configure the pragmas used to look for global debugging actions. These actions are specific to the exception."
	globalDebuggingActionPragmaNames := aCollection
]

{ #category : #testing }
GtExceptionDebugingExtensionConfiguration >> hasDebuggingViewMethods [
	^ debuggingTargets hasDebuggingViewMethodsWithPragmaNames: self debuggingViewPragmas
]

{ #category : #initialization }
GtExceptionDebugingExtensionConfiguration >> initialize [
	super initialize.
	
	debuggingTargets := GtExceptionDebuggingViewTargets new
]

{ #category : #configuration }
GtExceptionDebugingExtensionConfiguration >> withDebuggingExceptionTargetFor: aTargetException [
	"Use the given exception to look for debugging views"
	debuggingTargets withDebuggingExceptionTargetFor: aTargetException
]

{ #category : #configuration }
GtExceptionDebugingExtensionConfiguration >> withoutDebuggingExceptionTarget [
	"Indicate that the current exception should not be used for looking for debugging views"
	debuggingTargets withoutDebuggingExceptionTarget
]

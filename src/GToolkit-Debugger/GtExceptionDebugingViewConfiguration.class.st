"
{{gtClass:GtExceptionDebugingViewConfiguration}} allows exceptions to configure a domain-specific debugger shown when the exception is raised.

The domain-specific debugger uses this configuration to locate debugging views and actions specific to an exception.

The main API methods for configuring the debugger are:
	- {{gtMethod:name=GtExceptionDebugingViewConfiguration>>debuggingViewPragmas:|label=#selector}} - by default `<gtExceptionDebuggingView>` is used {{gtMethod:name=GtExceptionDebugingViewConfiguration>>defaultDebuggingViewPragmaNames|label=#selector}}
	- {{gtMethod:name=GtExceptionDebugingViewConfiguration>>globalDebuggingActionPragmas:|label=#selector}} - there is no default value as this looks for global actions that subclass {{gtClass:DebugAction}}; each exception should use a different pragma for defining its global values
	- {{gtMethod:GtExceptionDebugingViewConfiguration>>enableDebuggingViewExtension:|label=#selector}} - by default all exceptions have the attached domain-specific debugger enabled
	- {{gtMethod:name=GtExceptionDebugingViewConfiguration>>withDebuggingExceptionTargetFor:|label=#selector}} 
	- {{gtMethod:name=GtExceptionDebugingViewConfiguration>>withoutDebuggingExceptionTarget|label=#selector}}
	- {{gtMethod:name=GtExceptionDebugingViewConfiguration>>addDebuggingTargetFor:|label=#selector}}
	
To instantiate the configuration  {{gtMethod:GtExceptionDebugingViewConfiguration class>>forException:}} is used, which adds by default the current exception as a target for looking for views.
"
Class {
	#name : #GtExceptionDebugingViewConfiguration,
	#superclass : #Object,
	#instVars : [
		'debuggingViewPragmaNames',
		'globalDebuggingActionPragmaNames',
		'enableDebuggingViewExtensionComputation',
		'debuggingTargets'
	],
	#category : #'GToolkit-Debugger-Models'
}

{ #category : #'*GToolkit-Debugger' }
GtExceptionDebugingViewConfiguration class >> forException: anException [
	^ self new
		 withDebuggingExceptionTargetFor: anException
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> addDebuggingTargetFor: anObject [
	"Add a debugging target used to look for debugging views. It is possible to register multiple target objects, apart from the exception object."
	debuggingTargets addDebuggingTargetFor: anObject
]

{ #category : #testing }
GtExceptionDebugingViewConfiguration >> canShowDebuggingExtension [
	^ self enableDebuggingViewExtension and: [
		self debuggingViewPragmas notEmpty and: [
			self hasDebuggingViewMethods ] ] 
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingViewConfiguration >> collectTargetDebuggingViews [
	^ debuggingTargets collectTargetDebuggingViewsForPragmaNames: self debuggingViewPragmas
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingViewConfiguration >> debuggingViewPragmas [
	^ debuggingViewPragmaNames ifNil: [
		self defaultDebuggingViewPragmaNames ]
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> debuggingViewPragmas: aCollection [
	"Configure the list of pragmas used to look for debugging views."
	debuggingViewPragmaNames := aCollection
]

{ #category : #'accessing - defaults' }
GtExceptionDebugingViewConfiguration >> defaultDebuggingViewPragmaNames [
	^ #(gtExceptionDebuggingView)
]

{ #category : #'accessing - defaults' }
GtExceptionDebugingViewConfiguration >> defaultEnableDebuggingViewExtensionComputation [
	^ [ true ]
]

{ #category : #'accessing - defaults' }
GtExceptionDebugingViewConfiguration >> defaultGlobalDebuggingActionPragmas [
	^ #()
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingViewConfiguration >> enableDebuggingViewExtension [
	^ self enableDebuggingViewExtensionComputation value
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> enableDebuggingViewExtension: aBlock [
	"Configure the block used to determine is to enable the domain-specific debugger associated with this exception."
	enableDebuggingViewExtensionComputation := aBlock
]

{ #category : #utils }
GtExceptionDebugingViewConfiguration >> enableDebuggingViewExtensionComputation [
	^ enableDebuggingViewExtensionComputation ifNil: [
		self defaultEnableDebuggingViewExtensionComputation]
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingViewConfiguration >> globalDebuggingActionPragmas [
	^ globalDebuggingActionPragmaNames ifNil: [
		self defaultGlobalDebuggingActionPragmas ]
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> globalDebuggingActionPragmas: aCollection [
	"Configure the pragmas used to look for global debugging actions. These actions are specific to the exception."
	globalDebuggingActionPragmaNames := aCollection
]

{ #category : #testing }
GtExceptionDebugingViewConfiguration >> hasDebuggingViewMethods [
	^ debuggingTargets hasDebuggingViewMethodsWithPragmaNames: self debuggingViewPragmas
]

{ #category : #initialization }
GtExceptionDebugingViewConfiguration >> initialize [
	super initialize.
	
	debuggingTargets := GtExceptionDebuggingViewTargets new
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> withDebuggingExceptionTargetFor: aTargetException [
	"Use the given exception to look for debugging views"
	debuggingTargets withDebuggingExceptionTargetFor: aTargetException
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> withoutDebuggingExceptionTarget [
	"Indicate that the current exception should not be used for looking for debugging views"
	debuggingTargets withoutDebuggingExceptionTarget
]

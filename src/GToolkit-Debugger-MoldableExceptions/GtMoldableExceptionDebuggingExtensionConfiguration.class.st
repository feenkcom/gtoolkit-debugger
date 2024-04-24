"
{{gtClass:GtMoldableExceptionDebuggingExtensionConfiguration}} allows exceptions to configure a domain-specific debugger shown when the exception is raised.

The domain-specific debugger uses this configuration to locate debugging views and actions specific to an exception.

The main API methods for configuring the debugger are:
	- {{gtMethod:name=GtMoldableExceptionDebuggingExtensionConfiguration>>debuggingViewPragmas:|label=#selector}} - by default `<gtExceptionDebuggingView>` is used {{gtMethod:name=GtMoldableExceptionDebuggingExtensionConfiguration>>defaultDebuggingViewPragmaNames|label=#selector}}
	- {{gtMethod:name=GtMoldableExceptionDebuggerConfiguration>>globalDebuggingActionPragmas:|label=#selector}} - there is no default value as this looks for global actions that subclass {{gtClass:DebugAction}}; each exception should use a different pragma for defining its global values
	- {{gtMethod:GtMoldableExceptionDebuggingExtensionConfiguration>>enableDebuggingViewExtension:|label=#selector}} - by default all exceptions have the attached domain-specific debugger enabled
	- {{gtMethod:name=GtMoldableExceptionDebuggerConfiguration>>withDebuggingExceptionTargetFor:|label=#selector}} 
	- {{gtMethod:name=GtMoldableExceptionDebuggerConfiguration>>withoutDebuggingExceptionTarget|label=#selector}}
	- {{gtMethod:name=GtMoldableExceptionDebuggerConfiguration>>addDebuggingTargetFor:|label=#selector}}
	
To instantiate the configuration  {{gtMethod:GtMoldableExceptionDebuggingToolConfiguration class>>forException:}} is used, which  for {{gtClass:GtMoldableExceptionDebuggingExtensionConfiguration}} adds by default the current exception as a target for looking for views.
"
Class {
	#name : #GtMoldableExceptionDebuggingExtensionConfiguration,
	#superclass : #GtMoldableExceptionDebuggerConfiguration,
	#instVars : [
		'enableDebuggingViewExtensionComputation',
		'debuggingViewPragmaNames'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #testing }
GtMoldableExceptionDebuggingExtensionConfiguration >> canShowDebuggingExtension [
	^ self enableDebuggingViewExtension and: [
		self debuggingViewPragmas notEmpty and: [
			self hasDebuggingViewMethods ] ] 
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggingExtensionConfiguration >> collectTargetDebuggingViewsForDebugger: aDebugger in: aComposite [
	^ debuggingTargets 
		collectTargetDebuggingViewsForPragmaNames: self debuggingViewPragmas
		in: aComposite
		forDebugger: aDebugger
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggingExtensionConfiguration >> debuggingViewPragmas [
	^ debuggingViewPragmaNames ifNil: [
		self defaultDebuggingViewPragmaNames ]
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionDebuggingExtensionConfiguration >> debuggingViewPragmas: aCollection [
	"Configure the list of pragmas used to look for debugging views."
	debuggingViewPragmaNames := aCollection
]

{ #category : #accessing }
GtMoldableExceptionDebuggingExtensionConfiguration >> defaultDebuggingViewPragmaNames [
	^ #(gtExceptionView)
]

{ #category : #'accessing - defaults' }
GtMoldableExceptionDebuggingExtensionConfiguration >> defaultEnableDebuggingViewExtensionComputation [
	^ [ true ]
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
		self defaultEnableDebuggingViewExtensionComputation ]
]

{ #category : #testing }
GtMoldableExceptionDebuggingExtensionConfiguration >> hasDebuggingViewMethods [
	^ debuggingTargets hasDebuggingViewMethodsWithPragmaNames: self debuggingViewPragmas
]

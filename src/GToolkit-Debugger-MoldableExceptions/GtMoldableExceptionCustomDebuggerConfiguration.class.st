"
{{gtClass:GtMoldableExceptionCustomDebuggerConfiguration}} allows exceptions to configure a domain-specific debugger shown when the exception is raised.

The domain-specific debugger uses this configuration to locate debugging views and actions specific to an exception.

The main API methods for configuring the debugger are:
	- {{gtMethod:name=GtMoldableExceptionCustomDebuggerConfiguration>>debuggingViewPragmas:|label=#selector}} - by default `<gtExceptionDebuggingView>` is used {{gtMethod:name=GtMoldableExceptionCustomDebuggerConfiguration>>defaultDebuggingViewPragmaNames|label=#selector}}
	- {{gtMethod:name=GtMoldableExceptionDebuggerConfiguration>>globalDebuggingActionPragmas:|label=#selector}} - there is no default value as this looks for global actions that subclass {{gtClass:DebugAction}}; each exception should use a different pragma for defining its global values
	- {{gtMethod:GtMoldableExceptionCustomDebuggerConfiguration>>enableDebuggingViewExtension:|label=#selector}} - by default all exceptions have the attached domain-specific debugger enabled
	- {{gtMethod:name=GtMoldableExceptionDebuggerConfiguration>>withDebuggingExceptionTargetFor:|label=#selector}} 
	- {{gtMethod:name=GtMoldableExceptionDebuggerConfiguration>>withoutDebuggingExceptionTarget|label=#selector}}
	- {{gtMethod:name=GtMoldableExceptionDebuggerConfiguration>>addDebuggingTargetFor:|label=#selector}}
	
To instantiate the configuration  {{gtMethod:GtMoldableExceptionDebuggerConfiguration class>>forException:}} is used, which  for {{gtClass:GtMoldableExceptionCustomDebuggerConfiguration}} adds by default the current exception as a target for looking for views.
"
Class {
	#name : #GtMoldableExceptionCustomDebuggerConfiguration,
	#superclass : #GtMoldableExceptionDebuggerConfiguration,
	#instVars : [
		'enableDebuggingViewExtensionComputation',
		'debuggingViewPragmaNames',
		'availableAutomatically',
		'activationPredicate',
		'debuggerIcon',
		'debuggerTitle',
		'sessionClass',
		'debuggerPriority'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> availableAutomatically [
	^ availableAutomatically
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> availableAutomatically: aBoolean [
	availableAutomatically := aBoolean
]

{ #category : #testing }
GtMoldableExceptionCustomDebuggerConfiguration >> canShowDebuggingExtension [
	^ self enableDebuggingViewExtension and: [
		self debuggingViewPragmas notEmpty and: [
			self hasDebuggingViewMethods ] ] 
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionCustomDebuggerConfiguration >> collectTargetDebuggingViewsForDebugger: aDebugger in: aComposite [
	^ debuggingTargets 
		collectTargetDebuggingViewsForPragmaNames: self debuggingViewPragmas
		in: aComposite
		forDebugger: aDebugger
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> debuggerIcon [
	^ debuggerIcon  
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> debuggerIcon: anIcon [
	debuggerIcon  := anIcon
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> debuggerPriority [
	^ debuggerPriority  
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> debuggerPriority: anInteger [
	debuggerPriority  := anInteger
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> debuggerTitle [
	^ debuggerTitle  
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> debuggerTitle: aString [
	debuggerTitle  := aString
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionCustomDebuggerConfiguration >> debuggingViewPragmas [
	^ debuggingViewPragmaNames ifNil: [
		self defaultDebuggingViewPragmaNames ]
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionCustomDebuggerConfiguration >> debuggingViewPragmas: aCollection [
	"Configure the list of pragmas used to look for debugging views."
	debuggingViewPragmaNames := aCollection
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> defaultDebuggingViewPragmaNames [
	^ #(gtExceptionView)
]

{ #category : #'accessing - defaults' }
GtMoldableExceptionCustomDebuggerConfiguration >> defaultEnableDebuggingViewExtensionComputation [
	^ [ true ]
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> defaultIcon [
	^ BrGlamorousVectorIcons debug
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> defaultPriority [
	^ 100
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> defaultTitle [
	^ 'Exception'
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionCustomDebuggerConfiguration >> enableDebuggingViewExtension [
	^ self enableDebuggingViewExtensionComputation value
]

{ #category : #configuration }
GtMoldableExceptionCustomDebuggerConfiguration >> enableDebuggingViewExtension: aBlock [
	"Configure the block used to determine is to enable the domain-specific debugger associated with this exception."
	enableDebuggingViewExtensionComputation := aBlock
]

{ #category : #utils }
GtMoldableExceptionCustomDebuggerConfiguration >> enableDebuggingViewExtensionComputation [
	^ enableDebuggingViewExtensionComputation ifNil: [
		self defaultEnableDebuggingViewExtensionComputation ]
]

{ #category : #testing }
GtMoldableExceptionCustomDebuggerConfiguration >> hasDebuggingViewMethods [
	^ debuggingTargets hasDebuggingViewMethodsWithPragmaNames: self debuggingViewPragmas
]

{ #category : #initialization }
GtMoldableExceptionCustomDebuggerConfiguration >> initialize [
	super initialize.
	
	debuggerIcon := self defaultIcon.
	debuggerTitle := self defaultTitle.
	debuggerPriority := self defaultPriority. 
	availableAutomatically := true.
	sessionClass := GtFilteredDebugSession
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> sessionClass [
	^ sessionClass
]

{ #category : #accessing }
GtMoldableExceptionCustomDebuggerConfiguration >> sessionClass: aSessionClass [
	sessionClass := aSessionClass
]

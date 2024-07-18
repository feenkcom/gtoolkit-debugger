"
{{gtClass:GtMoldableExceptionSpecificDebuggerSpecification}} allows exceptions to configure a domain-specific debugger shown when the exception is raised.

The domain-specific debugger uses this configuration to locate debugging views and actions specific to an exception.

The main API methods for configuring the debugger are:
	- {{gtMethod:name=GtMoldableExceptionSpecificDebuggerSpecification>>debuggingViewPragmas:|label=#selector}} - by default `<gtExceptionDebuggingView>` is used {{gtMethod:name=GtMoldableExceptionSpecificDebuggerSpecification>>defaultDebuggingViewPragmaNames|label=#selector}}
	- {{gtMethod:name=GtMoldableExceptionDebuggerSpecification>>globalDebuggingActionPragmas:|label=#selector}} - there is no default value as this looks for global actions that subclass {{gtClass:DebugAction}}; each exception should use a different pragma for defining its global values
	- {{gtMethod:GtMoldableExceptionSpecificDebuggerSpecification>>enableWhen:|label=#selector}} - by default all exceptions have the attached domain-specific debugger enabled
	- {{gtMethod:name=GtMoldableExceptionDebuggerSpecification>>withDebuggingExceptionTargetFor:|label=#selector}} 
	- {{gtMethod:name=GtMoldableExceptionDebuggerSpecification>>withoutDebuggingExceptionTarget|label=#selector}}
	- {{gtMethod:name=GtMoldableExceptionDebuggerSpecification>>addDebuggingTargetFor:|label=#selector}}
	
To instantiate the configuration  {{gtMethod:GtMoldableExceptionDebuggerSpecification class>>forException:}} is used, which  for {{gtClass:GtMoldableExceptionSpecificDebuggerSpecification}} adds by default the current exception as a target for looking for views.
"
Class {
	#name : #GtMoldableExceptionSpecificDebuggerSpecification,
	#superclass : #GtMoldableExceptionDebuggerSpecification,
	#instVars : [
		'debuggingViewPragmaNames',
		'availableAutomatically',
		'activationPredicate',
		'sessionClass',
		'icon',
		'title',
		'priority'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #utils }
GtMoldableExceptionSpecificDebuggerSpecification >> activationPredicate [
	^ activationPredicate ifNil: [
		self defaultActivationPredicate ]
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> availableAutomatically [
	^ availableAutomatically
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> availableAutomatically: aBoolean [
	availableAutomatically := aBoolean
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionSpecificDebuggerSpecification >> canEnableDebugger [
	^ self activationPredicate value
]

{ #category : #testing }
GtMoldableExceptionSpecificDebuggerSpecification >> canShowDebugger [
	^ self canEnableDebugger and: [
		self debuggingViewPragmas notEmpty and: [
			self hasDebuggingViewMethods ] ] 
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionSpecificDebuggerSpecification >> collectTargetDebuggingViewsForDebugger: aDebugger in: aComposite [
	^ debuggingTargets 
		collectTargetDebuggingViewsForPragmaNames: self debuggingViewPragmas
		in: aComposite
		forDebugger: aDebugger
]

{ #category : #'api - debugger creation' }
GtMoldableExceptionSpecificDebuggerSpecification >> createDebuggerWithSession: aDebuggingSession [
	^ self debuggerClass 
		onSession: aDebuggingSession 
		withSpecification: self
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionSpecificDebuggerSpecification >> debuggingViewPragmas [
	^ debuggingViewPragmaNames ifNil: [
		self defaultDebuggingViewPragmaNames ]
]

{ #category : #'accessing configurarion' }
GtMoldableExceptionSpecificDebuggerSpecification >> debuggingViewPragmas: aCollection [
	"Configure the list of pragmas used to look for debugging views."
	debuggingViewPragmaNames := aCollection
]

{ #category : #'accessing - defaults' }
GtMoldableExceptionSpecificDebuggerSpecification >> defaultActivationPredicate [
	^ [ true ]
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> defaultDebuggingViewPragmaNames [
	^ #(gtExceptionView)
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> defaultIcon [
	^ BrGlamorousVectorIcons debug
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> defaultPriority [
	^ 100
]

{ #category : #'accessing - defaults' }
GtMoldableExceptionSpecificDebuggerSpecification >> defaultTargetObjectDebuggingActionPragmas [
	^ #(gtExceptionAction)
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> defaultTitle [
	^ 'Exception'
]

{ #category : #configuration }
GtMoldableExceptionSpecificDebuggerSpecification >> enableWhen: aBlock [
	"Configure the block used to determine is to enable the domain-specific debugger associated with this exception."
	activationPredicate := aBlock
]

{ #category : #'gt - extensions' }
GtMoldableExceptionSpecificDebuggerSpecification >> gtAllTargetDebuggingViewsFor: aView [
	<gtView>
	^ aView explicit
		title: 'All view definitions';
		tooltip: 'Display all target debugging view definitions';
		priority: 80;
		stencil: [ | aFilter |
			aFilter := self debuggingViewPragmas
					inject: GtSearchNullFilter new
					into: [ :eachFilter :eachSymbol | eachFilter | eachSymbol gtPragmas ].
			aFilter gtItemsFor: GtPhlowView empty ]
]

{ #category : #'gt - extensions' }
GtMoldableExceptionSpecificDebuggerSpecification >> gtTargetDebuggingViewsFor: aView [
	<gtView>
	^ aView explicit
		title: 'Target views';
		priority: 50;
		stencil: [ | aCompositeView |
			aCompositeView := GtPhlowView empty composite.
			self
				collectTargetDebuggingViewsForDebugger: self debuggerClass new
				in: aCompositeView.
			aCompositeView asElementDo: [ :e | e ] ]
]

{ #category : #testing }
GtMoldableExceptionSpecificDebuggerSpecification >> handlesDebugSession: aDebugSession [
	^ aDebugSession exception = self targetException and: [
		self canShowDebugger ]
]

{ #category : #testing }
GtMoldableExceptionSpecificDebuggerSpecification >> hasDebuggingViewMethods [
	^ debuggingTargets hasDebuggingViewMethodsWithPragmaNames: self debuggingViewPragmas
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> icon [
	^ icon  
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> icon: anIcon [
	icon  := anIcon
]

{ #category : #initialization }
GtMoldableExceptionSpecificDebuggerSpecification >> initialize [
	super initialize.
	
	icon := self defaultIcon.
	title := self defaultTitle.
	priority := self defaultPriority. 
	debuggerClass := GtMoldableExceptionDebuggingElement.
	availableAutomatically := true.
	sessionClass := GtFilteredDebugSession
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> priority [
	^ priority  
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> priority: anInteger [
	priority  := anInteger
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> sessionClass [
	^ sessionClass ifNil: [ super sessionClass ]
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> sessionClass: aSessionClass [
	sessionClass := aSessionClass
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> specificationProperties [
	^ super specificationProperties, {
		{'View Pragmas' . self debuggingViewPragmas}.
	}
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> title [
	^ title  
]

{ #category : #accessing }
GtMoldableExceptionSpecificDebuggerSpecification >> title: aString [
	title  := aString
]

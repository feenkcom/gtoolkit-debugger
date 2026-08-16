"
I contain scripter examples exercising the debugging actions that are available when the execution is interrupted inside #subclassResponsibility.

I generate a throw away two class hierarchy using a GtPharoDummyEnvironment. The root class declares #targetMethodArgOne:argTwo: as a subclass responsibility and the leaf class does not implement it. Sending that message to an instance of the leaf class therefore reaches Object>>#subclassResponsibility, which is the state in which GtSubclassResponsibilityDebugAction offers the create method button.

Using a dummy environment matters here: the create method button compiles a new method into the leaf class, and the dummy environment removes the generated classes from the system again, so the image is not polluted.
"
Class {
	#name : #GtScripterDebuggerSubclassResponsibilityActionsExamples,
	#superclass : #Object,
	#traits : 'TGtScripterDebuggerExamples',
	#classTraits : 'TGtScripterDebuggerExamples classTrait',
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #examples }
GtScripterDebuggerSubclassResponsibilityActionsExamples >> createMethodActionAfterSubclassResponsibility [
	"Click the create method button offered by GtSubclassResponsibilityDebugAction.
	It is expected to implement the missing method in the leaf class and to leave the
	debugger in a usable state.
	See https://github.com/feenkcom/gtoolkit/issues/5158"

	<gtExample>
	<return: #BlScripter>
	| scripter leafClass |
	scripter := self debuggerOnSubclassResponsibility.
	leafClass := (scripter userData at: #environment) anyDummyLeafClass realClass.

	self assert: (leafClass includesSelector: #targetMethodArgOne:argTwo:) not.

	scripter debugger
		label: 'Click the create method button';
		clickOnCreateSubclassResponsibilityDebugAction;
		play.

	scripter assert
		label: 'The missing method is implemented in the leaf class';
		satisfies: [ :aDebuggerElement |
			leafClass includesSelector: #targetMethodArgOne:argTwo: ];
		play.

	^ scripter
]

{ #category : #examples }
GtScripterDebuggerSubclassResponsibilityActionsExamples >> debuggerOnSubclassResponsibility [
	"Open a debugger on a message send that is a subclass responsibility, stepping into
	the execution until Object>>#subclassResponsibility is reached. That is the state in
	which the create method button is offered."

	<gtExample>
	<return: #BlScripter>
	| environment rootClass leafClass debuggerElement scripter |
	environment := self dummyEnvironmentWithSubclassResponsibilityMethod.
	rootClass := environment anyDummyRootClass realClass.
	leafClass := environment anyDummyLeafClass realClass.

	debuggerElement := self
			debuggerOn: [ leafClass new targetMethodArgOne: nil argTwo: nil ]
			stoppingAt: [ :context | context selector = #subclassResponsibility ].

	scripter := BlScripter new.
	scripter element: debuggerElement.
	"Keep the dummy environment alive for as long as the scripter is used."
	scripter userData at: #environment put: environment.

	scripter debugger
		label: 'Assert initial debugger state';
		assertIsMainDebuggerElement;
		assertExistsDebugActionWithId: #subclassResponsibility;
		play.

	scripter assert
		label: 'The subclass responsibility is signalled on behalf of the leaf class';
		satisfies: [ :aDebuggerElement |
			| senderContext |
			senderContext := aDebuggerElement debugSession interruptedContext sender.
			senderContext selector = #targetMethodArgOne:argTwo:
				and: [ senderContext receiver class == leafClass
					and: [ senderContext methodClass == rootClass ] ] ];
		play.

	^ scripter
]

{ #category : #'examples - support' }
GtScripterDebuggerSubclassResponsibilityActionsExamples >> dummyEnvironmentWithSubclassResponsibilityMethod [
	"Answer a dummy environment holding a two class hierarchy in which the root class
	declares #targetMethodArgOne:argTwo: as a subclass responsibility and the leaf class
	does not implement it.

	The environment removes the generated classes from the system when it is garbage
	collected, which also discards any method created by the create method button."

	<return: #GtPharoDummyEnvironment>
	| environment |
	environment := GtPharoDummiesGenerator withPackages: 1 classHierarchy: 2.

	GtPharoCodeModifier current
		compileMethodSource: 'targetMethodArgOne: aFirstArgument argTwo: aSecondArgument
	^ self subclassResponsibility'
		in: environment anyDummyRootClass realClass
		protocol: 'examples'.

	^ environment
]

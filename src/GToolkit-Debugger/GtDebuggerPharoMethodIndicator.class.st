"
I indicate whether a stack list should be scrolled to a top or maintained as it is.
Currently, previous and currenct context compiled method is used to determine this logic.
I am created by {{gtClass:GtDebuggerPharoStackModel}}.
I am used by {{gtMethod:GtAbstractExpandableStackElement>>#openFirstNonFilteredContextFrom:}}. 
The behavior is exemplified in:
- {{gtMethod: GtScripterDebuggerExamples>>#scripterStepOverInALongMethod }}, 
- {{gtMethod: GtScripterDebuggerExamples>>#scripterStepOverInALongMethod_StepInto }}, and
- {{gtMethod: GtScripterDebuggerExamples>>#scripterStepOverInALongMethod_StepThroughtABlock }} .

The issue report: [](https://github.com/feenkcom/gtoolkit/issues/3892).

"
Class {
	#name : #GtDebuggerPharoMethodIndicator,
	#superclass : #Object,
	#instVars : [
		'previousMethod',
		'currentMethod'
	],
	#category : #'GToolkit-Debugger-Models'
}

{ #category : #utilities }
GtDebuggerPharoMethodIndicator class >> methodFromContext: aContext [
	<return: #CompiledMethod>
	aContext ifNil: [ ^ nil ].
	
	^ aContext isBlockContext
		ifTrue: [ aContext compiledCode method ]
		ifFalse: [ aContext compiledCode ]
]

{ #category : #'instance creation' }
GtDebuggerPharoMethodIndicator class >> previousIndicator: anIndicator newContext: aNewContext [
	| aPreviousMethod aNewMethod |
	aPreviousMethod := anIndicator ifNotNil: #currentMethod.
	aNewMethod := self methodFromContext: aNewContext.
	^ self new
		previousMethod: aPreviousMethod;
		currentMethod: aNewMethod
]

{ #category : #accessing }
GtDebuggerPharoMethodIndicator >> currentMethod [
	^ currentMethod
]

{ #category : #accessing }
GtDebuggerPharoMethodIndicator >> currentMethod: anObject [
	currentMethod := anObject
]

{ #category : #'gt - extensions' }
GtDebuggerPharoMethodIndicator >> gtOverview [
	^ {GtPhlowOverviewItem new
			name: 'Previous method';
			value: self previousMethod.
		GtPhlowOverviewItem new
			name: 'New method';
			value: self currentMethod.
		GtPhlowOverviewItem new
			name: 'Want to keep stack scroll position';
			if: self wantsToKeepScrollPosition description: 'yes';
			if: self wantsToKeepScrollPosition not description: 'not';
			value: self wantsToKeepScrollPosition.}
]

{ #category : #'gt - extensions' }
GtDebuggerPharoMethodIndicator >> gtOverviewFor: aView [
	<gtView>
	currentMethod ifNil: [ ^ aView empty ].

	^ aView columnedList
		title: 'Overview';
		items: [ self gtOverview ];
		column: 'Name' text: #name weight: 0.5;
		column: 'Description' text: #description;
		send: #value
]

{ #category : #accessing }
GtDebuggerPharoMethodIndicator >> previousMethod [
	^ previousMethod
]

{ #category : #accessing }
GtDebuggerPharoMethodIndicator >> previousMethod: anObject [
	previousMethod := anObject
]

{ #category : #'api - testing' }
GtDebuggerPharoMethodIndicator >> wantsToKeepScrollPosition [
	^ currentMethod == previousMethod
]

{ #category : #'api - testing' }
GtDebuggerPharoMethodIndicator >> wantsToScroll [
	^ self wantsToKeepScrollPosition not
]

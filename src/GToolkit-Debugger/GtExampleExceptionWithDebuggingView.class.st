"
An example of an exception with a single debugging view defined in the exception.

The following examples creates an example instance of the exception:
{{gtExample:GtExceptionsWithExtensionsExamples>>exampleExceptionWithDebuggingView}}
"
Class {
	#name : #GtExampleExceptionWithDebuggingView,
	#superclass : #Exception,
	#instVars : [
		'actualString',
		'expectedString'
	],
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtExampleExceptionWithDebuggingView >> actualString: aString [ 
	actualString := aString 
]

{ #category : #utils }
GtExampleExceptionWithDebuggingView >> computeDiff [
	^ GtDiffBuilder
			computeDifferencesFrom: expectedString 
			to: actualString
			using: GtCharacterGroupDiffSplitter words  ignoreWhitespace
]

{ #category : #accessing }
GtExampleExceptionWithDebuggingView >> expectedString: aString [ 
	expectedString := aString 
]

{ #category : #'gt-extensions' }
GtExampleExceptionWithDebuggingView >> gtViewDiffFor: aView [ 
	<gtView>
	<gtExceptionDebuggingView>
	
	^ aView forward 
		title: 'Diff';
		priority: 1;
		object: [	
			self computeDiff ];
		view: #gtTextView:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect the comparator' 
			action: [ :aButton |
				aButton phlow spawnObject: self computeDiff ]
]

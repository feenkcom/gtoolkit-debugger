"
An example of an exception with two debugging views defined in the exception object.

The following examples creates an example instance of the exception:
{{gtExample:GtExceptionsWithExtensionsExamples>>exampleComparisonExceptionWithDebuggingViews}}
"
Class {
	#name : #GtExampleComparisonExceptionWithDebuggingViews,
	#superclass : #Error,
	#instVars : [
		'expectedString',
		'actualString',
		'targetSelector',
		'targetClass'
	],
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> actualString [
	^ actualString
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> actualString: aString [
	actualString := aString
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> compileObtainedAsExpected [
	self targetClass 
		compile: ('{1}
	^ {2}' format: {
				self targetSelector.
				self actualString printString })
		classified: 'data'
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> computedShortStringForTest [
	^ 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> computedStringForTest [
	^ 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Id anim sint ipsum id aliqua in nostrud ut aute aliqua. Deserunt in ullamco irure cupidatat amet sed sint anim in cupidatat anim in amet ut et. Eiusmod pariatur adipiscing sit in. Aliquip culpa do mollit ea sit. Dolor qui est anim mollit elit irure tempor ullamco do esse occaecat sunt labore laborum officia ipsum nisi. Excepteur aliqua labore id officia ullamco cillum in sint est est nisi nulla dolor ut in esse amet. Ut culpa exercitation qui et mollit consequat. Ea tempor proident elit esse esse est. Id in veniam exercitation est aliqua aute reprehenderit qui sit amet laborum in magna incididunt ipsum. Laboris laborum eiusmod enim pariatur quis sit. Consequat aliquip dolor eiusmod in dolor aute est in in dolor nulla cillum adipiscing sed adipiscing velit nulla nisi elit quis. Magna incididunt irure est ut in ad officia minim dolore elit proident. 

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco labori.'
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> expectedShortStringForTest [
	^ 'Lorem ipsum dolor sitt amet, consectetur adipiscing elit, sed do eiusmod lempora incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> expectedString [
	^ expectedString
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> expectedString: aString [
	expectedString := aString
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> expectedStringForTest [
	^ 'Lorem ipsum dolor sitt amet, consectetur adipiscing elit, sed do eiusmod lempora incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Id anim sint ipsum id aliqua in nostrud ut aute aliqua. Deserunt in ullamco irure cupidatat amet sed sint anim in cupidatat anim in amet ut et. Eiusmod pariatur adipiscing sitt in. Aliquip culpa do mollit ea sitt. Dolor qui est anim mollit elit irure lempora ullamco do esse occaecat sunt labore laborum officia ipsum nisi. Excepteur aliqua labore id officia ullamco cillum in sint est est nisi nulla dolor ut in esse amet. Ut culpa exercitation qui et mollit consequat. Ea lempora proident elit esse esse est. Id in veniam exercitation est aliqua aute reprehenderit qui sitt amet laborum in magna incididunt ipsum. Laboris laborum eiusmod enim pariatur quis sitt. Consequat aliquip dolor eiusmod in dolor aute est in in dolor nulla cillum adipiscing sed adipiscing velit nulla nisi elit quis. Magna incididunt irure est ut in ad officia minim dolore elit proident. 

Lorem ipsum dolor sitt amet, consectetur incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco labori.'
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> gtExceptionDebuggerSpecification [
	^ super gtExceptionDebuggerSpecification
		globalDebuggingActionPragmas: #(gtExampleComparisonDebuggingAction)
]

{ #category : #'gt - extensions' }
GtExampleComparisonExceptionWithDebuggingViews >> gtViewChangeViewFor: aView [ 
	<gtView>
	<gtExceptionView>
	
	^ aView forward 
		title: 'Changes';
		priority: 1.5;
		object: [	
			GtDiffBuilder
				computeDifferencesFrom: expectedString 
				to: actualString
				using: GtCharacterGroupDiffSplitter words ];
		view: #gtChangeViewFor:
]

{ #category : #'gt - extensions' }
GtExampleComparisonExceptionWithDebuggingViews >> gtViewDiffFor: aView [ 
	<gtView>
	<gtExceptionView>
	
	^ aView forward 
		title: 'Diff';
		priority: 1;
		object: [	
			GtDiffBuilder
				computeDifferencesFrom: expectedString 
				to: actualString
				using: GtCharacterGroupDiffSplitter words  ignoreWhitespace ];
		view: #gtTextView:;
		actionButtonIcon: BrGlamorousVectorIcons inspect 
			tooltip: 'Inspect the comparator' 
			action: [ :aButton |
				aButton phlow spawnObject: aButton phlow  firstParentWithView content phlow firstChildWithView phlow entity viewObject wait object ]
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> targetClass: aClass [
	targetClass := aClass
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> targetSelector [
	^ targetSelector
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> targetSelector: aSelector [
	targetSelector := aSelector
]

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
	^ '<div class="wiki-page"><br /><table style="border:2.90mm solid black" cellspacing="0">

  <tr style="border:2.90mm solid black"><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"> <a href="wiki?NetworkInterxion">NetworkInterxion</a> </td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"> 10.21/16 </td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"> </td></tr>

  <tr style="border:2.90mm solid black"><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"> <a href="wiki?NetworkIct">NetworkIct</a> </td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"> 10.31/16 </td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"> </td></tr>
  
   <tr style="border:2.90mm solid black"><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"><b>Location</b></td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"><b>assigned Net</b></td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"><b>Intranet</b></td></tr>

  </table><br /></div>'
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
	^ '<div class="wiki-page"><br /><table style="border:2.90mm solid black" cellspacing="0">

  <tr style="border:2.90mm solid black"><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"> <a href="wiki?NetworkInterxion">NetworkInterxion</a> </td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"> 10.20/16 </td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"> </td></tr>

  <tr style="border:2.90mm solid"><td style="border:2.90mm solid;padding:1cm;text-align:left;width:80.00mm;"> <a href="wiki?NetworkIct">NetworkIct</a> </td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"> 10.30/16 </td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"> </td></tr>
  
  <tr style="border:2.90mm solid black"><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"><b>Location</b></td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"><b>assigned Net</b></td><td style="border:2.90mm solid black;padding:1cm;text-align:left;width:80.00mm;"><b>Intranet</b></td></tr>

  </table><br /></div>'
]

{ #category : #accessing }
GtExampleComparisonExceptionWithDebuggingViews >> gtExceptionDebuggerSpecification [
	^ super gtExceptionDebuggerSpecification
		title: 'Comparison';
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
	<gtEmbeddedDebuggerView>
	
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
				| aFuture |
				aFuture := aButton phlow viewContent phlow firstChildWithViewContent phlow entity viewObject.
				aButton phlow 
					spawnFuture: aFuture 
					result: #object. ]
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

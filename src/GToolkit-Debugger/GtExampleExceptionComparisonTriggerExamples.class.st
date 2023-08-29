Class {
	#name : #GtExampleExceptionComparisonTriggerExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #asserting }
GtExampleExceptionComparisonTriggerExamples >> assert: actualData equalsDataIn: aSelector [
	| expectedData|
	expectedData := self perform: aSelector asSymbol.
	actualData = expectedData ifFalse: [
		| failure |
		failure := GtExampleComparisonExceptionWithDebuggingViews new
			expectedString: expectedData;
			actualString: actualData;
			targetClass: self class; 
			targetSelector: aSelector.
		failure signal ]
]

{ #category : #accessing }
GtExampleExceptionComparisonTriggerExamples >> computeData [
	^  GtExampleComparisonExceptionWithDebuggingViews new
		computedStringForTest
]

{ #category : #data }
GtExampleExceptionComparisonTriggerExamples >> dataExpectedComputedOne [
	^ 'Lorem ipsum dolor sitt amet, consectetur adipiscing elit, sed do eiusmod lempora incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Id anim sint ipsum id aliqua in nostrud ut aute aliqua. Deserunt in ullamco irure cupidatat amet sed sint anim in cupidatat anim in amet ut et. Eiusmod pariatur adipiscing sitt in. Aliquip culpa do mollit ea sitt. Dolor qui est anim mollit elit irure lempora ullamco do esse occaecat sunt labore laborum officia ipsum nisi. Excepteur aliqua labore id officia ullamco cillum in sint est est nisi nulla dolor ut in esse amet. Ut culpa exercitation qui et mollit consequat. Ea lempora proident elit esse esse est. Id in veniam exercitation est aliqua aute reprehenderit qui sitt amet laborum in magna incididunt ipsum. Laboris laborum eiusmod enim pariatur quis sitt. Consequat aliquip dolor eiusmod in dolor aute est in in dolor nulla cillum adipiscing sed adipiscing velit nulla nisi elit quis. Magna incididunt irure est ut in ad officia minim dolore elit proident. 

Lorem ipsum dolor sitt amet, consectetur incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco labori.'
]

{ #category : #testing }
GtExampleExceptionComparisonTriggerExamples >> testComputation [
	<gtExample>
	<noTest>
	| computedData |
	computedData := self computeData.
	
	self 
		assert: computedData 
		equalsDataIn: #dataExpectedComputedOne.

	^ computedData
]

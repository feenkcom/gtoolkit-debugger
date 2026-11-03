"
I exemplify the code transformations that moldable exceptions apply, such as ${class:GtPhlowViewsCollectorSameViewError}$.
My examples use ${method:GtRefactoryChangeManager class>>#isolatedInstanceDuring:}$, so they do not affect the global undo/redo history.
"
Class {
	#name : #GtMoldableExceptionTransformationExamples,
	#superclass : #Object,
	#category : #'GToolkit-DebuggerExtensions-Examples'
}

{ #category : #examples }
GtMoldableExceptionTransformationExamples >> fixOfViewReturningItsParameterCanBeUndone [
	"The automatic fix of a view method that returns its view parameter compiles the method
	through a recorded change: one undo restores it and keeps the changes recorded before it"

	<gtExample>
	<return: #GtPhlowViewsCollectorSameViewError>
	^ GtRefactoryChangeManager
		isolatedInstanceDuring: [ :aChangeManager |
			| environment realClass error |
			environment := GtPharoDummiesGenerator withPackages: 1 classes: 1.
			[ realClass := environment anyDummyClass realClass.
			(RBAddMethodChange
				compile: 'gtReturningParameterFor: aView
	<gtView>
	^ aView'
				in: realClass
				classified: 'views') gtExecuteWithUndo.
			error := GtPhlowViewsCollectorSameViewError new
					initializeWithViewSelector: #gtReturningParameterFor:
					targetObject: realClass new.
			self assert: error shouldTransform.

			error gtMoldableExceptionTransformation performTransformation.
			self
				assert: ((realClass >> #gtReturningParameterFor:) sourceCode includesSubstring: 'aView empty').

			aChangeManager undoChange.
			self
				assert: ((realClass >> #gtReturningParameterFor:) sourceCode includesSubstring: 'aView empty') not.
			self assert: aChangeManager hasUndoableOperations.
			error ] ensure: [ environment removeFromSystem ] ]
]

Extension { #name : #GtPharoMethodCoderStep }

{ #category : #'*GToolkit-Debugger' }
GtPharoMethodCoderStep >> assertEmbeddedDebuggerDropdownDebugButtonIsDisplayed [
	^ self
		substeps2: 'Assert embedded debugger dropdown debug button is displayed'
		do: [ :aStep | 
			aStep assert
				label: 'Assert embedded debugger dropdown debug button exists';
				exists;
				onSpaceRoot;
				onDropdown: true;
				// GtCoderEmbeddedDebuggerDetailsElement;
				// GtCoderEmbeddedDebuggerDebugButtonId.

			aStep assert
				label: 'Assert embedded debugger dropdown debug button is visible';
				satisfies: [ :aButton | 
						| isOK aButtonRectangle |
						isOK := true.
						aButtonRectangle := aButton bounds inSpace asRectangle.
						aButton
							allParentsDo: [ :aParent | 
								isOK := isOK & (aParent bounds inSpace asRectangle containsRect: aButtonRectangle) ].
						isOK ]
					description: [ 'Debug button is not visible (clipped by a parent)' ];
				onSpaceRoot;
				onDropdown: true;
				// GtCoderEmbeddedDebuggerDetailsElement;
				// GtCoderEmbeddedDebuggerDebugButtonId ]
]

{ #category : #'*GToolkit-Debugger' }
GtPharoMethodCoderStep >> assertEmbeddedDebuggerDropdownIsDisplayed [
	| aStep |
	aStep := self
			substeps2: 'Assert embedded debugger dropdown debug button is displayed'
			do: [ :aSubStep | 
				aSubStep assert
					label: 'Assert embedded debugger dropdown is displayed';
					exists;
					onSpaceRoot;
					onDropdown: true;
					// GtCoderEmbeddedDebuggerDetailsElement.

				aSubStep addDropdownVisualAnalysis
					// GtCoderEmbeddedDebuggerElement;
					/ GtCoderEmbeddedDebuggerButtonId].

	aStep referenceSender.
	^ aStep
]

{ #category : #'*GToolkit-Debugger' }
GtPharoMethodCoderStep >> assertEmbeddedDebuggerExists [
	| anAssertStep |
	anAssertStep := self assert
			label: 'Assert embedded debugger element exists';
			exists;
			referenceSender;
			onParentStepTarget: self;
			// GtCoderEmbeddedDebuggerElement.

	^ anAssertStep
]

{ #category : #'*GToolkit-Debugger' }
GtPharoMethodCoderStep >> debugSessionWithException: anExceptionClass do: aStepBlock [
	| aStep |
	aStep := self
			substeps: ('Execute code, expecting {1} exception' format: {anExceptionClass})
			before: [ :anElement | 
				self
					primitiveDebugSessionWithException: anExceptionClass
					coderElement: anElement ]
			do: [ :aSubStep | 
				aSubStep wait forEmptySpaceTaskQueueTimeout: 15 seconds.
				aStepBlock value: aSubStep ]
			ensure: [ :aDebugSession | 
				"We do not need to explicitly terminate the session here.
				If we do it will trigger the ensure blocks of this process
				to be executed from the processes we created for the session.
				The session will be garbaged collected ok. A test for that is in:
				GtDebuggerSessionForTestsExamples>>#testExplicitSessionTerminationNotNeeded" ].
	aStep referenceSender.
	^ aStep
]

{ #category : #'*GToolkit-Debugger' }
GtPharoMethodCoderStep >> primitiveDebugSessionWithException: anExceptionClass coderElement: anElement [
	<return: #DebugSession>
	| aCoderModel aDebugSession aCoderViewModel anEvaluationContext anEvaluationInfo aSourceString aCompleteSourceString aSourceInterval aNotificationResponse |
	aCoderViewModel := anElement textualCoderViewModel.
	aCoderModel := aCoderViewModel coderModel.
	anEvaluationContext := aCoderModel evaluationContext all.
	aCompleteSourceString := aCoderModel currentSourceString.
	aSourceString := anEvaluationContext sourceInterval
			computeSourceString: aCompleteSourceString.
	aSourceInterval := anEvaluationContext sourceInterval
			computeSourceInterval: aCompleteSourceString.
	anEvaluationContext
		sourceString: aCompleteSourceString;
		evaluatedSourceString: aSourceString;
		evaluatedInterval: aSourceInterval.

	[ aCoderModel
		primitiveEvaluate: anEvaluationContext sourceString
		inContext: anEvaluationContext
		onFailDo: [ :anError | anError pass ] ]
		on: anExceptionClass
		do: [ :anException | aDebugSession := DebugSession forExceptionFromExampleFor: anException ].
	self
		assert: aDebugSession isNotNil
		description: [ 'Could not initialize debug session with exception {2}'
				format: {anExceptionClass} ].

	anEvaluationInfo := GtCoderEvaluationUnhandledErrorInformation new
			requesterObject: anEvaluationContext requesterObject;
			evaluatedCode: anEvaluationContext evaluatedCode;
			sourceString: anEvaluationContext evaluatedSourceString;
			sourceInterval: anEvaluationContext evaluatedInterval;
			sourceCoder: anEvaluationContext coder.

	aNotificationResponse := aCoderModel
			notifyShowDebuggerRequest: aDebugSession
			dueTo: aDebugSession exception
			sourceString: anEvaluationInfo sourceString
			sourceInterval: anEvaluationInfo sourceInterval
			evaluationInfo: anEvaluationInfo.

	self
		assert: aNotificationResponse
		description: [ 'Notification must be handled.' ].

	^ aDebugSession
]

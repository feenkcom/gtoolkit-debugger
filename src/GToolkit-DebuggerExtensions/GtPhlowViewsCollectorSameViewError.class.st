"
Indicates that a phlow view definition  returned the same view that was passed as an argument. This is not allowed. You should use  `aView empty` instead.


An example of a wrong view signaling this error is: {{gtMethod:GtPhlowViewWithErrorExamples>>gtViewWithReturningSameViewFor:|expanded}}
"
Class {
	#name : #GtPhlowViewsCollectorSameViewError,
	#superclass : #GtPhlowViewsCollectorError,
	#traits : 'TGtMoldableExceptionSignalWithTransformation',
	#classTraits : 'TGtMoldableExceptionSignalWithTransformation classTrait',
	#instVars : [
		'viewSelector',
		'targetObject'
	],
	#category : #'GToolkit-DebuggerExtensions-ViewsCollector'
}

{ #category : #'instance creation' }
GtPhlowViewsCollectorSameViewError class >> signalForViewSelector: aMessageSymbol fromObject: anObject [ 
	^ (self new 
		initializeWithViewSelector: aMessageSymbol
		targetObject: anObject)
			signal
]

{ #category : #'ui - building' }
GtPhlowViewsCollectorSameViewError >> createAnnotatedCoderElement [
	| coder returnsStyler advicesStyler coderViewModel coderElement |
	coder := ((GtPharoMethodCoder forMethod: self viewMethod asRingDefinition) 
		highlighter: (GtRBPatternHighlighter new
		 			 ast: (RBParser 
		 			 	parseRewriteExpression: self parameterReturnString);
					  yourself)
				yourself).
				
	returnsStyler := GtPhlowDirectParameterExplanationLinkStyler new
		parameterName: self parameterName withIdentifier: #viewParameter.
	advicesStyler := GtMethodAdviceStyler new 
		advices: { GtPhlowSameViewReturnMethodAdvice new 
			argumentName: self parameterName }.
	
	coder addOns addStyler: returnsStyler.
	coder addOns addStyler: advicesStyler.
	
	coderViewModel := coder asCoderViewModel.
	coderViewModel expanded: true.

	coderElement := coderViewModel asElement "asExpandedOnlyElement vFitContentLimited".
	coderElement margin: (BlInsets all: 10).

	^ coderElement
]

{ #category : #'ui - building' }
GtPhlowViewsCollectorSameViewError >> createExplanationText [
	^ 'The Phlow view created by the method ' asRopedText
			,(self viewMethod printString asRopedText italic)
			,' returned the' asRopedText
			, (self parameterName asRopedText glamorousExplanationFor: #viewParameter)
			, ' argument. This is not allowed. Return  'asRopedText 
			, (self parameterName, ' empty') asRopedText italic,
			' instead.' asRopedText
]

{ #category : #'ui - building' }
GtPhlowViewsCollectorSameViewError >> createExplanationWithCoderElement [
	| container |
	container := BrVerticalPane new
		matchParent.
				
	container addChild: (BrEditor new
		aptitude: BrGlamorousRegularEditorAptitude;
		text: self createExplanationText;
		margin: (BlInsets all: 10);
		hMatchParent;
		vFitContent).
				
	container addChild: self createAnnotatedCoderElement.
				
	container explainer isExplanationHolder: true.
	^ container
]

{ #category : #initialization }
GtPhlowViewsCollectorSameViewError >> createMessageText [
	^ targetObject class name, '>>#', viewSelector asString
]

{ #category : #'gt - extensions' }
GtPhlowViewsCollectorSameViewError >> gtDebugActionFixItFor: anAction inContext: aPhlowActionContext [
	<gtPhlowSameViewReturnDebugAction>
	
	aPhlowActionContext currentDebuggingSession isInterruptedContextPostMortem
		ifTrue: [ ^ anAction noAction ].
	self gtMoldableExceptionTransformation shouldTransform 
		ifFalse: [ ^ anAction noAction ].
	
	^ anAction button
		label: 'Fix it';
		priority: 10;
		tooltip: 'Fix the returned view and retry the view creation';
		action: [ 
			self gtMoldableExceptionTransformation performTransformation.
	
			aPhlowActionContext currentDebuggingSession restartInterruptedContext.
			aPhlowActionContext currentDebugger resumeAndCloseDebugger ]
]

{ #category : #'gt - extensions' }
GtPhlowViewsCollectorSameViewError >> gtDebugActionRetryFor: anAction inContext: aPhlowActionContext [
	<gtPhlowSameViewReturnDebugAction>
	
	aPhlowActionContext currentDebuggingSession isInterruptedContextPostMortem
		ifTrue: [ ^ anAction noAction ].
	
	^ anAction button
		icon: BrGlamorousVectorIcons refresh;
		label: 'Retry';
		priority: 15;
		tooltip: 'Retry executing the creation of the view';
		action: [ 
			"All we need here is to restart the interrupted context and resumt execution"
			aPhlowActionContext currentDebuggingSession restartInterruptedContext.
			aPhlowActionContext currentDebugger resumeAndCloseDebugger ]
]

{ #category : #'gt - extensions' }
GtPhlowViewsCollectorSameViewError >> gtDebuggingExtensionConfiguration [
	^ super gtDebuggingExtensionConfiguration
		debuggingActionPragmas: #(gtPhlowSameViewReturnDebugAction)
]

{ #category : #'gt - extensions' }
GtPhlowViewsCollectorSameViewError >> gtViewDescriptionFor: aView [
	<gtView>
	
	^ aView textEditor
		title: 'Description';
		priority: 5;
		text: [ 
			self createExplanationText asString ]
]

{ #category : #'gt - extensions' }
GtPhlowViewsCollectorSameViewError >> gtViewViewCodeWithExplanationFor: aView [
	<gtView>
	<gtExceptionDebuggingView>
	
	^ aView explicit
		title: 'View Code';
		priority: 0;
		stencil: [ self createExplanationWithCoderElement ];
		in: [ :currentView |
			self shouldTransform ifTrue: [.
				currentView
					actionDropdownButtonIcon: BrGlamorousVectorIcons repair 
						tooltip: 'Refactor view return' 
						content: [ self refactoringContentElement ] ].
			currentView
				actionButtonIcon: BrGlamorousVectorIcons browse
					tooltip: 'Browse method'
					action: [ :aButton |
						aButton phlow 
							spawnTool: (GtMethodCoderTool compiledMethod: self viewMethod)  ];
				yourself ]
]

{ #category : #testing }
GtPhlowViewsCollectorSameViewError >> hasExplicitParameterReturn [
	| methodAst ast |
	ast := RBParser parseRewriteExpression: self parameterReturnString.
	methodAst := self viewMethod ast.
	methodAst
		nodesDo: [ :each | 
			(ast match: each inContext: Dictionary new)
				ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #initialization }
GtPhlowViewsCollectorSameViewError >> initializeWithViewSelector: aMessageSymbol targetObject: anObject [ 
	viewSelector := aMessageSymbol.
	targetObject := anObject.
	
	messageText := self createMessageText
]

{ #category : #accessing }
GtPhlowViewsCollectorSameViewError >> parameterName [
	^ self viewMethod argumentNames first
]

{ #category : #accessing }
GtPhlowViewsCollectorSameViewError >> parameterReturnString [
	^ '^ ', self parameterName
]

{ #category : #'ui - building' }
GtPhlowViewsCollectorSameViewError >> refactoringContentElement [
	| container|
	
	container := BrFrame new
		hExact: 650;
		vExact: 300.
	container addChild: ((self transformationNamespace
		gtApplyingChangesFor:  GtPhlowView empty) 
			asElementDo: [:e | e]).
	
	^ container
]

{ #category : #transformation }
GtPhlowViewsCollectorSameViewError >> shouldTransform [
	^ self viewMethod isDoIt not and: [ 
		self hasExplicitParameterReturn ]
]

{ #category : #transformation }
GtPhlowViewsCollectorSameViewError >> transformationNamespace [
	| model rewriter targetMethod |
	
	model := RBNamespace new.
	rewriter := RBParseTreeRewriter new.
	rewriter 
		replace: self parameterReturnString 
		with: self parameterReturnString, ' empty'.
	targetMethod := self viewMethod.

	(rewriter executeTree: targetMethod ast copy)
		ifTrue: [ 
			(model classFor: targetMethod methodClass) compileTree: rewriter tree ] .

	^ model
]

{ #category : #accessing }
GtPhlowViewsCollectorSameViewError >> viewMethod [
	^ targetObject class lookupSelector: viewSelector
]

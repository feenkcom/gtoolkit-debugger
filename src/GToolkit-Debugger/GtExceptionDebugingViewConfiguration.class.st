Class {
	#name : #GtExceptionDebugingViewConfiguration,
	#superclass : #Object,
	#instVars : [
		'debuggingViewPragmaNames',
		'globalDebuggingActionPragmaNames',
		'enableDebuggingViewExtensionComputation',
		'debuggingTargets'
	],
	#category : #'GToolkit-Debugger-Models'
}

{ #category : #'*GToolkit-Debugger' }
GtExceptionDebugingViewConfiguration class >> forException: anException [
	^ self new
		 withDebuggingExceptionTargetFor: anException
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> addDebuggingTargetFor: anObject [
	debuggingTargets addDebuggingTargetFor: anObject
]

{ #category : #testing }
GtExceptionDebugingViewConfiguration >> canShowDebuggingExtension [
	^ self enableDebuggingViewExtension and: [
		self debuggingViewPragmas notEmpty and: [
			self hasDebuggingViewMethods ] ] 
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingViewConfiguration >> collectTargetDebuggingViews [
	^ debuggingTargets collectTargetDebuggingViewsForPragmaNames: self debuggingViewPragmas
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingViewConfiguration >> debuggingViewPragmas [
	^ debuggingViewPragmaNames ifNil: [
		self defaultDebuggingViewPragmaNames ]
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> debuggingViewPragmas: aCollection [
	debuggingViewPragmaNames := aCollection
]

{ #category : #'accessing - defaults' }
GtExceptionDebugingViewConfiguration >> defaultDebuggingViewPragmaNames [
	^ #(gtExceptionDebuggingView)
]

{ #category : #'accessing - defaults' }
GtExceptionDebugingViewConfiguration >> defaultEnableDebuggingViewExtensionComputation [
	^ [ true ]
]

{ #category : #'accessing - defaults' }
GtExceptionDebugingViewConfiguration >> defaultGlobalDebuggingActionPragmas [
	^ #()
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingViewConfiguration >> enableDebuggingViewExtension [
	^ self enableDebuggingViewExtensionComputation value
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> enableDebuggingViewExtension: aBlock [
	enableDebuggingViewExtensionComputation := aBlock
]

{ #category : #utils }
GtExceptionDebugingViewConfiguration >> enableDebuggingViewExtensionComputation [
	^ enableDebuggingViewExtensionComputation ifNil: [
		self defaultEnableDebuggingViewExtensionComputation]
]

{ #category : #'accessing configurarion' }
GtExceptionDebugingViewConfiguration >> globalDebuggingActionPragmas [
	^ globalDebuggingActionPragmaNames ifNil: [
		self defaultGlobalDebuggingActionPragmas ]
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> globalDebuggingActionPragmas: aCollection [
	globalDebuggingActionPragmaNames := aCollection
]

{ #category : #testing }
GtExceptionDebugingViewConfiguration >> hasDebuggingViewMethods [
	^ debuggingTargets hasDebuggingViewMethodsWithPragmaNames: self debuggingViewPragmas
]

{ #category : #initialization }
GtExceptionDebugingViewConfiguration >> initialize [
	super initialize.
	
	debuggingTargets := GtExceptionDebuggingViewTargets new
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> withDebuggingExceptionTargetFor: aTargetException [
	debuggingTargets withDebuggingExceptionTargetFor: aTargetException
]

{ #category : #configuration }
GtExceptionDebugingViewConfiguration >> withoutDebuggingExceptionTarget [
	debuggingTargets withoutDebuggingExceptionTarget
]

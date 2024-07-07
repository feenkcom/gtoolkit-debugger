"
{{gtClass:GtMoldableExceptionDebuggingViewsObjectTarget}} models an object that is the source of debugging views and actions for a domain-specific debugger associated with an exception.

The two main API methods provided by this object are:
	- {{gtMethod:GtMoldableExceptionDebuggingViewsObjectTarget>>hasDebuggingViewMethodsWithPragmaNames:|label=#selector}}  uses a {{gtClass:GtPhlowCollector}} to determine if debugging views are attached to the target object
	- {{gtMethod:GtMoldableExceptionDebuggingViewsObjectTarget>>configureDebuggingViewsCollector:|label=#selector}} configures a {{gtClass:GtPhlowCollector}} with the target object



"
Class {
	#name : #GtMoldableExceptionDebuggingViewsObjectTarget,
	#superclass : #Object,
	#instVars : [
		'targetObject'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'instance creation' }
GtMoldableExceptionDebuggingViewsObjectTarget class >> forObject: anObject [
	^ self new
		 targetObject: anObject
]

{ #category : #accessing }
GtMoldableExceptionDebuggingViewsObjectTarget >> collectTargetDebuggingActionsForPragmaNames: aCollectionOfPragmaNames forDebugger: aDebuggerElement [

	^ (GtPhlowActionsCollector new
		pragmaNames: aCollectionOfPragmaNames;
		fromObject: self targetObject;
		context: (GtPhlowContext new 
			currentDebugger: aDebuggerElement);
		collect) collect: [ :aPhlowAction |
			GtPhlowActionToDebugActionAdapter forPhlowAction: aPhlowAction ]
]

{ #category : #accessing }
GtMoldableExceptionDebuggingViewsObjectTarget >> collectTargetDebuggingViewsForPragmaNames: aCollectionOfPragmaNames in: aComposite forDebugger: aDebuggerElement [
		
	self 
		collectTargetDebuggingViewsForPragmaNames: aCollectionOfPragmaNames
		matchingArguments: [ :aPragma | true ]  
		in: aComposite 
		forDebugger: aDebuggerElement
]

{ #category : #accessing }
GtMoldableExceptionDebuggingViewsObjectTarget >> collectTargetDebuggingViewsForPragmaNames: aCollectionOfPragmaNames matchingArguments: aMatchingBlockClosure in: aComposite forDebugger: aDebuggerElement [
		
	aComposite collectorAppend: [ :aCollector |
		aCollector pragmaNames: aCollectionOfPragmaNames.
		aCollector matchingArguments: aMatchingBlockClosure.
		aCollector context: (GtPhlowContext new 
			currentDebugger: aDebuggerElement).
		self configureDebuggingViewsCollector: aCollector ] 
]

{ #category : #configuration }
GtMoldableExceptionDebuggingViewsObjectTarget >> configureDebuggingViewsCollector: aViewsCollector [
	^ aViewsCollector 
		fromObject: self targetObject
]

{ #category : #accessing }
GtMoldableExceptionDebuggingViewsObjectTarget >> description [
	^ self targetObject printString
]

{ #category : #testing }
GtMoldableExceptionDebuggingViewsObjectTarget >> hasDebuggingViewMethodsWithPragmaNames: aCollectionOfPragmaNames [
	^ (GtPhlowCollector new
		fromObject: self targetObject;
		pragmaNames: aCollectionOfPragmaNames;
		collectAllPragmas) size > 0
]

{ #category : #accessing }
GtMoldableExceptionDebuggingViewsObjectTarget >> targetObject [
	^ targetObject
]

{ #category : #accessing }
GtMoldableExceptionDebuggingViewsObjectTarget >> targetObject: anObject [ 
	targetObject := anObject 
]

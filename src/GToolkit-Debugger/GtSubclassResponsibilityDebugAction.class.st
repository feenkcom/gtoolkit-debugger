Class {
	#name : #GtSubclassResponsibilityDebugAction,
	#superclass : #SubclassResponsibilityDebugAction,
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #registration }
GtSubclassResponsibilityDebugAction class >> gt2ContextDebuggingActionFor: aDebugger [
	<gt2ContextDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousVectorIcons add
]

{ #category : #registration }
GtSubclassResponsibilityDebugAction class >> gt2StackDebuggingActionFor: aDebugger [
	<gt2StackDebuggingAction>
	
	^ (self forDebugger: aDebugger)
			icon: BrGlamorousVectorIcons add;
			order: 4
]

{ #category : #private }
GtSubclassResponsibilityDebugAction >> askForSuperclassOf: aClass to: aSuperclass toImplement: aSelector ifCancel: cancelBlock [
	^ aClass
]

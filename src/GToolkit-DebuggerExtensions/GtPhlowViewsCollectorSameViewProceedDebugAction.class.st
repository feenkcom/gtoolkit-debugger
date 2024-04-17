Class {
	#name : #GtPhlowViewsCollectorSameViewProceedDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-DebuggerExtensions-ViewsCollector'
}

{ #category : #accessing }
GtPhlowViewsCollectorSameViewProceedDebugAction class >> proceedReturnDebugActionFor: aDebugger [
	<gtPhlowSameViewReturnDebugAction>
	
	^ self forDebugger: aDebugger
]

{ #category : #testing }
GtPhlowViewsCollectorSameViewProceedDebugAction >> appliesToDebugger: aDebugger [

	^ aDebugger session isInterruptedContextPostMortem not
]

{ #category : #accessing }
GtPhlowViewsCollectorSameViewProceedDebugAction >> defaultIcon [
	^  BrGlamorousVectorIcons refresh
]

{ #category : #accessing }
GtPhlowViewsCollectorSameViewProceedDebugAction >> defaultLabel [
	^ 'Restart view creation and proceed execution'
]

{ #category : #accessing }
GtPhlowViewsCollectorSameViewProceedDebugAction >> executeAction [
	self session 
		restart: self session interruptedContext.
	self debugger resumeAndCloseDebugger.
]

{ #category : #accessing }
GtPhlowViewsCollectorSameViewProceedDebugAction >> initialize [
	super initialize.
	
	"No need to update the debgger as it will anyway be closed."
	self needsUpdate: false
]

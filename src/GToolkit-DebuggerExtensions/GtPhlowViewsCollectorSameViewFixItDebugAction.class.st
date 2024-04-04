Class {
	#name : #GtPhlowViewsCollectorSameViewFixItDebugAction,
	#superclass : #DebugAction,
	#category : #'GToolkit-DebuggerExtensions-ViewsCollector'
}

{ #category : #initialization }
GtPhlowViewsCollectorSameViewFixItDebugAction class >> fixItReturnDebugActionFor: aDebugger [
	<gtPhlowSaveViewReturnFixDebugAction>
	
	^ self forDebugger: aDebugger
]

{ #category : #accessing }
GtPhlowViewsCollectorSameViewFixItDebugAction >> appliesToDebugger: aDebugger [

	^ aDebugger session isInterruptedContextPostMortem not and: [
		| targetException |
		targetException := aDebugger session exception.
		targetException notNil and: [
			targetException shouldTransform ] ]
]

{ #category : #accessing }
GtPhlowViewsCollectorSameViewFixItDebugAction >> defaultLabel [
	^ 'Fix it'
]

{ #category : #accessing }
GtPhlowViewsCollectorSameViewFixItDebugAction >> executeAction [
	self refactorContent.
	
	self session 
		restart: self session interruptedContext.
	self debugger resumeAndCloseDebugger.
]

{ #category : #initialization }
GtPhlowViewsCollectorSameViewFixItDebugAction >> initialize [
	super initialize.
	
	"No need to update the debgger as it will anyway be closed."
	self needsUpdate: false
]

{ #category : #accessing }
GtPhlowViewsCollectorSameViewFixItDebugAction >> refactorContent [
	self debugger session exception transform
]

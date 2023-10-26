Class {
	#name : #GtDebuggerDevScripterCheckStep,
	#superclass : #BlDevScripterFutureCheckStep,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertIsMainDebuggerElement [
	self 
		assert: self scripter element id
		equals: GtMoldableDebuggerMainElementId new.
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertOneDebuggerSwitchButtonLabeled: aDebuggerLabel [
	<gtExample>
	| buttonsContainer |
	
	buttonsContainer := self scripter element query 
		// GtMoldableDebuggerSwitchButtonsContainerElementId.
	
	self
		assert: buttonsContainer all size
		equals: 1.
		
	self
		assert: buttonsContainer anyOne children first label asString
		equals: aDebuggerLabel.
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertPlaygroundExpanderCollapsed [
	self assert: self debuggerQuery
		playgroundElement isCollapsed
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertPlaygroundExpanderVisible [
	self assert: self debuggerQuery
		playgroundElement isCollapsed not
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertSwitchToDebuggerLabeled: aDebuggerLabel ofType: aDebuggerType [
	<gtExample>
	
	self scripter
		clickStep: [ :aStep | 
			aStep
				// GtMoldableDebuggerSwitchButtonsContainerElementId;
				// BrButton ].

	self assert: (self scripter element query // aDebuggerType) all size equals: 1
]

{ #category : #'accessing - query' }
GtDebuggerDevScripterCheckStep >> debuggerQuery [
	^ self scripter element query debuggerQuery
]

{ #category : #actions }
GtDebuggerDevScripterCheckStep >> doubleClickOnPlaygroudExpander [
	self scripter
		doubleClickStep: [ :aStep | 
			aStep debuggerTarget
				onPlaygroundResizer ].
]

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
GtDebuggerDevScripterCheckStep >> assertSwitchToDebuggerLabeled: aDebuggerLabel ofType: aDebuggerType [
	<gtExample>
	
	self scripter click
		// GtMoldableDebuggerSwitchButtonsContainerElementId;
		// BrButton;
		play.
		
	self
		assert: (self scripter element query // aDebuggerType) all size
		equals: 1.
]

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
				// #tabbar;
				onChildFromBlock: [ :aTabGroup |
					aTabGroup children detect: [ :anElement | 
						anElement label asString = aDebuggerLabel ] ] ].

	self assert: (self scripter element query // aDebuggerType) all size equals: 1
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertTwoDebuggerSwitchButtonsWithSelectedLabeled: aDebuggerLabel [
	<gtExample>
	| buttonsContainer |
	
	buttonsContainer := self scripter element query 
		// GtMoldableDebuggerSwitchButtonsContainerElementId.
	
	self
		assert: buttonsContainer all size
		equals: 1.
		
	self
		assert: buttonsContainer anyOne tabs size
		equals: 2.
		
	self
		assert: buttonsContainer anyOne viewModel selectedTab tabLabel text asString
		equals: aDebuggerLabel.
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

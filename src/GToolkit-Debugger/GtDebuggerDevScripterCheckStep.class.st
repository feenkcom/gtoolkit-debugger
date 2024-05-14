Class {
	#name : #GtDebuggerDevScripterCheckStep,
	#superclass : #BlDevScripterFutureCheckStep,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> assertDebuggerSwitchButtonsWithLabels: aCollectionOfLabels [
	<gtExample>
	| buttonsContainer obtainedLabels |
	
	buttonsContainer := self scripter element query 
		// GtMoldableDebuggerSwitchButtonsContainerElementId.
	
	self
		assert: buttonsContainer all size
		equals: 1.
		
	self
		assert: buttonsContainer anyOne tabs size
		equals: aCollectionOfLabels size.
		
	obtainedLabels := buttonsContainer anyOne viewModel tabs 
		collect: [ :aTab | 
			aTab tabLabel text asString ].
	self
		assert: obtainedLabels asArray
		equals: aCollectionOfLabels.
]

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
GtDebuggerDevScripterCheckStep >> assertSelectedDebuggerOfType: aDebuggerClass [ 
	<gtExample>
	| buttonsContainer |
	
	buttonsContainer := self scripter element query // GtMoldableDebuggerSwitchButtonsContainerElementId.
		
	self
		assert: (buttonsContainer anyOne tabs detect: [ :aTab | aTab isSelected ]) tabLabel text asString
		equals: aDebuggerClass defaultTitle.
		
	self assert: (self scripter element query // aDebuggerClass) all size equals: 1
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

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> switchToDebuggerLabeled: aDebuggerLabel [
	<gtExample>
	
	self scripter
		clickStep: [ :aStep | 
			aStep
				// GtMoldableDebuggerSwitchButtonsContainerElementId;
				// #tabbar;
				onChildFromBlock: [ :aTabGroup |
					aTabGroup children detect: [ :anElement | 
						anElement label asString = aDebuggerLabel ] ] ].
]

{ #category : #assertions }
GtDebuggerDevScripterCheckStep >> switchToDebuggerOfType: aDebuggerClass [
	self switchToDebuggerLabeled: aDebuggerClass defaultTitle.
	self assertSelectedDebuggerOfType: aDebuggerClass.
]

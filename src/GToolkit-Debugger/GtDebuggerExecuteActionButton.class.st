Class {
	#name : #GtDebuggerExecuteActionButton,
	#superclass : #BrButton,
	#instVars : [
		'tooltipAptitude',
		'styleLook'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #utils }
GtDebuggerExecuteActionButton >> computeBackgroundColor [
	^ self debuggingAction canBeDirectlyRun
		ifTrue: [ 
				Color white]
		ifFalse: [
				"If the action cannot be directly run we mark it as disabled,
				even if it runnning could be enforced"
				self theme button disabledBackgroundColor  ]
]

{ #category : #utils }
GtDebuggerExecuteActionButton >> computeTooltipText [

	self debuggingAction isRunnableDirectlyOrForced 
		ifFalse: [ ^ 'Disabled ', self debuggingAction label asLowercase].
		
	^self debuggingAction canBeDirectlyRun 
		ifTrue: [ self debuggingAction label ]
		ifFalse: [ 'Force ', self debuggingAction label asLowercase ]
]

{ #category : #initialization }
GtDebuggerExecuteActionButton >> createConfirmActionElement [

	^ BrVerticalPane new
		id: GtDebuggerDebuggingActionConfirmationElementId;
		fitContent;
		padding: (BlInsets
				top: 5
				left: 10
				bottom: 5
				right: 10);
		cellSpacing: 5;
		addChild: (BrLabel new
				aptitude: BrGlamorousLabelAptitude new;
				"padding: (BlInsets left: 7);"
				text: ('Cannot directly '
						,self debuggingAction label asLowercase
						,'. Force action.'));
		addChild: (BrButton new 
				id: GtDebuggerDebuggingActionConfirmationButtonId;
				aptitude: BrGlamorousButtonWithIconAptitude;
				beTinySize;
				label: 'Confirm ',self debuggingAction label asLowercase, ' action';
				icon: BrGlamorousVectorIcons accept;
				action: [ 
					self debuggingAction executeForced.
					self hideConfirmationAction ] )
]

{ #category : #initialization }
GtDebuggerExecuteActionButton >> createHandleElement [
	| currentIcon currentLabel aptitude handleButton|
	
	currentIcon := self debuggingAction icon.
	currentLabel := self debuggingAction label.

	aptitude := currentIcon
		ifNil: [ BrGlamorousButtonWithLabelAptitude new ]
		ifNotNil: [ BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude2 ].
	
	handleButton := BrButton new
			aptitude: aptitude - BrGlamorousButtonExteriorAptitude;
			label: currentLabel.
			
	currentIcon ifNotNil: [ :anIcon | 
		handleButton icon: anIcon asElement ].
	
	self debuggingAction id ifNotNil: [ :anId | 
		handleButton id: (#forced, (anId asString capitalized)) asSymbol ].
		
	^ handleButton
]

{ #category : #accessing }
GtDebuggerExecuteActionButton >> debuggingAction [
	^ self userData at: #debuggingAction ifAbsent: [ nil ]
]

{ #category : #initialization }
GtDebuggerExecuteActionButton >> debuggingAction: aDebuggingAction [ 
	self userData at: #debuggingAction put: aDebuggingAction.
]

{ #category : #execution }
GtDebuggerExecuteActionButton >> executeActionOrShowConfirmation [
	self debuggingAction canBeDirectlyRun
			ifTrue: [ self debuggingAction execute  ]
			ifFalse: [
					self debuggingAction isAllowedToEnforceExecution 
							ifTrue:  [ self showConfirmationAction ]
							ifFalse: [ Error signal: 'Not possible to execute this debugging action!'] ]
]

{ #category : #initialization }
GtDebuggerExecuteActionButton >> hideConfirmationAction [
	self dispatchEvent: BrDropdownHideWish new
]

{ #category : #initialization }
GtDebuggerExecuteActionButton >> initialize [
	super initialize.
	
	self
		addAptitude: (BrGlamorousWithExplicitDropdownAptitude new
				withoutMouseEventHandler;
				withVisibleWidgetBoundsRelocator;
				withContainerPermanentVisibilityUpdater;
				handle: [ self createHandleElement ]
					content: [ self createConfirmActionElement ]).
]

{ #category : #initialization }
GtDebuggerExecuteActionButton >> initializeForDebuggingAction: aDebuggingAction [
	| currentIcon currentLabel aptitude |
	
	self debuggingAction: aDebuggingAction.
	
	currentIcon := aDebuggingAction icon.
	currentLabel := aDebuggingAction label.

	aptitude := currentIcon
			ifNil: [ BrGlamorousButtonWithLabelAptitude new ]
			ifNotNil: [ BrGlamorousButtonWithIconAptitude - BrGlamorousButtonWithLabelTooltipAptitude2 ].
			
	aptitude
		add: (tooltipAptitude := BrGlamorousWithExplicitTooltipAptitude 
			text: currentLabel 
			shortcut: aDebuggingAction keymap);
		add: (styleLook := BrStyleCommonAptitude new).
	
	self
			addAptitude: aptitude;
			label: currentLabel.
			
	currentIcon ifNotNil: [ :anIcon | 
		self icon: anIcon asElement ].
		
	aDebuggingAction id ifNotNil: [ :anId | 
		self id: anId ].
		
	self action: [ 
		self executeActionOrShowConfirmation ].
					
	self updateForCurrentDebuggingAction.
]

{ #category : #initialization }
GtDebuggerExecuteActionButton >> showConfirmationAction [
	self dispatchEvent: BrDropdownShowWish new
]

{ #category : #updating }
GtDebuggerExecuteActionButton >> updateActionStyle [
	styleLook	default: [ :aWidget | aWidget background: self computeBackgroundColor ].
	styleLook	propagateStylesToWidget
]

{ #category : #updating }
GtDebuggerExecuteActionButton >> updateForCurrentDebuggingAction [ 
	| debuggingAction currentSession |
	debuggingAction := self debuggingAction ifNil: [ ^ self ].
	
	currentSession := debuggingAction debugger debugSession .
	currentSession ifNil: [ ^ self ].
	
	self enabled: debuggingAction isRunnableDirectlyOrForced.
	self updateTooltipText.
	self updateActionStyle
]

{ #category : #updating }
GtDebuggerExecuteActionButton >> updateTooltipText [
	tooltipAptitude text: self computeTooltipText
]

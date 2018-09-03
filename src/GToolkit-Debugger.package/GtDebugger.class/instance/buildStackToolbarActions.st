building widgets
buildStackToolbarActions
	^ (self actionsForPragmas: self stackDebuggingActionsPragmas) collect: [ :aDebuggingAction | 
		| actionButton |
		actionButton := BrButton new 
			look: BrGlamorousButtonExteriorRectangularLook + BrGlamorousButtonLabelLook + BrGlamorousButtonIconLook;
			label: aDebuggingAction label; 
			action: [ 
				aDebuggingAction execute.
				aDebuggingAction needsUpdate ifTrue: [
					self updateDebugger ] ].
			aDebuggingAction icon ifNotNil: [ :anIcon | 
				actionButton icon: aDebuggingAction icon asElement ].
			actionButton ]
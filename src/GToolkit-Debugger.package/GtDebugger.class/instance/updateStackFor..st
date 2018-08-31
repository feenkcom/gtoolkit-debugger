updating
updateStackFor: aDebuggingSession
	| tabGroup tab |
	stackElement := self createStackWidget.
			
	tabGroup := BrTabGroup new.
	tab := BrTab new.
	tab 
		look: BrGlamorousTabLook;
		label: 'Stack';
		stencil: [ stackElement ];
		actionsStencil: [
			| aToolbar |
			aToolbar := BrToolbar new.
			aToolbar look: BrToolbarLook horizontal.
			self buildStackToolbarActions do: [ :anAction |
				aToolbar addItem: anAction ].
			aToolbar ].
	tabGroup 
		look: (BrMaterialTabGroupLook new headerBackground: (Color fromHexString: #'e0e0e0'));
		addTab: tab;
		constraintsDo: [ :c | 
			c vertical matchParent. 
			c horizontal matchParent ].
	
	self initializeTransmissions.
	self stackPane 
		removeChildren;
		addChild: tabGroup.
updating
updateStackFor: aDebuggingSession
	| tabGroup tab |
	stackElement := self createStackWidget.
			
	tabGroup := BrTabGroup new.
	tab := BrTab new.
	tab 
		look: (BrGlamorousTabLook new invisibleBar);
		label: 'Debug';
		stencil: [ stackElement ];
		padding: (BlInsets top: 15 right: 0 bottom: 15 left: 10);
		actionsStencil: [
			| aToolbar |
			aToolbar := BrToolbar new.
			aToolbar look: BrGlamorousToolbarLook new.
			self buildStackToolbarActions do: [ :anAction |
				aToolbar addItem: anAction ].
			aToolbar ].
	tabGroup 
		look: (BrMaterialTabGroupLook new headerBackground: (Color fromHexString: #'E57373'));
		addTab: tab;
		constraintsDo: [ :c | 
			c vertical matchParent. 
			c horizontal matchParent ].
	
	self initializeTransmissions.
	self stackPane 
		removeChildren;
		addChild: tabGroup.
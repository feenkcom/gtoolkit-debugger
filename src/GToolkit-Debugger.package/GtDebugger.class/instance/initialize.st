initialization
initialize
	| tab tabGroup |
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].		
	
	self initializePanes.	
		
	stackElement := self createStackWidget.
	self initializeTransmissions.
			
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
	
	self stackPane addChild: tabGroup.
	
	
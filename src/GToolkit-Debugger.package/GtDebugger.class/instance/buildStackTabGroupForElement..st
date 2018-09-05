building widgets
buildStackTabGroupForElement: aStackElement
	| tab tabGroup |
	tab := BrTab new.
	tab 
		look: (BrGlamorousTabLook new invisibleBar);
		label: self session name;
		stencil: (BrValuableStencil from: aStackElement); "aStackElement asStencil"
		padding: (BlInsets top: 15 right: 0 bottom: 15 left: 10);
		actionsStencil: [
			| aToolbar |
			aToolbar := BrToolbar new.
			aToolbar look: BrGlamorousToolbarLook new.
			self buildStackToolbarActions do: [ :anAction |
				aToolbar addItem: anAction ].
			aToolbar ].
	tabGroup := BrTabGroup new.
	tabGroup 
		look: (BrMaterialTabGroupLook new headerBackground: BrGlamorousColors errorBackgroundColor);
		addTab: tab;
		constraintsDo: [ :c | 
			c vertical matchParent. 
			c horizontal matchParent ].
	^ tabGroup
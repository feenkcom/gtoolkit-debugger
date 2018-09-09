building widgets
createSwitchButtonWithLabel: aLabel
	^ GtInspectorConnectorSwitchStencil new asElement
			label: aLabel;
			constraintsDo: [ :c |
				c ignoreByLayout.
				c margin: (BlInsets top: -15 left: 0 bottom: 0 right: -10).
				c ignored horizontal alignCenter.
				c ignored vertical alignTop ]
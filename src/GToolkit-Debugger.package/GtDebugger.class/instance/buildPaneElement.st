building widgets
buildPaneElement
	^ BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ];
		border: (BlBorder paint: (Color lightGray alpha: 0.5))
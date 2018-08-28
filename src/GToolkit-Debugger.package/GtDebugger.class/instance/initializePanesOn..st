initialization
initializePanesOn: anElement
	stackPane := BlElement new
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c padding: (BlInsets bottom: 5).
			c linear weight: 1 ];
		border: (BlBorder paint: (Color lightGray alpha: 0.5)).
	codePane := BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ];
		border: (BlBorder paint: (Color lightGray alpha: 0.5)).
	detailsPane := BlElement new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent.
			c linear weight: 1 ];
		border: (BlBorder paint: (Color lightGray alpha: 0.5)).
	anElement addChildren: {stackPane . codePane . detailsPane}.
	
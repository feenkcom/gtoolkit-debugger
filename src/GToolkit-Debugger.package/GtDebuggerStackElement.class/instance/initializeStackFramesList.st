initialization
initializeStackFramesList
	| stackFrames |
	stackFrames := BrColumnedList new 
		constraintsDo: [ :c | 
			c padding: (BlInsets top: 10) ].
			
	stackFrames column
		title: 'Class';
		stencil: [ :aContext :index |
			| textElement |
			textElement := (BrListLabelStencil matchParent: (self printStackClassColumnForContext: aContext)) asElement.
			textElement constraintsDo: [ :c | c padding: (BlInsets right: 10)] ].

	stackFrames column
		title: 'Selector';
		stencil: [ :aContext :index | 
			| textElement |
			textElement := (BrListLabelStencil matchParent: (self printStackMethodColumnForContext: aContext)) asElement.
			textElement constraintsDo: [ :c | c padding: (BlInsets right: 10) ] ].
		
	stackFrames column
		title: 'Other';
		stencil: [ :aContext :index | 
			| textElement |
			textElement := (BrListLabelStencil matchParent: (self printStackExtraColumnForContext: aContext)) asElement.
			textElement constraintsDo: [ :c | c padding: (BlInsets right: 10) ] ].
		
	self addChild: stackFrames.
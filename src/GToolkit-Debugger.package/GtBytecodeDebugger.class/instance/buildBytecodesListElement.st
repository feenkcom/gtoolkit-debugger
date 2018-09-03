building widgets
buildBytecodesListElement
	| bytecodesList |
	bytecodesList := BrSimpleList new.
	bytecodesList
		addEventHandler: GtInspectorListToSelectHandler new;
		stencil: [ :each :index |
			BlTextElement new
				text: (self formatBytecode: each);
				constraintsDo: [ :c | c horizontal matchParent ];
				padding: (BlInsets all: 5);
				when: BlClickEvent do: [ :anEvent  |
					anEvent consumed: true.
					bytecodesList selectOne: index ] ].
	^ bytecodesList
building widgets
createCodeWidgetForMethodInClass: aClass
	| styler editor editorElement completionStrategy completionController |
		
	styler := BrRBTextStyler new.
	styler classOrMetaClass: aClass.
	editor := BrTextEditor new.
	editor styler: styler.
	editorElement := BrEditorElement new.
	editorElement
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	editorElement editor: editor.
	completionStrategy := GtPharoCompletionStrategy new.
	completionStrategy classOrMetaClass: aClass.
	completionController := GtCompletionController on: editorElement strategy: completionStrategy.
	completionController install.
	^ editorElement
	
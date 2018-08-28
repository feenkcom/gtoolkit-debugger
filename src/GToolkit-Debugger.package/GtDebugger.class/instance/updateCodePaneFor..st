updating
updateCodePaneFor: aContext
	| editorWidget text |
	
	text := aContext sourceCode asRopedText.
	text
		attributes:
			{BrFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BrFontSizeAttribute size: 14) beNotOverwritableByStyler}.	
	editorWidget := self createCodeWidgetForMethodInClass: aContext methodClass.
	editorWidget editor text: text.
	
	self codePane 
		removeChildren;
		addChild: editorWidget
	
	
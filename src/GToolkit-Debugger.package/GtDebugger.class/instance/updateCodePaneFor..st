updating
updateCodePaneFor: aContext
	| editorWidget text selectionInterval |
	
	text := aContext sourceCode asRopedText.
	text
		attributes:
			{BrFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BrFontSizeAttribute size: 14) beNotOverwritableByStyler}.	
	selectionInterval := self session selectedCodeRangeForContext: self selectedContext.
	(text from: selectionInterval first to: selectionInterval last) attributes: { 
		BrTextUnderlineAttribute new beNotOverwritableByStyler }.
	editorWidget := self createCodeWidgetForMethodInClass: aContext methodClass.
	editorWidget editor text: text.
			
	self codePane 
		removeChildren;
		addChild: editorWidget.
	
	
	
	
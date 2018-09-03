updating panes
updateCodePaneFor: aContext
	| editorWidget text selectionInterval |
	
	text := aContext sourceCode asRopedText.
	text
		attributes:
			{BrFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BrFontSizeAttribute size: 14) beNotOverwritableByStyler}.	
	selectionInterval := self session selectedCodeRangeForContext: self selectedContext.
	(text from: selectionInterval first to: selectionInterval last) attributes: { 
		BrTextUnderlineAttribute new 
			paint: (Color fromHexString: 'E57373'); 
			beNotOverwritableByStyler }.
	editorWidget := self buildCodeWidgetForMethodInClass: aContext methodClass.
	editorWidget editor text: text.
	
	self codePane 
		removeChildren;
		addChild: editorWidget.
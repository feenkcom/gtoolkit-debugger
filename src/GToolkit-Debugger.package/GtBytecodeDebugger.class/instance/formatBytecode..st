formatting
formatBytecode: aBytecode
	| textAttributes formattedCode |
	
	textAttributes := {BrTextForegroundAttribute paint: Smalltalk ui theme textColor}.
	self selectedContext pc = aBytecode offset ifTrue: [ 
		textAttributes := {BrTextForegroundAttribute paint: Smalltalk ui theme textColor. BrFontItalicAttribute new} ]. 
	self selectedContext pc > aBytecode offset ifTrue: [ 
		textAttributes := {BrTextForegroundAttribute paint: Color gray} ].
	formattedCode := aBytecode printString asRopedText.
	formattedCode attributes: textAttributes.
	^ formattedCode
		
	"text := aContext sourceCode asRopedText.
	text
		attributes:
			{BrFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
			(BrFontSizeAttribute size: 14) beNotOverwritableByStyler}"
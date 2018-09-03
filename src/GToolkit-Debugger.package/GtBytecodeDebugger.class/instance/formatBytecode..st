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
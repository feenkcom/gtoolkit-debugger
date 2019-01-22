Class {
	#name : #GtCoderContextVariableValueStyler,
	#superclass : #GtCoderContextVariableStyler,
	#category : #'GToolkit-Debugger'
}

{ #category : #visiting }
GtCoderContextVariableValueStyler >> visitVariableNode: aVariableNode [
	aVariableNode name = 'self' ifTrue: [ 
		^ super visitVariableNode: aVariableNode ].
	(text from: aVariableNode start to: aVariableNode stop) replacingAdornment: [ :aText :anEditorElement | 
		| aContainer aTextPieceElement displayText aValueElement |
		aContainer := BlElement new
			clipChildren: false;
			layout: BlLinearLayout vertical;
			constraintsDo: [ :c |
				c horizontal fitContent.
				c vertical fitContent ].
		aTextPieceElement := (BrTextWordPieceStencilBuilder new
			text: aText;
			editorElement: anEditorElement) asElement.
		aContainer addEventHandler: (BlEventDelegator delegate: BrTextEditorRequest to: aTextPieceElement).
		displayText := self 
			valueForVariableNamed: aVariableNode name
			ifPresent: [ :aValue |
				([ aValue gtDisplayString asRopedText
						foreground: (Color fromHexString: #'90CAF9');
						fontSize: 10 ] 
				on: Error, Halt
				do: [ :e | e messageText asRopedText foreground: Color red ]) ] 
			ifAbsent: [ 
				'<missing>' asRopedText foreground: Color red ].
		aValueElement := BlShrinkingTextElement text: displayText.
		aValueElement clipChildren: true.
		aValueElement constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].
		aContainer addChildren: { aTextPieceElement . aValueElement } ].
	super visitVariableNode: aVariableNode
]

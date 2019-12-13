Class {
	#name : #GtCoderContextVariableValueStyler,
	#superclass : #GtCoderContextVariableStyler,
	#category : #'GToolkit-Debugger'
}

{ #category : #visiting }
GtCoderContextVariableValueStyler >> styleVariableNode: aVariableNode [
	(self hasValueForVariableNamed: aVariableNode name) ifFalse: [ ^ self ].
			
	(text from: aVariableNode start to: aVariableNode stop) replacingAdornment: [ :aTBrTextEditorTextualPiece :anEditorElement | 
		| aContainer aTextPieceElement displayText aValueElement theValue |
		aContainer := BlElement new
			clipChildren: false;
			layout: BlLinearLayout vertical;
			constraintsDo: [ :c |
				c horizontal fitContent.
				c vertical fitContent ].
		aTextPieceElement := (BrTextWordPieceStencilBuilder new segmentPiece: aTBrTextEditorTextualPiece) asElement.
		aContainer addEventHandler: (BlEventDelegator delegate: BrTextEditorRequest to: aTextPieceElement).
		displayText := self 
			valueForVariableNamed: aVariableNode name
			ifPresent: [ :aValue |
				theValue := aValue.
				([ aValue gtDisplayString asRopedText
						foreground: (Color fromHexString: #'90CAF9');
						fontSize: 10 ] 
				on: Error, Halt
				do: [ :e | e messageText asRopedText foreground: Color red ]) ] 
			ifAbsent: [ 
				'<missing>' asRopedText foreground: Color red ].
		aValueElement := BlShrinkingTextElement text: displayText.
		aValueElement when: BlClickEvent do: [ :event | aValueElement phlow spawnObject: theValue ].
		aValueElement clipChildren: true.
		aValueElement constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ].
		aContainer addChildren: { aTextPieceElement . aValueElement } ].
]

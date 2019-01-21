Class {
	#name : #GtCoderContextVariableValuesStyler,
	#superclass : #GtCoderContextVariableStyler,
	#category : #'GToolkit-Debugger'
}

{ #category : #accessing }
GtCoderContextVariableValuesStyler >> initializeVariables [
	variables notNil
		ifTrue: [ ^ self ].
	variables := Dictionary new.
	"variables at: 'self' put: methodCoder receiver."
	methodCoder instanceVariableNamesAndValuesDo: [ :name :value | variables at: name put: value ].
	methodCoder tempNamesAndValuesDo: [ :name :value | variables at: name put: value ].
	interval := methodCoder session pcRangeForContext: methodCoder context
]

{ #category : #visiting }
GtCoderContextVariableValuesStyler >> visitVariableNode: aVariableNode [
	variables
		at: aVariableNode name
		ifPresent: [ :value | 
			(text from: aVariableNode start to: aVariableNode stop) replacingAdornment: [ :aText :anEditorElement | 
    | aContainer aTextPieceElement aValueElement |
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
    
    aValueElement := BlShrinkingTextElement text: ([ 
			value gtDisplayString asRopedText
				foreground: Color gray;
				fontSize: 10 ] 
		on: Error, Halt
		do: [ :e | e messageText asRopedText foreground: Color red ]).
    aValueElement clipChildren: true.
    aValueElement constraintsDo: [ :c |
        c horizontal exact: 100.
        c vertical fitContent].
    
    aContainer addChildren: { aTextPieceElement . aValueElement }]. ].
	"super visitVariableNode: aVariableNode"
]

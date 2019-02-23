Class {
	#name : #GtBlocMorphicUIManager,
	#superclass : #BlBlocMorphicUIManager,
	#category : #'GToolkit-Debugger'
}

{ #category : #'ui process' }
GtBlocMorphicUIManager >> defer: aBlock [
	"For now still defer through the morphic UI thread as the Bloc UI thread is not present if there are no bloc windows."
	super defer: aBlock
	"BlUniverse defer: aBlock"
]

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

{ #category : #'ui process' }
GtBlocMorphicUIManager >> resumeUIProcess: aProcess [
	"Adopt aProcess as the project process -- probably because of proceeding from a debugger"
	
	"I explicitly check if the process corresponds to the Bloc UI process or not so I can determine which UI process to resume."
	aProcess name = BlUniverse default pulseLoop processId
		ifTrue:  [ 
			"Resume the Bloc UI process"
			self resumeBlocUIProcess: aProcess ]
		ifFalse: [ 
			"Resume the Moprhic UI process normally as before"
			self resumeMorphicUIProcess: aProcess ]
]

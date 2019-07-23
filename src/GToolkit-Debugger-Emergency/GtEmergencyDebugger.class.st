Class {
	#name : #GtEmergencyDebugger,
	#superclass : #Object,
	#instVars : [
		'errorMessageLines'
	],
	#category : #'GToolkit-Debugger-Emergency'
}

{ #category : #launching }
GtEmergencyDebugger class >> askForEmergencyEvaluatorOrExitWithText: aText [
	self new 
		errorMessage: aText;
		openInGluitinWindow.
]

{ #category : #drawing }
GtEmergencyDebugger >> drawOnSpartaCanvas: aCanvas [
	| font |
	
	errorMessageLines ifNil: [ ^ self ].
	errorMessageLines withIndexDo: [ :aLine :anIndex |	
		font := aCanvas font
		size: 28;
		build.
		
		aCanvas text
			baseline: 5@(anIndex*25+10);
			string: aLine;
			font: font;
			draw ].
]

{ #category : #accessing }
GtEmergencyDebugger >> errorMessage: aText [
	errorMessageLines := aText lines
]

{ #category : #opening }
GtEmergencyDebugger >> openInGluitinWindow [
	| eventsLoop windowBuilder windowedContext|
	eventsLoop := GlutinEventsLoop new.

	windowBuilder := GlutinWindowBuilder new.
	windowBuilder title: 'Emergency debugger'.
	windowBuilder extent: 750@650.

	windowedContext := GlutinWindowedContext
   		create: eventsLoop
   		windowBuilder: windowBuilder.

	self runProcessInWindowContext: windowedContext
]

{ #category : #opening }
GtEmergencyDebugger >> runProcessInWindowContext: windowedContext [
	| windowProcess |
	windowProcess := nil.
	windowProcess := [ 
		| isRunning aCanvas |
   		isRunning := true.
		
    	windowedContext makeCurrent.
    	aCanvas := SkiaCanvas
      		extent: windowedContext innerExtent
       	renderExtent: windowedContext framebufferExtent.
    	[
    		windowedContext makeCurrent.
   			windowedContext eventsLoop fetchEvents: [ :anEvent |
        		anEvent mapped class = WinitBaseWindowCloseRequested
            		ifTrue: [
               		windowedContext release.
                	isRunning := false.
                	windowProcess ifNotNil: [ windowProcess terminate ] ]. ].
        
			aCanvas fill
				paint: Color white;
				path: (0@0 extent: windowedContext framebufferExtent);
				draw.
    		self drawOnSpartaCanvas: aCanvas.
    		aCanvas flush.
   
    		windowedContext swapBuffers.
 
    		16 milliSeconds wait.
    		isRunning 
		] whileTrue 
	] forkAt: Processor userSchedulingPriority
]

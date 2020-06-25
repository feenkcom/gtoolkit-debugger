Class {
	#name : #GtEmergencyDebugger,
	#superclass : #GlutinWindowEventsSensor,
	#traits : 'TGlutinEventVisitor',
	#classTraits : 'TGlutinEventVisitor classTrait',
	#instVars : [
		'errorMessageLines',
		'window',
		'canvas'
	],
	#category : #'GToolkit-Debugger-Emergency'
}

{ #category : #launching }
GtEmergencyDebugger class >> askForEmergencyEvaluatorOrExitWithText: aText [
	self new 
		errorMessage: aText;
		openInGluitinWindow.
]

{ #category : #example }
GtEmergencyDebugger class >> example [
	GtEmergencyDebugger askForEmergencyEvaluatorOrExitWithText: String loremIpsum
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

{ #category : #drawing }
GtEmergencyDebugger >> newCanvas [
	^ SkiaCanvas extent: window innerExtent
	"^ BlSpartaSkiaCanvasBuilder extent: window innerExtent "
]

{ #category : #opening }
GtEmergencyDebugger >> openInGluitinWindow [
	| eventsLoop windowBuilder |

	eventsLoop := GlutinEventsFetcher default eventLoop.

	windowBuilder := GlutinWindowBuilder new.
	windowBuilder title: 'Emergency debugger'.
	windowBuilder extent: 750@650.

	self window: (eventsLoop createWindow: windowBuilder).
	self window requestRedraw.
	
	GlutinEventsFetcher default eventHandlers add: self.
	
	GlutinEventsFetcher install
]

{ #category : #'event - handling' }
GtEmergencyDebugger >> processWindowEvent: aGlutinWindowEvent forWindow: aWindow [
	self window == aWindow
		ifFalse: [ ^ self ].
		
		
	aGlutinWindowEvent accept: self
		
	"Event::LoopDestroyed => return,
   


Event::WindowEvent { ref event, .. } => match event {
                WindowEvent::Resized(logical_size) => {
                    let dpi_factor =
                        windowed_context.window().hidpi_factor();
                    windowed_context
                        .resize(logical_size.to_physical(dpi_factor));
                }
                WindowEvent::RedrawRequested => {
                    gl.draw_frame([1.0, 0.5, 0.7, 1.0]);
                    windowed_context.swap_buffers().unwrap();
                }
                WindowEvent::CloseRequested => {
                    *control_flow = ControlFlow::Exit
                }
                _ => (),
            },
            _ => (),"
	
	
		
	"self makeCurrent.
	

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
   
    		windowedContext swapBuffers."
]

{ #category : #drawing }
GtEmergencyDebugger >> render [
	Glutin critical: [
		window makeCurrent.

		canvas ifNil: [ canvas := self newCanvas ].

		canvas fill
			paint: Color white;
			path: canvas bounds;
			draw.
	  	
		self drawOnSpartaCanvas: canvas.
	  	canvas flush.

		window swapBuffers ]
]

{ #category : #'event - visiting' }
GtEmergencyDebugger >> visitWindowCloseRequest: anEvent [
	GlutinEventsFetcher default eventHandlers remove: self ifAbsent: [  ].
	window eventLoop closeWindow: window.
]

{ #category : #'event - visiting' }
GtEmergencyDebugger >> visitWindowRedrawRequested: anEvent [
	self render
]

{ #category : #'event - visiting' }
GtEmergencyDebugger >> visitWindowResizedEvent: anEvent [
	window resize: anEvent width @ anEvent height.
	
	canvas := nil.

	self render
]

{ #category : #accessing }
GtEmergencyDebugger >> window [
	<return: #GlutinWindowedContext>
	
	^ window
]

{ #category : #accessing }
GtEmergencyDebugger >> window: aGlutinWindowedContext [
	window := aGlutinWindowedContext
]

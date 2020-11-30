Class {
	#name : #GtEmergencyDebugger,
	#superclass : #GlutinWindowEventsSensor,
	#traits : 'TGlutinEventVisitor',
	#classTraits : 'TGlutinEventVisitor classTrait',
	#instVars : [
		'errorMessageLines',
		'window',
		'canvas',
		'renderer',
		'buffer'
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

{ #category : #accessing }
GtEmergencyDebugger >> buffer [
	^ buffer ifNil: [ buffer := self createBufferForExtent: self window innerExtent ]
]

{ #category : #private }
GtEmergencyDebugger >> createBufferForExtent: anExtent [
	| thePixels aForm |

	self
		assert: [ anExtent isIntegerPoint ]
		description: [ 'Must be an integer point' ].

	aForm := Form extent: anExtent depth: 32.

	thePixels := FFIExternalArray externalNewType: FFIUInt32 size: (anExtent x * anExtent y).
	thePixels autoRelease.

	^ BlHostRendererBufferSurface new
		extent: anExtent;
		stride: aForm stride;
		buffer: thePixels getHandle
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
	^ Bloc preferableSpartaCanvas new forBufferOn: self buffer
]

{ #category : #opening }
GtEmergencyDebugger >> openInGluitinWindow [
	| eventsLoop windowBuilder |

	eventsLoop := GlutinEventFetcher default eventLoop.

	windowBuilder := GlutinWindowBuilder new.
	windowBuilder title: 'Emergency debugger'.
	windowBuilder extent: 750@650.

	self window: (eventsLoop createWindow: windowBuilder).
	renderer := GlutinGLBufferRenderer new window: self window.
	self window requestRedraw.
	
	GlutinEventFetcher default eventHandlers add: self.
	
	GlutinEventFetcher install
]

{ #category : #'event - handling' }
GtEmergencyDebugger >> processWindowEvent: aGlutinWindowEvent forWindow: aWindow [
	self window == aWindow
		ifFalse: [ ^ self ].

	aGlutinWindowEvent accept: self
]

{ #category : #drawing }
GtEmergencyDebugger >> render [
	Glutin critical: [
		canvas ifNil: [ canvas := self newCanvas ].

		canvas fill
			paint: Color white;
			path: canvas bounds;
			draw.
	  	
		self drawOnSpartaCanvas: canvas.
	  	canvas flush.
		
		renderer presentBuffer: (GlutinGLBuffer new
			extent: self buffer extent;
			stride: self buffer stride;
			pixels: self buffer buffer) areas: { canvas bounds } ]
]

{ #category : #'event - visiting' }
GtEmergencyDebugger >> visitWindowCloseRequest: anEvent [
	GlutinEventFetcher default eventHandlers remove: self ifAbsent: [  ].
	window eventLoop closeWindow: window.
]

{ #category : #'event - visiting' }
GtEmergencyDebugger >> visitWindowRedrawRequested: anEvent [
	self render
]

{ #category : #'event - visiting' }
GtEmergencyDebugger >> visitWindowResizedEvent: anEvent [
	window resize: anEvent width @ anEvent height.
	
	buffer := nil.
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

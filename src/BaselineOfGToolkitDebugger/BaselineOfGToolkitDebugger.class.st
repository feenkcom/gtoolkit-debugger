"
!Debugger

The Debugger is a ... debugger. Go figure.

Take a look example with an exception:
${example:GtDummyExamplesWithExceptions class>>#j|expandedPreview|previewHeight=100}$

"
Class {
	#name : #BaselineOfGToolkitDebugger,
	#superclass : #BaselineOf,
	#classVars : [
		'PostLoaded'
	],
	#category : #BaselineOfGToolkitDebugger
}

{ #category : #baseline }
BaselineOfGToolkitDebugger >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec postLoadDoIt: #'postLoadDebugger:'.
		spec baseline: 'GToolkitInspector' with: [
				spec repository: 'github://feenkcom/gtoolkit-inspector:v0.4.6/src' ].
		spec package: 'GToolkit-Debugger' with: [
				spec requires: #(#GToolkitInspector ). ]. ].

]

{ #category : #'post load' }
BaselineOfGToolkitDebugger >> postLoadDebugger: spec [
	(PostLoaded isNotNil and: [ PostLoaded ])
		ifTrue: [ ^ self ].
	
	PostLoaded := true.
	GtEmbeddedDebuggerElement isRegistered ifFalse: [
		GtEmbeddedDebuggerElement register ].
]

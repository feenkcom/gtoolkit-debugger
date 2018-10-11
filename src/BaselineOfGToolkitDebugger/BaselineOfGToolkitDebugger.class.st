"
!Debugger

The Debugger is a ... debugger. Go figure.

Take a look example with an exception:
${example:GtDummyExamplesWithExceptions class>>#j|expandedPreview|previewHeight=100}$

"
Class {
	#name : #BaselineOfGToolkitDebugger,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitDebugger
}

{ #category : #baselines }
BaselineOfGToolkitDebugger >> baseline: spec [
	<baseline>
	spec for: #common do: [ 
		spec
			baseline: 'GToolkitInspector' with: [ spec repository: 'github://feenkcom/gtoolkit-inspector/src' ];
			package: 'GToolkit-Debugger' with: [spec requires: #(GToolkitInspector)]
	]

]

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

{ #category : #baseline }
BaselineOfGToolkitDebugger >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec baseline: 'GToolkitInspector' with: [
				spec repository: 'github://feenkcom/gtoolkit-inspector:v0.7.388/src' ].
		spec 
			package: 'GToolkit-Debugger' with: [
				spec requires: #(#GToolkitInspector ). ];
			package: 'GToolkit-Debugger-Emergency' with: [
				spec requires: #(#'GToolkit-Debugger' ). ]. ].

]

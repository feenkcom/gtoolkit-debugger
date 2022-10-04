"
1. Debugger

The Debugger is a ... debugger. Go figure.

Take a look example with an exception:
{{gtExample:GtDummyExamplesWithExceptions class>>#j|previewExpanded|previewHeight=100}}


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
		spec
			baseline: 'GToolkitInspector' with: [
				spec repository: 'github://feenkcom/gtoolkit-inspector:v0.8.1182/src' ].

		spec package: 'GToolkit-Debugger' with: [
			spec requires: #('GToolkitInspector') ].
		spec package: 'GToolkit-Debugger-Emergency' with: [
			spec requires: #('GToolkit-Debugger') ].
	]
]

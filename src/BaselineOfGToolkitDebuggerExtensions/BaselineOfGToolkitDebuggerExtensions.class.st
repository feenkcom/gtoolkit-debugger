Class {
	#name : #BaselineOfGToolkitDebuggerExtensions,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitDebuggerExtensions
}

{ #category : #baseline }
BaselineOfGToolkitDebuggerExtensions >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec
			baseline: 'GToolkitDebugger' with: [
				spec repository: 'github://feenkcom/gtoolkit-debugger:v0.8.1862/src' ].

		spec package: 'GToolkit-DebuggerExtensions' with: [
			spec requires: #('GToolkitDebugger') ].
	]
]

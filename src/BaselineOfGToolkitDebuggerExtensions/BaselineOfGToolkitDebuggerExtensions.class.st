Class {
	#name : #BaselineOfGToolkitDebuggerExtensions,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkitDebuggerExtensions
}

{ #category : #accessing }
BaselineOfGToolkitDebuggerExtensions >> baseline: spec [
	<baseline>
	
	spec for: #'common' do: [
		spec 
			baseline: 'GToolkitDebugger'with: [ 
				spec repository: 'github://feenkcom/gtoolkit-debugger:main/src' ].
			
		spec package: #'GToolkit-DebuggerExtensions' with: [
			spec requires: #('GToolkitDebugger') ] ]
]

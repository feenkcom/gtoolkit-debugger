baselines
baseline: spec
	<baseline>
	spec for: #common do: [ 
		spec
			baseline: 'GToolkitInspector' with: [ spec repository: 'github://feenkcom/gtoolkit-inspector/src' ];
			package: 'GToolkit-Debugger' with: [spec requires: #(GToolkitInspector)]
	]

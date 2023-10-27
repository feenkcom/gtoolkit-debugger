Extension { #name : #BlElementEagerQuery }

{ #category : #'*GToolkit-Debugger' }
BlElementEagerQuery >> debuggerQuery [
	^ GtDebuggerElementQuery forQuery: self
]

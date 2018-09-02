accessing
selectedContext
	| selectionInterval |
	selectionInterval := self stackElement stackFramesWidget selection.
	^ self stackElement stackFramesWidget items at: selectionInterval from.
accessing
selectedContext
	| selectionInterval |
	selectionInterval := self stackWidget stackFramesWidget selection.
	^ self stackWidget stackFramesWidget items at: selectionInterval from.
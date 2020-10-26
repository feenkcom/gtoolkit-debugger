Extension { #name : #Exception }

{ #category : #'*GToolkit-Debugger' }
Exception >> asDebuggableElement [
	^ BrDebugglableElementStencil new
		freeze: self;
		asElement
]

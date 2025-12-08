Extension { #name : #RBParseTreeRewriter }

{ #category : #'*GToolkit-Debugger-RB' }
RBParseTreeRewriter >> debugRewrites [
	searches
		do: [ :each | 
			each
				infect: 'foundMatchFor: aNode
	GtRewriteDebugSession debugCurrentProcess.
	^ super foundMatchFor: aNode' ]
]

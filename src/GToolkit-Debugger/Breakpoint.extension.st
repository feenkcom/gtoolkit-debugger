Extension { #name : #Breakpoint }

{ #category : #'*GToolkit-Debugger' }
Breakpoint class >> gtIsInstalledIn: aMethod [
	"The original method `Breakpoint class>>#isInstalledIn:` does not consider
	scoped breakpoints that creates compiled methods with an anonymous method subclass.
	Compare:
	- BreakpointExamples>>#normalBreakpoint, and
	- BreakpointExamples>>#objectBreakpoint."

	self all
		do: [ :breakpoint | 
			breakpoint link methods
				detect: [ :m | 
					m == aMethod
						or: [ m compiledMethod methodClass isAnonymous
								and: [ (m methodClass inheritsFrom: aMethod methodClass)
										and: [ m selector = aMethod selector ] ] ] ]
				ifFound: [ ^ true ] ].

	^ false
]

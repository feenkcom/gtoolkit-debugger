initialization
initialize
	super initialize.
	self 
		layout: BlFrameLayout new;
		constraintsDo: [:c | 
			c padding: (BlInsets top: 11)].
	debuggerContainer := BlElement new
	 	layout: BlFrameLayout new;
		background: Color white;
		clipChildren: false;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: debuggerContainer.
	
	"Hardcode the two buttons here for now."
	genericDebuggerButton := self createSwitchButtonWithLabel: 'Generic'.
	bytecodeDebuggerButton := self createSwitchButtonWithLabel: 'Bytecode'.
	genericDebuggerButton action: [ |currentSession|
		currentSession := bytecodeDebugger session.
		bytecodeDebugger ifNotNil: [ bytecodeDebugger detachSession ].
		genericDebugger := GtDebugger new
			session: (GtDebugger spanNewSessionFrom: currentSession).
			
		debuggerContainer removeChildren.		
		debuggerContainer addChild: genericDebugger. 
		debuggerContainer addChild: bytecodeDebuggerButton 
	].
	bytecodeDebuggerButton action: [ |currentSession|
		currentSession := genericDebugger session.
		genericDebugger ifNotNil: [ genericDebugger detachSession ].
		bytecodeDebugger := GtBytecodeDebugger new
			session: (GtBytecodeDebugger spanNewSessionFrom: currentSession).
		
		debuggerContainer removeChildren.		
		debuggerContainer addChild: bytecodeDebugger. 
		debuggerContainer addChild: genericDebuggerButton].
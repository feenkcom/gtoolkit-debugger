initialization
initialize
	super initialize.
	self 
		layout: BlFrameLayout new;
		constraintsDo: [:c | 
			c padding: (BlInsets top: 0)];
		clipChildren: false.
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
		genericDebugger := self switchFrom: bytecodeDebugger toDebuggerType: GtDebugger.
			
		debuggerContainer removeChildren.		
		debuggerContainer addChild: genericDebugger. 
		debuggerContainer addChild: bytecodeDebuggerButton 
	].
	bytecodeDebuggerButton action: [ |currentSession|
		bytecodeDebugger := self switchFrom: genericDebugger toDebuggerType: GtBytecodeDebugger.
		
		debuggerContainer removeChildren.		
		debuggerContainer addChild: bytecodeDebugger. 
		debuggerContainer addChild: genericDebuggerButton].
"
I am a phlow action target for actions shown in the debugger's context menu (the hamburger dropdown in the debugger toolbar).

Objects such as {{gtClass:GtDebugSession}} contribute to this menu by defining `<gtAction>` methods with `target: GtDebuggerContextMenuTarget`. Such methods can also use the `gtFooFor:inContext:` signature to access the current debugger via {{gtMethod:GtPhlowContext>>#currentDebugger}}.
"
Class {
	#name : #GtDebuggerContextMenuTarget,
	#superclass : #GtPhlowActionUniqueTarget,
	#category : #'GToolkit-Debugger-Actions'
}

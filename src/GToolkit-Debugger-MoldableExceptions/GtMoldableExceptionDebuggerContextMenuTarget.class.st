"
I am the default phlow action target for actions shown in the context menu of moldable exception debuggers ({{gtClass:GtMoldableExceptionDebuggingElement}}).

Common actions, like inspecting the debug session and the exception, target me (see {{gtMethod:GtDebugSession>>#gtActionInspectExceptionFor:}}).
A debugger specification can add extra targets with {{gtMethod:GtMoldableExceptionDebuggerSpecification>>#addContextMenuActionTarget:}}.

The actions are collected from the debug session, its exception, and the objects added to the specification with {{gtMethod:GtMoldableExceptionDebuggerSpecification>>#addDebuggingTargetFor:}}.
"
Class {
	#name : #GtMoldableExceptionDebuggerContextMenuTarget,
	#superclass : #GtPhlowActionUniqueTarget,
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

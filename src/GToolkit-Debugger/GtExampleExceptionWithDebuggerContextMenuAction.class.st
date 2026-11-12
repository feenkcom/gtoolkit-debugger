"
An example of an exception whose debugger specification adds a phlow action target ({{gtClass:GtExampleDebuggerContextMenuTarget}}) to the context menu of the moldable exception debugger, and that defines an action for that target: {{gtMethod:GtExampleExceptionWithDebuggerContextMenuAction>>#gtActionInspectExpectedStringFor:}}.

See {{gtMethod:GtDebuggerContextMenuExamples>>#moldableExceptionDebuggerInspectFromSpecificationTarget}}.
"
Class {
	#name : #GtExampleExceptionWithDebuggerContextMenuAction,
	#superclass : #GtExampleExceptionWithDebuggingView,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #accessing }
GtExampleExceptionWithDebuggerContextMenuAction >> expectedString [
	^ expectedString
]

{ #category : #'gt - actions' }
GtExampleExceptionWithDebuggerContextMenuAction >> gtActionInspectExpectedStringFor: anAction [
	<gtAction>
	^ anAction button
		target: GtExampleDebuggerContextMenuTarget;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Inspect Expected String';
		action: [ :aButton | aButton phlow spawnObject: self expectedString ]
]

{ #category : #accessing }
GtExampleExceptionWithDebuggerContextMenuAction >> gtExceptionDebuggerSpecification [
	"Also show the actions of GtExampleDebuggerContextMenuTarget in the debugger's context menu"

	^ super gtExceptionDebuggerSpecification
		addContextMenuActionTarget: GtExampleDebuggerContextMenuTarget
]

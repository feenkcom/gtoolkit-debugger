"
I contain examples for GtDebuggerKeymapRegistry verifying that all debugger keyboard shortcuts are properly registered.
"
Class {
	#name : #GtDebuggerKeymapRegistryExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #examples }
GtDebuggerKeymapRegistryExamples >> allEntriesHaveShortcutId [
	<gtExample>
	<return: #GtDebuggerKeymapRegistry>
	"Verifies that every entry in the debugger registry has its shortcutId set"
	| registry |
	registry := self debuggerKeymapRegistry.
	registry keymapsById keysAndValuesDo: [ :shortcutId :entry |
		self assert: entry shortcutId notNil.
		self assert: entry shortcutId equals: shortcutId ].
	^ registry
]

{ #category : #examples }
GtDebuggerKeymapRegistryExamples >> combinationForPlatformResolvesCorrectly [
	<gtExample>
	<return: #GtDebuggerKeymapRegistry>
	"Verifies the combinationForPlatformFor: utility method works"
	| registry combo |
	registry := self debuggerKeymapRegistry.
	combo := registry combinationForPlatformFor: GtDebuggerShortcutIds default stepIntoShortcutId.
	self assert: combo notNil.
	self assert: combo gtDisplayString equals: 'F5 | Ctrl+Alt+ArrowDown'.
	^ registry
]

{ #category : #examples }
GtDebuggerKeymapRegistryExamples >> debugActionUsesRegistryCombination [
	<gtExample>
	<return: #StepOverDebugAction>
	"Verifies that debug action toolbar label gets its keymap from the registry"
	| action |
	action := StepOverDebugAction gt2ContextDebuggingActionFor: nil.
	self assert: action keymap equals: 'F7 | Ctrl+Alt+ArrowRight'.
	^ action
]

{ #category : #examples }
GtDebuggerKeymapRegistryExamples >> debuggerKeymapRegistry [
	<gtExample>
	<return: #GtDebuggerKeymapRegistry>
	| registry |
	registry := GtDebuggerKeymapRegistry new.
	self assert: registry numberOfKeymaps equals: 5.
	^ registry
]

{ #category : #examples }
GtDebuggerKeymapRegistryExamples >> registryDiscoveredByGlobalRegistry [
	<gtExample>
	<return: #GtDebuggerKeymapRegistry>
	"Verifies that the debugger registry is discovered by the global BlShortcutKeymapRegistry"
	| globalRegistry debuggerRegistry |
	globalRegistry := BlShortcutKeymapRegistry default.
	debuggerRegistry := globalRegistry debugger.
	self assert: debuggerRegistry notNil.
	self assert: debuggerRegistry class equals: GtDebuggerKeymapRegistry.
	^ debuggerRegistry
]

{ #category : #examples }
GtDebuggerKeymapRegistryExamples >> shortcutResolvesFromDebuggerRegistry [
	<gtExample>
	<return: #BlShortcutWithAction>
	"Verifies that a BlShortcutWithAction with debuggerShortcutId: resolves its combination from the registry"
	| shortcut |
	shortcut := BlShortcutWithAction new
		debuggerShortcutId: GtDebuggerShortcutIds default stepOverShortcutId.
	self assert: shortcut shortcutId notNil.
	self assert: shortcut combination notNil.
	self assert: shortcut combination gtDisplayString equals: 'F7 | Ctrl+Alt+ArrowRight'.
	^ shortcut
]

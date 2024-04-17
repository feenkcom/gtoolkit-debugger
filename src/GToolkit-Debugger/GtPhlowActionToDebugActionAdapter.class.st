"
I am an adapter that wraps a phlow action and makes it possible to use in a list of debugging actions
"
Class {
	#name : #GtPhlowActionToDebugActionAdapter,
	#superclass : #Object,
	#instVars : [
		'phlowAction'
	],
	#category : #'GToolkit-Debugger-Actions'
}

{ #category : #'instance creation' }
GtPhlowActionToDebugActionAdapter class >> forPhlowAction: aPhlowAction [
	^ self new 
		phlowAction: aPhlowAction
]

{ #category : #converting }
GtPhlowActionToDebugActionAdapter >> asDebugActionElementWithHostElement: aHostElement [
	^ phlowAction asElement: [ :anElement | anElement] withHostElement: aHostElement
]

{ #category : #accessing }
GtPhlowActionToDebugActionAdapter >> order [
	^ phlowAction priority 
]

{ #category : #accessing }
GtPhlowActionToDebugActionAdapter >> phlowAction [
	^ phlowAction
]

{ #category : #accessing }
GtPhlowActionToDebugActionAdapter >> phlowAction: aPhlowAction [
	phlowAction := aPhlowAction
]

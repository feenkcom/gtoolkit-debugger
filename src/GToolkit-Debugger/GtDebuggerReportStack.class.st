"
I am a named stack in a {{gtClass:GtDebuggerReport}}. Only my name is written in the JSON summary of the report; my text is written in its own file, named after me.
"
Class {
	#name : #GtDebuggerReportStack,
	#superclass : #Object,
	#instVars : [
		'name',
		'text'
	],
	#category : #'GToolkit-Debugger-Reports'
}

{ #category : #serialization }
GtDebuggerReportStack class >> leJsonV4AttributeMapping [
	"Only the name is part of the JSON summary; the text is stored in its own file"

	^ {#name -> #name}
]

{ #category : #serialization }
GtDebuggerReportStack class >> leJsonV4Name [
	^ #gtDebuggerReportStack
]

{ #category : #'instance creation' }
GtDebuggerReportStack class >> named: aName text: aString [
	^ self new
		name: aName;
		text: aString;
		yourself
]

{ #category : #'gt - extensions' }
GtDebuggerReportStack >> gtTextFor: aView [
	<gtView>
	text ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Stack';
		priority: 10;
		text: [ text asRopedText glamorousCodeFontAndSize ]
]

{ #category : #accessing }
GtDebuggerReportStack >> name [
	^ name
]

{ #category : #accessing }
GtDebuggerReportStack >> name: aString [
	name := aString
]

{ #category : #accessing }
GtDebuggerReportStack >> numberOfLines [
	^ text ifNil: [ 0 ] ifNotNil: [ text lines size ]
]

{ #category : #printing }
GtDebuggerReportStack >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [ aStream nextPutAll: name asString ]
]

{ #category : #accessing }
GtDebuggerReportStack >> text [
	^ text
]

{ #category : #accessing }
GtDebuggerReportStack >> text: aString [
	text := aString
]

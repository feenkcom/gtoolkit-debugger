Class {
	#name : #GtDebuggerSpecification,
	#superclass : #Object,
	#instVars : [
		'debuggerClass'
	],
	#category : #'GToolkit-Debugger-MoldableExceptions'
}

{ #category : #'api - testing' }
GtDebuggerSpecification >> availableAutomatically [
	"Available automatically indicates if to actually select that debugger automatically
	when a moldable debugger window opens. True value means that the corresponding debugger
	should be displayed as a default debugger (other debuggers are available on user
	explicit selection)."

	<return: #Boolean>
	self subclassResponsibility
]

{ #category : #'api - debugger creation' }
GtDebuggerSpecification >> createDebuggerStartingFrom: aDebuggingSession [
	^ self createDebuggerWithSession: (self debuggerClass 
		spanNewSessionFrom: aDebuggingSession)
]

{ #category : #'api - debugger creation' }
GtDebuggerSpecification >> createDebuggerWithSession: aDebuggingSession [
	^ self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> debuggerClass [
	^ debuggerClass
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> debuggerClass: aDebuggerClass [
	debuggerClass := aDebuggerClass
]

{ #category : #'gt - extensions' }
GtDebuggerSpecification >> gtViewSpecificationPropertiesFor: aView [ 
	<gtView>
	
	^ aView columnedList 
		title: 'Properties';
		items: [ self specificationProperties ];
		column: 'Property' text:[ :array | array first ] width: 250;
		column: 'Value' text:[ :array | 
			array last];
		send: #second
]

{ #category : #'api - testing' }
GtDebuggerSpecification >> handlesDebugSession: aDebugSession [
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> icon [
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> priority [
	self subclassResponsibility
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> sessionClass [
	^ self debuggerClass sessionClass
]

{ #category : #accessing }
GtDebuggerSpecification >> specificationProperties [
	^ {
		{'Title' . self title}.
		{'Icon' . self icon}.
		{'Priority' . self priority}.
		{'Available Automatically' . self availableAutomatically}.
		{'Debugger Class' . self debuggerClass}.
		{'Session Class' . self sessionClass}.
	}
]

{ #category : #'api - accessing' }
GtDebuggerSpecification >> title [
	self subclassResponsibility
]

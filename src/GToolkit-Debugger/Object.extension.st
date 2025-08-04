Extension { #name : #Object }

{ #category : #'*GToolkit-Debugger' }
Object >> infect: aString [
	"Compile a per object extension method for debugging. For example, you can add a breakpoint to the OrderedCollection>>add: method for a particular object:
	
	| oc1 oc2 |
	oc1 := OrderedCollection new.
	oc2 := OrderedCollection new.
	oc2 infect: 'add: anObject self halt. ^super add: anObject'.
	oc1 add: 1.
	oc2 add: 2
	"

	| newClass |
	newClass := self class newAnonymousSubclass.
	newClass compile: 'infect: aString
	self class compile: aString'.
	newClass compile: 'disinfect
	self class superclass adoptInstance: self'.
	newClass adoptInstance: self.
	self infect: aString
]

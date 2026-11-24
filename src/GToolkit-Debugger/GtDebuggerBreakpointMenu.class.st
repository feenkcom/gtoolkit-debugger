Class {
	#name : #GtDebuggerBreakpointMenu,
	#superclass : #BlElement,
	#instVars : [
		'breakpoint',
		'coderModel'
	],
	#category : #'GToolkit-Debugger-Breakpoints'
}

{ #category : #'instance creation' }
GtDebuggerBreakpointMenu class >> on: aBreakpoint coderModel: aCoderModel [
	^self new setBreakpoint: aBreakpoint coderModel: aCoderModel
]

{ #category : #callbacks }
GtDebuggerBreakpointMenu >> actOnBreakpointHitFor: anAnnouncement [
	anAnnouncement breakpoint == breakpoint 
		ifTrue: [self delayedUpdate]
]

{ #category : #callbacks }
GtDebuggerBreakpointMenu >> actOnBreakpointRemovedFor: anAnnouncement [
	anAnnouncement breakpoint == breakpoint 
		ifTrue: [ coderModel requestStyleSourceText ]
]

{ #category : #aptitudes }
GtDebuggerBreakpointMenu >> actionButtonLook [
	^BrGlamorousButtonIconAptitude + BrGlamorousButtonLayoutAptitude
		+ ((BrStyleCommonAptitude new)
				default: [:aStyle | aStyle geometry: BlCircleGeometry new];
				hovered: [:aStyle | aStyle background: BrGlamorousColors neutralBackgroundColor darker];
				pressed: 
						[:aStyle |
						aStyle background: BrGlamorousColors neutralBackgroundColor darker darker])
]

{ #category : #accessing }
GtDebuggerBreakpointMenu >> color [
	^ self paintForEnabled: breakpoint isEnabled
]

{ #category : #accessing }
GtDebuggerBreakpointMenu >> currentIcon [
	^ self iconForEnabled: breakpoint isEnabled once: breakpoint once
]

{ #category : #updating }
GtDebuggerBreakpointMenu >> delayedUpdate [
	"needed because Breakpoint status is updated after signaling"
	| action |
	action := BlTaskAction new action: [self updateIcon].
	self enqueueTask: action
]

{ #category : #buttons }
GtDebuggerBreakpointMenu >> dropdown [
	^(BrButton new)
		aptitude: self actionButtonLook
					+ (BrGlamorousWithExplicitDropdownAptitude 
						handle: [self handleButton]
						content: [self menu]);
		icon: self currentIcon;
		beSmallSize;
		exact: 16 @ 16
]

{ #category : #accessing }
GtDebuggerBreakpointMenu >> frequencyButton [
	^ breakpoint once
		ifTrue: [ BrButton new
				aptitude: self menuButtonLook;
				label: 'Always';
				icon: self infinity;
				beSmallSize;
				hMatchParent;
				alignCenterLeft;
				action: [ :aButton | 
					breakpoint once: false.
					self updateIcon.
					aButton fireEvent: BrDropdownHideWish new.
					self notifyBreakpointChanged ] ]
		ifFalse: [ BrButton new
				aptitude: self menuButtonLook;
				label: 'Once';
				icon: BrGlamorousVectorIcons debug asElement;
				beSmallSize;
				hMatchParent;
				alignCenterLeft;
				action: [ :aButton | 
					breakpoint once: true.
					self updateIcon.
					aButton fireEvent: BrDropdownHideWish new.
					self notifyBreakpointChanged ] ]
]

{ #category : #buttons }
GtDebuggerBreakpointMenu >> handleButton [
	^(BrButton new)
		aptitude: BrGlamorousButtonIconAptitude + BrGlamorousButtonLayoutAptitude;
		icon: (self currentIcon);
		beSmallSize;
		exact: 16 @ 16
]

{ #category : #private }
GtDebuggerBreakpointMenu >> iconForEnabled: isEnabled once: isOnce [
	| aPaint aGlyph anIconExtent aStrokeWidth |
	aPaint := self paintForEnabled: isEnabled.
	isOnce
		ifTrue: [ aGlyph := BrGlamorousVectorIcons debug asElement.
			anIconExtent := 16 @ 16.
			aStrokeWidth := 1.5 ]
		ifFalse: [ aGlyph := BrGlamorousVectorIcons infinity asElement.
			anIconExtent := 15 @ 15.
			aStrokeWidth := 48 ].
	isEnabled
		ifTrue: [ aGlyph background: aPaint ]
		ifFalse: [ aGlyph
				background: Color transparent;
				outskirts: BlOutskirts centered;
				border: (BlBorder paint: aPaint width: aStrokeWidth) ].
	^ aGlyph asScalableElement size: anIconExtent
]

{ #category : #icons }
GtDebuggerBreakpointMenu >> infinity [
	^ (BrGlamorousVectorIcons infinity asElement
		background: self theme button defaultTextForeground) asScalableElement
		size: 15 @ 15
]

{ #category : #buttons }
GtDebuggerBreakpointMenu >> inspectButton [
	^(BrButton new)
		aptitude: self menuButtonLook;
		label: 'Inspect';
		icon: BrGlamorousVectorIcons inspect;
		beSmallSize;
		hMatchParent;
		alignCenterLeft;
		action: [:aButton |
			self phlow spawnObject: breakpoint.
			aButton fireEvent: BrDropdownHideWish new]
]

{ #category : #accessing }
GtDebuggerBreakpointMenu >> menu [
	^(BrVerticalPane new)
		fitContent;
		addChildren: 
				{self statusButton.
				self frequencyButton.
				self removeButton.
				self inspectButton}
]

{ #category : #aptitudes }
GtDebuggerBreakpointMenu >> menuButtonLook [
	^(BrGlamorousButtonRectangularAptitude new cornerRadius: 0)
		+ BrGlamorousButtonIconAptitude + BrGlamorousLabelAptitude
		+ BrGlamorousListItemAptitude
]

{ #category : #'private - notifying' }
GtDebuggerBreakpointMenu >> notifyBreakpointChanged [
	SystemAnnouncer uniqueInstance
		announce: (BreakpointAnnouncement on: breakpoint nodes: breakpoint link nodes)
]

{ #category : #private }
GtDebuggerBreakpointMenu >> paintForEnabled: isEnabled [
	^ isEnabled
		ifTrue: [ self theme editor enabledBreakpointForeground ]
		ifFalse: [ self theme button disabledBorderColor ]
]

{ #category : #subscriptions }
GtDebuggerBreakpointMenu >> registerListeners [
	(SystemAnnouncer uniqueInstance weak)
		when: BreakpointHit
			send: #actOnBreakpointHitFor:
			to: self;
		when: BreakpointRemoved
			send: #actOnBreakpointRemovedFor:
			to: self
]

{ #category : #buttons }
GtDebuggerBreakpointMenu >> removeButton [
	^(BrButton new)
		aptitude: self menuButtonLook;
		label: 'Remove';
		icon: BrGlamorousVectorIcons close;
		beSmallSize;
		hMatchParent;
		alignCenterLeft;
		action: 
				[:aButton |
				breakpoint remove.
				aButton fireEvent: BrDropdownHideWish new]
]

{ #category : #private }
GtDebuggerBreakpointMenu >> setBreakpoint: aBreakpoint coderModel: aCoderModel [
	breakpoint := aBreakpoint.
	coderModel := aCoderModel.
	self addChild: self dropdown.
	self layout: BlLinearLayout horizontal.
	self constraintsDo: 
			[:c |
			c horizontal fitContent.
			c vertical fitContent].
	"self updateColor."
	self registerListeners
]

{ #category : #buttons }
GtDebuggerBreakpointMenu >> statusButton [
	^ breakpoint isEnabled
		ifTrue: [ BrButton new
				aptitude: self menuButtonLook;
				label: 'Disable';
				icon: (self iconForEnabled: false once: breakpoint once);
				beSmallSize;
				hMatchParent;
				alignCenterLeft;
				action: [ :aButton | 
					breakpoint disable.
					self updateIcon.
					aButton fireEvent: BrDropdownHideWish new.
					self notifyBreakpointChanged ] ]
		ifFalse: [ BrButton new
				aptitude: self menuButtonLook;
				label: 'Enable';
				icon: (self iconForEnabled: true once: breakpoint once);
				beSmallSize;
				hMatchParent;
				alignCenterLeft;
				action: [ :aButton | 
					breakpoint enable.
					self updateIcon.
					aButton fireEvent: BrDropdownHideWish new.
					self notifyBreakpointChanged ] ]
]

{ #category : #updating }
GtDebuggerBreakpointMenu >> updateColor [
	self updateIcon
]

{ #category : #updating }
GtDebuggerBreakpointMenu >> updateIcon [
	(self children first)
		icon: self currentIcon;
		beSmallSize;
		exact: 16 @ 16
]

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
	^breakpoint isEnabled
		ifTrue: [Color lightBrown]
		ifFalse: [Color veryLightGray]
]

{ #category : #accessing }
GtDebuggerBreakpointMenu >> currentIcon [
	^ breakpoint isEnabled
		ifTrue: [ breakpoint once 
			ifTrue: [ self orangeBolt ] 
			ifFalse: [ self orangeInfinity ] ]
		ifFalse: [ breakpoint once 
			ifTrue: [ self grayBolt ] 
			ifFalse: [ self grayInfinity ] ]
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
					aButton fireEvent: BrDropdownHideWish new ] ]
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
					aButton fireEvent: BrDropdownHideWish new ] ]
]

{ #category : #icons }
GtDebuggerBreakpointMenu >> grayBolt [
	^BrGlamorousVectorIcons debug asElement background: Color veryLightGray
]

{ #category : #icons }
GtDebuggerBreakpointMenu >> grayInfinity [
	^(BrGlamorousVectorIcons infinity asElement
		background: Color veryLightGray) asScalableElement
		size: 15 @ 15
]

{ #category : #buttons }
GtDebuggerBreakpointMenu >> handleButton [
	^(BrButton new)
		aptitude: BrGlamorousButtonIconAptitude + BrGlamorousButtonLayoutAptitude;
		icon: (self currentIcon);
		beSmallSize;
		exact: 16 @ 16
]

{ #category : #icons }
GtDebuggerBreakpointMenu >> infinity [
	^BrGlamorousVectorIcons infinity asElement asScalableElement
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

{ #category : #icons }
GtDebuggerBreakpointMenu >> orangeBolt [
	^BrGlamorousVectorIcons debug asElement background: Color lightBrown
]

{ #category : #accessing }
GtDebuggerBreakpointMenu >> orangeInfinity [
	^(BrGlamorousVectorIcons infinity asElement background: Color lightBrown)
		asScalableElement size: 15 @ 15
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
	^breakpoint isEnabled
		ifTrue: 
			[(BrButton new)
				aptitude: self menuButtonLook;
				label: 'Disable';
				icon: (breakpoint once
					ifTrue: [self grayBolt]
					ifFalse: [self grayInfinity]);
				beSmallSize;
				hMatchParent;
				alignCenterLeft;
				action: 
						[:aButton |
						breakpoint disable.
						self updateIcon.
						aButton fireEvent: BrDropdownHideWish new]]
		ifFalse: 
			[(BrButton new)
				aptitude: self menuButtonLook;
				label: 'Enable';
				icon: (breakpoint once
								ifTrue: [self orangeBolt]
								ifFalse: [self orangeInfinity]);
				beSmallSize;
				hMatchParent;
				alignCenterLeft;
				action: 
						[:aButton |
						breakpoint enable.
						self updateIcon.
						aButton fireEvent: BrDropdownHideWish new]]
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

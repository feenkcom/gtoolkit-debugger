Class {
	#name : #GtDebuggerBreakpointMenuExamples,
	#superclass : #Object,
	#category : #'GToolkit-Debugger-Examples'
}

{ #category : #assertions }
GtDebuggerBreakpointMenuExamples >> assertBadgeIn: aScripter glyphExtent: anExtent background: aBackground foreground: aForeground [
	aScripter
		checkStep: [ :aStep | 
			aStep
				label: 'Check the breakpoint badge and glyph';
				// #icon;
				value: [ :aBadge | 
						| aGlyph aTheme |
						aGlyph := aBadge children first children first.
						aTheme := aBadge theme.
						{aBadge geometry class.
							aGlyph extent.
							aBadge background isTransparent
								ifTrue: [ Color transparent ]
								ifFalse: [ aBadge background paint color blocResolveColorForTheme: aTheme ].
							aGlyph background paint color blocResolveColorForTheme: aTheme} ]
					equals: {BlRoundedRectangleGeometry.
							anExtent.
							aBackground.
							aForeground} ]
]

{ #category : #examples }
GtDebuggerBreakpointMenuExamples >> breakpointIconsWithTheme: aTheme [
	| aBreakpoint aMenu aScripter anEnabledBackground aDisabledBackground anEnabledForeground aDisabledForeground aHandleScripter |
	aBreakpoint := Breakpoint basicNew
			once: true;
			enabled: true.
	aMenu := (GtDebuggerBreakpointMenu on: aBreakpoint coderModel: nil)
			theme: aTheme.
	aScripter := BlScripter new element: aMenu.
	anEnabledBackground := aTheme editor enabledBreakpointBackground
			blocResolveColorForTheme: aTheme.
	aDisabledBackground := aTheme editor disabledBreakpointBackground
			blocResolveColorForTheme: aTheme.
	anEnabledForeground := aTheme editor enabledBreakpointForeground
			blocResolveColorForTheme: aTheme.
	aDisabledForeground := aTheme editor disabledBreakpointForeground
			blocResolveColorForTheme: aTheme.
	self
		assertBadgeIn: aScripter
		glyphExtent: 16 @ 16
		background: anEnabledBackground
		foreground: anEnabledForeground.
	aScripter
		doStep: [ :aStep | 
			aStep
				label: 'Disable the breakpoint';
				block: [ :aMarker | 
					aBreakpoint disable.
					aMarker updateIcon ] ].
	self
		assertBadgeIn: aScripter
		glyphExtent: 16 @ 16
		background: aDisabledBackground
		foreground: aDisabledForeground.
	aScripter
		doStep: [ :aStep | 
			aStep
				label: 'Change the disabled breakpoint frequency to always';
				block: [ :aMarker | 
					aBreakpoint once: false.
					aMarker updateIcon ] ].
	self
		assertBadgeIn: aScripter
		glyphExtent: 640 @ 512
		background: aDisabledBackground
		foreground: aDisabledForeground.
	aHandleScripter := BlScripter new element: (aMenu handleButton theme: aTheme).
	self
		assertBadgeIn: aHandleScripter
		glyphExtent: 640 @ 512
		background: aDisabledBackground
		foreground: aDisabledForeground.
	aScripter
		doStep: [ :aStep | 
			aStep
				label: 'Enable the always breakpoint';
				block: [ :aMarker | 
					aBreakpoint enable.
					aMarker updateIcon ] ].
	self
		assertBadgeIn: aScripter
		glyphExtent: 640 @ 512
		background: anEnabledBackground
		foreground: anEnabledForeground.
	aHandleScripter := BlScripter new element: (aMenu handleButton theme: aTheme).
	self
		assertBadgeIn: aHandleScripter
		glyphExtent: 640 @ 512
		background: anEnabledBackground
		foreground: anEnabledForeground.
	^ aScripter
]

{ #category : #examples }
GtDebuggerBreakpointMenuExamples >> darkBreakpointIcons [
	<gtExample>
	<return: #BlScripter>
	^ self breakpointIconsWithTheme: BrGlamorousDarkTheme new
]

{ #category : #examples }
GtDebuggerBreakpointMenuExamples >> lightBreakpointIcons [
	<gtExample>
	<return: #BlScripter>
	^ self breakpointIconsWithTheme: BrGlamorousLightTheme new
]

{ #category : #examples }
GtDebuggerBreakpointMenuExamples >> paletteChangesUpdateBreakpointBadge [
	<gtExample>
	<return: #BlScripter>
	| aTheme aBreakpoint aMenu aScripter |
	aTheme := BrGlamorousDarkTheme new.
	aBreakpoint := Breakpoint basicNew
			once: true;
			enabled: true.
	aMenu := (GtDebuggerBreakpointMenu on: aBreakpoint coderModel: nil)
			theme: aTheme.
	aScripter := BlScripter new element: aMenu.
	aScripter
		doStep: [ :aStep | 
			aStep
				label: 'Update each breakpoint color role';
				block: [ aTheme editor
						constantAt: #enabledBreakpointBackground put: Color transparent;
						constantAt: #enabledBreakpointForeground put: Color cyan;
						constantAt: #disabledBreakpointBackground put: Color darkGray;
						constantAt: #disabledBreakpointForeground put: Color white.
					aTheme themeModified ] ].
	self
		assertBadgeIn: aScripter
		glyphExtent: 16 @ 16
		background: Color transparent
		foreground: Color cyan.
	aScripter
		doStep: [ :aStep | 
			aStep
				label: 'Disable the breakpoint';
				block: [ :aMarker | 
					aBreakpoint disable.
					aMarker updateIcon ] ].
	self
		assertBadgeIn: aScripter
		glyphExtent: 16 @ 16
		background: Color darkGray
		foreground: Color white.
	^ aScripter
]

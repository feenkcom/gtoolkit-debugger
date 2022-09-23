Class {
	#name : #GtPharoDebuggerElement,
	#superclass : #GtAbstractExpandableDebuggerElement,
	#category : #'GToolkit-Debugger-GToolkit-Debugger'
}

{ #category : #accessing }
GtPharoDebuggerElement class >> defaultTitle [
	^ 'New Gt'
]

{ #category : #'tools registry' }
GtPharoDebuggerElement class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry registerDebugger: self withRank: 1000.
]

{ #category : #accessing }
GtPharoDebuggerElement >> aboutToOpen [
	"Select the first non filtered context. This mean that we will ignore some methods 
	like halts or debug method to select the first interesting stack frame in the debugger."
	self setDebuggerToFirstNonFilteredContext.
]

{ #category : #'building widgets' }
GtPharoDebuggerElement >> buildStackElement [
	| newStackElement |
	newStackElement := GtPharoStackElement new.
	newStackElement containerName: #stackElement.
	^ newStackElement
]

{ #category : #accessing }
GtPharoDebuggerElement >> buildStackToolbarActions [
	| buttons filterButton |
	buttons := super buildStackToolbarActions.
	filterButton := BrButton new
			aptitude: BrGlamorousButtonWithIconAptitude
					+ (BrGlamorousWithDropdownAptitude
							handle: [ BrButton new
									aptitude: BrGlamorousButtonWithIconAptitude - BrGlamorousButtonExteriorAptitude;
									icon: BrGlamorousIcons filter;
									label: 'Filter';
									yourself ]
							content: [ | selectedFilters checklist saveButton |
								selectedFilters := Set withAll: self contextFilters.
								checklist := BrSimpleList new
										vFitContentLimited;
										hFitContent;
										items: (GtSearchFilter allSearchFilters
												asSortedCollection: [ :a :b | a filterLabel < b filterLabel ]);
										itemStencil: [ :each :index | 
											BrHorizontalPane new
												fitContent;
												yourself ];
										itemDataBinder: [ :pane :filter | 
											| checkbox button |
											pane removeChildren.
											checkbox := BrCheckbox new
													margin: (BlInsets top: 3 left: 2);
													aptitude: BrGlamorousCheckboxAptitude;
													checked: (selectedFilters includes: filter);
													whenCheckedDo: [ selectedFilters add: filter ];
													whenUncheckedDo: [ selectedFilters remove: filter ifAbsent: [  ] ];
													beSmallSize.
											button := BrButton new
													beSmallSize;
													aptitude: BrGlamorousButtonRectangularAptitude + BrGlamorousButtonLabelAptitude;
													action: [ :aButton | checkbox checked: checkbox isUnchecked ];
													label: filter filterLabel asRopedText.
											pane
												addChild: checkbox;
												addChild: button ].
								saveButton := BrButton new
										aptitude: BrGlamorousButtonWithIconAptitude;
										label: 'Save';
										margin: (BlInsets top: 5);
										icon: BrGlamorousVectorIcons accept;
										action: [ :button | 
											button fireEvent: BrDropdownHideWish new.
											self contextFilters: selectedFilters ].
								BrVerticalPane new
									fitContent;
									padding: (BlInsets all: 5);
									addChild: checklist;
									addChild: saveButton;
									yourself ]);
			icon: BrGlamorousIcons filter;
			label: 'Filter'.
	buttons add: filterButton.
	^ buttons
]

{ #category : #accessing }
GtPharoDebuggerElement >> contextFilters [
	^ self stackElement contextFilters
]

{ #category : #accessing }
GtPharoDebuggerElement >> contextFilters: selectedFilters [
	self stackElement contextFilters: selectedFilters
]

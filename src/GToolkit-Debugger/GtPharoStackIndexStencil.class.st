"
I am a {{gtClass:BrStencil}}. 
I build a {{gtClass:BrColumnedList}} with three columns: class, method, and package.
The columned list expects {{gtClass:Context}} items.
"
Class {
	#name : #GtPharoStackIndexStencil,
	#superclass : #BrStencil,
	#instVars : [
		'labelBlock',
		'classDataBinder',
		'methodDataBinder',
		'packageDataBinder'
	],
	#category : #'GToolkit-Debugger-Elements'
}

{ #category : #factory }
GtPharoStackIndexStencil class >> contextClassText: aContext [
	| aResult |
	aResult := aContext receiver class printString.
	aContext receiver class == aContext methodClass
		ifFalse: [ aResult := aResult , '(' , aContext methodClass printString , ')' ].
	^ aResult 
]

{ #category : #factory }
GtPharoStackIndexStencil class >> contextMethodText: aContext [
	^ aContext isBlockContext
		ifTrue: [ '[] in ' , aContext outerContext method selector ]
		ifFalse: [ aContext method selector ]
]

{ #category : #factory }
GtPharoStackIndexStencil class >> contextPackageText: aContext [
	^ aContext method package ifNotNil: [ :aPackage | aPackage name ] ifNil: [ '' ]
]

{ #category : #accessing }
GtPharoStackIndexStencil >> create [
	| indexList |
	indexList := BrColumnedList new
			background: BrGlamorousColors neutralBackgroundColor;
			rowStencil: BrGlamorousColumnedListSelectableRowElementStencilBuilder new;
			matchParent.
	indexList column
		title: 'Class';
		matchParent;
		cellStencil: labelBlock;
		dataBinder: classDataBinder.
	indexList column
		title: 'Method';
		matchParent;
		cellStencil: labelBlock;
		dataBinder: methodDataBinder.
	indexList column
		title: 'Package';
		cellStencil: labelBlock;
		width: 100;
		dataBinder: packageDataBinder.
	indexList
		addAptitude: (BrColumnedListHeaderAptitude new
				labelStencil: [ :aColumn | 
					| label |
					label := BrLabel new
							aptitude: BrLabelAptitude;
							margin: (BlInsets right: 8);
							text: (aColumn title asRopedText
									glamorousRegularFont;
									fontSize: 12;
									foreground: Color gray).
					aColumn columnWidth applyOn: label.
					label ]).
	
	^ indexList
]

{ #category : #initialization }
GtPharoStackIndexStencil >> defaultClassDataBinder [
	^ [ :anElement :aContext | anElement text: (self class contextClassText: aContext) ]
]

{ #category : #initialization }
GtPharoStackIndexStencil >> defaultLabelBlock [
	^ [ BrLabel new
		margin: (BlInsets right: 10);
		aptitude: BrGlamorousLabelAptitude;
		beSmallSize;
		hMatchParent;
		vFitContent ]
]

{ #category : #initialization }
GtPharoStackIndexStencil >> defaultMethodDataBinder [
	^ [ :anElement :aContext | anElement text: (self class contextMethodText: aContext) ]
]

{ #category : #initialization }
GtPharoStackIndexStencil >> defaultPackageDataBinder [
	^ [ :anElement :aContext | anElement text: (self class contextPackageText: aContext) ]
]

{ #category : #initialization }
GtPharoStackIndexStencil >> initialize [
	super initialize.
	labelBlock := self defaultLabelBlock.
	classDataBinder := self defaultClassDataBinder.
	methodDataBinder := self defaultMethodDataBinder.
	packageDataBinder := self defaultPackageDataBinder.
]

"
I am a report that saves data about a debugger, stored with the report infrastructure (see {{gtClass:GtReportsStore}}).

I can contain:
- the methods on the stacks of the debug session ({{gtMethod:GtDebugSession>>#debuggerReportStacks}}); for example a GemStone session provides both the local and the remote stack;
- the debug log as written in the Pharo debug log ({{gtMethod:GtDebugSession>>#debuggerReportDebugLog}});
- a screenshot of the debugger.

What is saved depends on how I am created: {{gtMethod:GtDebuggerReport class>>#stackReportForSession:}} saves the stacks, while {{gtMethod:GtDebuggerReport class>>#debugLogReportForDebugger:}} saves the debug log, the stacks and a screenshot. Use {{gtMethod:GtDebuggerReport>>#hasStacks}}, {{gtMethod:GtDebuggerReport>>#hasDebugLog}} and {{gtMethod:GtDebuggerReport>>#hasScreenshot}} to check what is present.

The summary is written as JSON; each stack, the debug log and the screenshot are written in their own files.
"
Class {
	#name : #GtDebuggerReport,
	#superclass : #Object,
	#instVars : [
		'title',
		'exceptionClassName',
		'timestamp',
		'stacks',
		'debugLog',
		'screenshotBytes',
		'imageData',
		'reportUid',
		'exceptionDescription'
	],
	#category : #'GToolkit-Debugger-Reports'
}

{ #category : #accessing }
GtDebuggerReport class >> debugLogFileName [
	^ 'debug-log'
]

{ #category : #'instance creation' }
GtDebuggerReport class >> debugLogReportForDebugger: aDebuggerElement [
	"Create a report with the debug log of the session of the given debugger (see GtDebugSession>>#debuggerReportDebugLog),
	the stacks of the session (see GtDebugSession>>#debuggerReportStacks) and a screenshot of the debugger"

	| aDebugSession |
	aDebugSession := aDebuggerElement debugSession.

	^ self new
		recordImageData;
		recordDescriptionOfSession: aDebugSession;
		stacks: aDebugSession debuggerReportStacks;
		debugLog: aDebugSession debuggerReportDebugLog;
		recordScreenshotOf: aDebuggerElement;
		yourself
]

{ #category : #'instance creation' }
GtDebuggerReport class >> fromStoredFiles: aStoredReportFiles [
	| aReport aDebugLogFile aScreenshotFile |
	aReport := aStoredReportFiles readJson.

	aReport stacks
		do: [ :eachStack | 
			eachStack
				text: (aStoredReportFiles readTextNamed: eachStack name extension: 'txt') ].

	aDebugLogFile := aStoredReportFiles
			fileNamed: self debugLogFileName
			extension: 'txt'.
	aDebugLogFile exists ifTrue: [ aReport debugLog: aDebugLogFile contents ].

	aScreenshotFile := aStoredReportFiles
			fileNamed: self screenshotFileName
			extension: 'png'.
	aScreenshotFile exists
		ifTrue: [ aReport
				screenshotBytes: (aStoredReportFiles readBytesNamed: self screenshotFileName extension: 'png') ].

	^ aReport
]

{ #category : #serialization }
GtDebuggerReport class >> leJsonV4AttributeMapping [
	"The debug log and the screenshot are stored in their own files, as are the texts of the stacks"

	^ #(#title #exceptionClassName #exceptionDescription #timestamp #stacks #imageData #reportUid)
		collect: [ :each | each -> each ]
]

{ #category : #serialization }
GtDebuggerReport class >> leJsonV4Name [
	^ #gtDebuggerReport
]

{ #category : #accessing }
GtDebuggerReport class >> screenshotFileName [
	^ 'screenshot'
]

{ #category : #'instance creation' }
GtDebuggerReport class >> stackReportForSession: aDebugSession [
	"Create a report with the methods on the stacks of the given debug session.
	The debug session decides which stacks are included (see GtDebugSession>>#debuggerReportStacks)"

	^ self new
		recordImageData;
		recordDescriptionOfSession: aDebugSession;
		stacks: aDebugSession debuggerReportStacks;
		yourself
]

{ #category : #accessing }
GtDebuggerReport >> debugLog [
	^ debugLog
]

{ #category : #accessing }
GtDebuggerReport >> debugLog: aString [
	debugLog := aString
]

{ #category : #accessing }
GtDebuggerReport >> exceptionClassName [
	^ exceptionClassName
]

{ #category : #accessing }
GtDebuggerReport >> exceptionClassName: aString [
	exceptionClassName := aString
]

{ #category : #accessing }
GtDebuggerReport >> exceptionDescription [
	"Return the description of the exception that was debugged (see Exception>>#description), or nil if there was no exception"

	^ exceptionDescription
]

{ #category : #accessing }
GtDebuggerReport >> exceptionDescription: aString [
	exceptionDescription := aString
]

{ #category : #'gt - extensions' }
GtDebuggerReport >> gtDebugLogFor: aView [
	<gtView>
	debugLog ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Debug log';
		priority: 15;
		text: [ debugLog asRopedText glamorousCodeFontAndSize ]
]

{ #category : #'gt - extensions' }
GtDebuggerReport >> gtImageDataFor: aView [
	<gtView>
	^ aView forward
		title: 'Image data';
		priority: 30;
		object: [ imageData ];
		view: #gtSummaryFor:
]

{ #category : #'gt - extensions' }
GtDebuggerReport >> gtJsonFor: aView [
	<gtView>
	^ aView forward
		title: 'JSON';
		priority: 50;
		object: [ GtJson forJsonString: (LeJsonV4 uniqueInstance serializePretty: self) ];
		view: #gtJsonStringFor:
]

{ #category : #'gt - extensions' }
GtDebuggerReport >> gtSaveLocallyActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousVectorIcons savetodisk;
		tooltip: 'Save the report locally';
		action: [ :aButton | aButton phlow spawnObject: (self storeIn: GtReportsLocalStore default) ]
]

{ #category : #'gt - extensions' }
GtDebuggerReport >> gtScreenshotFor: aView [
	<gtView>
	screenshotBytes ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Screenshot';
		priority: 20;
		stencil: [ self screenshotForm asElement asScalableElement ]
]

{ #category : #'gt - extensions' }
GtDebuggerReport >> gtStackFor: aView [
	"Show the main stack of the report: the first stack given by the debug session (see GtDebugSession>>#debuggerReportStacks)"

	<gtView>
	self hasStacks ifFalse: [ ^ aView empty ].
	^ aView forward
		title: 'Stack';
		priority: 10;
		object: [ stacks first ];
		view: #gtTextFor:
]

{ #category : #'gt - extensions' }
GtDebuggerReport >> gtStacksFor: aView [
	<gtView>
	self hasStacks ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Stacks';
		priority: 25;
		items: [ stacks ];
		column: 'Name' text: [ :each | each name ];
		column: 'Lines'
			text: [ :each | each numberOfLines ]
			width: 80
]

{ #category : #'gt - extensions' }
GtDebuggerReport >> gtStorageFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Storage';
		priority: 40;
		items: [ OrderedCollection new
				add: 'Report type' -> self reportType;
				add: 'Local folder' -> (GtReportsLocalStore default folderForType: self reportType);
				yourself ];
		column: 'Attribute' text: [ :each | each key ];
		column: 'Value' text: [ :each | each value ];
		send: [ :each | each value ]
]

{ #category : #'gt - extensions' }
GtDebuggerReport >> gtSummaryFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Summary';
		priority: 5;
		items: [ self summaryAttributes ];
		column: 'Attribute'
			text: [ :each | each key ]
			width: 150;
		column: 'Value' text: [ :each | each value ifNil: [ '-' ] ];
		send: [ :each | each value ]
]

{ #category : #testing }
GtDebuggerReport >> hasDebugLog [
	^ debugLog notNil
]

{ #category : #testing }
GtDebuggerReport >> hasScreenshot [
	^ screenshotBytes notNil
]

{ #category : #testing }
GtDebuggerReport >> hasStacks [
	^ stacks notEmpty
]

{ #category : #accessing }
GtDebuggerReport >> imageData [
	^ imageData
]

{ #category : #accessing }
GtDebuggerReport >> imageData: aReportImageData [
	imageData := aReportImageData
]

{ #category : #initialization }
GtDebuggerReport >> initialize [
	super initialize.

	stacks := #().
	timestamp := DateAndTime now.
	imageData := GtReportImageData new.
	reportUid := UUID new
]

{ #category : #printing }
GtDebuggerReport >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [ aStream nextPutAll: title asString ]
]

{ #category : #recording }
GtDebuggerReport >> recordDescriptionOfSession: aDebugSession [
	title := aDebugSession name.
	aDebugSession exception
		ifNotNil: [ :anException | 
			exceptionClassName := anException class name asString.
			exceptionDescription := anException description ]
]

{ #category : #recording }
GtDebuggerReport >> recordImageData [
	imageData := GtReportImageData current
]

{ #category : #recording }
GtDebuggerReport >> recordScreenshotOf: anElement [
	| aForm |
	aForm := BlExporter form
			element: anElement;
			export.

	screenshotBytes := ByteArray
			streamContents: [ :aStream | PNGReadWriter putForm: aForm onStream: aStream ]
]

{ #category : #accessing }
GtDebuggerReport >> reportType [
	^ 'debugger'
]

{ #category : #accessing }
GtDebuggerReport >> reportUid [
	^ reportUid
]

{ #category : #accessing }
GtDebuggerReport >> reportUid: aUUID [
	reportUid := aUUID
]

{ #category : #accessing }
GtDebuggerReport >> screenshotBytes [
	"Return the screenshot of the debugger as PNG bytes"

	^ screenshotBytes
]

{ #category : #accessing }
GtDebuggerReport >> screenshotBytes: aByteArray [
	screenshotBytes := aByteArray
]

{ #category : #accessing }
GtDebuggerReport >> screenshotForm [
	^ screenshotBytes
		ifNotNil: [ :aByteArray | PNGReadWriter formFromStream: aByteArray readStream ]
]

{ #category : #accessing }
GtDebuggerReport >> stackNamed: aName [
	^ stacks detect: [ :each | each name = aName ]
]

{ #category : #accessing }
GtDebuggerReport >> stackNamed: aName ifNone: aBlock [
	^ stacks detect: [ :each | each name = aName ] ifNone: aBlock
]

{ #category : #accessing }
GtDebuggerReport >> stacks [
	"Return a collection of GtDebuggerReportStack"

	^ stacks
]

{ #category : #accessing }
GtDebuggerReport >> stacks: aCollectionOfStacks [
	stacks := aCollectionOfStacks asArray
]

{ #category : #storing }
GtDebuggerReport >> storeIn: aStore [
	^ aStore store: self
]

{ #category : #'gt - extensions' }
GtDebuggerReport >> summaryAttributes [
	^ OrderedCollection new
		add: 'Title' -> title;
		add: 'Exception class' -> exceptionClassName;
		add: 'Exception description' -> exceptionDescription;
		add: 'Timestamp' -> timestamp;
		add: 'Stacks'
				-> (self hasStacks
						ifTrue: [ stacks collect: [ :each | each name ] ]
						ifFalse: [ nil ]);
		add: 'Debug log'
				-> (debugLog ifNotNil: [ :aString | aString lines size printString , ' lines' ]);
		add: 'Screenshot'
				-> (screenshotBytes
						ifNotNil: [ :aByteArray | aByteArray size printString , ' bytes' ]);
		yourself
]

{ #category : #accessing }
GtDebuggerReport >> timestamp [
	^ timestamp
]

{ #category : #accessing }
GtDebuggerReport >> timestamp: aDateAndTime [
	timestamp := aDateAndTime
]

{ #category : #accessing }
GtDebuggerReport >> title [
	"Return the title of the debugger, given by the name of the debug session"

	^ title
]

{ #category : #accessing }
GtDebuggerReport >> title: aString [
	title := aString
]

{ #category : #storing }
GtDebuggerReport >> writeFilesTo: anEntry [
	stacks
		do: [ :eachStack | 
			anEntry
				writeText: eachStack text
				named: eachStack name
				extension: 'txt' ].

	debugLog
		ifNotNil: [ anEntry
				writeText: debugLog
				named: self class debugLogFileName
				extension: 'txt' ].

	screenshotBytes
		ifNotNil: [ anEntry
				writeBytes: screenshotBytes
				named: self class screenshotFileName
				extension: 'png' ].

	anEntry writeJsonOf: self
]

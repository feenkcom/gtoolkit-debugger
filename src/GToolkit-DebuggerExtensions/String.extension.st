Extension { #name : #String }

{ #category : #'*GToolkit-DebuggerExtensions' }
String >> gtDebuggerPrintForComparisonOn: aStream [
	aStream << self asString
]

Class {
	#name : #GtRBRewriteNotification,
	#superclass : #Notification,
	#instVars : [
		'rewriter',
		'node'
	],
	#category : #'GToolkit-Debugger-RB'
}

{ #category : #'instance creation' }
GtRBRewriteNotification class >> forRewriter: aRewriter andNode: aNode [
	^ self new
		rewriter: aRewriter;
		node: aNode;
		yourself
]

{ #category : #accessing }
GtRBRewriteNotification >> node [
	^ node
]

{ #category : #accessing }
GtRBRewriteNotification >> node: anObject [
	node := anObject
]

{ #category : #accessing }
GtRBRewriteNotification >> rewriter [
	^ rewriter
]

{ #category : #accessing }
GtRBRewriteNotification >> rewriter: anObject [
	rewriter := anObject
]

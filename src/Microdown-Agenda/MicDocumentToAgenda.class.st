"
I'm a visitor transforming a standard microdown document describing an agenda to an AST with Microdown agenda nodes
"
Class {
	#name : #MicDocumentToAgenda,
	#superclass : #Object,
	#instVars : [
		'agenda',
		'currentElement'
	],
	#category : #'Microdown-Agenda'
}

{ #category : #accessing }
MicDocumentToAgenda >> agenda [

	^ agenda
]

{ #category : #accessing }
MicDocumentToAgenda >> agenda: aMicAgenda [ 
	agenda := aMicAgenda
]

{ #category : #converting }
MicDocumentToAgenda >> attributesFromList: anUnorderedList [

	| dict |
	dict := Dictionary new.
	anUnorderedList children do: [ :listItem | | separatorIndex text value |
		text := listItem text.
		separatorIndex := listItem text indexOf: $:.
		value := listItem hasChildren
			ifTrue: [ self attributesFromList: listItem children second ] 
			ifFalse: [ (text allButFirst: separatorIndex) trimmed ].
		dict at: (text first: separatorIndex - 1) put: value ].
	^ dict 
]

{ #category : #visiting }
MicDocumentToAgenda >> visit: aMicElement [

	^ aMicElement accept: self
]

{ #category : #visiting }
MicDocumentToAgenda >> visitAgenda: aMicHeaderBlock [ 
	
	agenda := MicAgenda new
		name: aMicHeaderBlock headerElements first text;
		yourself.
		
	currentElement := agenda
]

{ #category : #visiting }
MicDocumentToAgenda >> visitChildrenOf: anElement [

	^ anElement children collect: [ :each | each accept: self ]
]

{ #category : #visiting }
MicDocumentToAgenda >> visitDay: aMicHeaderBlock [

	currentElement := agenda newDay:
		                  aMicHeaderBlock headerElements first text
]

{ #category : #visiting }
MicDocumentToAgenda >> visitHeader: aHeader [

	aHeader level = 1 
		ifTrue: [ ^ self visitAgenda: aHeader ].
	aHeader level = 2
		ifTrue: [ ^ self visitDay: aHeader ].
	aHeader level = 3
		ifTrue: [ ^ self visitSegment: aHeader ].
	self visitSegmentElement: aHeader.
]

{ #category : #visiting }
MicDocumentToAgenda >> visitRoot: aRoot [

	^ self visitChildrenOf: aRoot
]

{ #category : #visiting }
MicDocumentToAgenda >> visitSegment: aMicHeaderBlock [

	currentElement := agenda newSegment: aMicHeaderBlock headerElements first text
]

{ #category : #visiting }
MicDocumentToAgenda >> visitSegmentElement: aMicHeaderBlock [

	currentElement := self agenda newSegmentElement: aMicHeaderBlock headerElements first text.

]

{ #category : #visiting }
MicDocumentToAgenda >> visitUnorderedList: anUnorderedList [

	currentElement addAttributes: (self attributesFromList: anUnorderedList)
]

{ #category : #visiting }
MicDocumentToAgenda >> visitUnorderedListItem: anItem [

	^ self visitChildrenOf: anItem
]

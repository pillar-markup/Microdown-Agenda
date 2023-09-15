"
I'm an abstract element.
My subclasses are part of a day segment.
"
Class {
	#name : #MicSegmentElement,
	#superclass : #MicAgendaElement,
	#instVars : [
		'room',
		'length',
		'agenda'
	],
	#category : #'Microdown-Agenda'
}

{ #category : #'instance creation' }
MicSegmentElement class >> named: aString [ 
	
	^ aString asLowercase = #break
		ifTrue: [ MicBreak new ]
		ifFalse: [ MicTalk named: aString ]
]

{ #category : #adding }
MicSegmentElement >> addAttributes: aDictionary [

	aDictionary
		at: #length ifPresent: [ :value | length := Duration minutes: value asInteger ];
		at: #room ifPresent: [ :value | room := self symbolFromString: value ]
]

{ #category : #accessing }
MicSegmentElement >> agenda: anAgenda [ 
	
	agenda := anAgenda 
]

{ #category : #testing }
MicSegmentElement >> isBreak [

	^ false
]

{ #category : #accessing }
MicSegmentElement >> length [
	^ length ifNil: [ agenda defaultTalkLength ]
]

{ #category : #accessing }
MicSegmentElement >> length: anInteger [ 
	length := anInteger
]

{ #category : #accessing }
MicSegmentElement >> link [
	^ nil
]

{ #category : #accessing }
MicSegmentElement >> room [
	^ room ifNil: [ agenda defaultRoom ]
]

{ #category : #accessing }
MicSegmentElement >> room: aString [ 
	room := aString
]

{ #category : #accessing }
MicSegmentElement >> roomName [
	
	^ agenda rooms 
		at: self room
		ifPresent: [ :roomName | roomName ]
		ifAbsent: [ self room ]
]

{ #category : #accessing }
MicSegmentElement >> speaker [

	self subclassResponsibility
]

{ #category : #adding }
MicSegmentElement >> symbolFromString: value [

	^ (value beginsWith: '#')
		  ifTrue: [ value allButFirst asSymbol ]
		  ifFalse: [ value asSymbol ]
]

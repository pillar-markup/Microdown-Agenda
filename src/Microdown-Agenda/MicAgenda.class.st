"
I represent the agenda of a conference.
I'm composed of one or many days.
I have a start day, a default talk length and a list of rooms used for the conference.
"
Class {
	#name : #MicAgenda,
	#superclass : #MicAgendaElement,
	#instVars : [
		'days',
		'rooms',
		'defaultTalkLength',
		'defaultRoom'
	],
	#category : #'Microdown-Agenda'
}

{ #category : #visiting }
MicAgenda >> accept: aVisitor [ 
	
	aVisitor visitAgenda: self
]

{ #category : #adding }
MicAgenda >> addAttributes: aDictionary [

	aDictionary 
		at: #defaultTalkLength ifPresent: [ :value | defaultTalkLength := Duration minutes: value asInteger ];
		at: #defaultRoom ifPresent: [ :value | defaultRoom := value ];
		at: #rooms ifPresent: [ :value | rooms := value ]
]

{ #category : #accessing }
MicAgenda >> days [
	
	^ days
]

{ #category : #accessing }
MicAgenda >> defaultRoom [
	^ defaultRoom
]

{ #category : #accessing }
MicAgenda >> defaultRoom: aString [ 
	defaultRoom := aString
]

{ #category : #accessing }
MicAgenda >> defaultTalkLength [
	^ defaultTalkLength
]

{ #category : #accessing }
MicAgenda >> defaultTalkLength: anInteger [ 
	defaultTalkLength := anInteger
]

{ #category : #initialization }
MicAgenda >> initialize [ 

	super initialize.
	days := OrderedCollection new.
	rooms := Dictionary new.
	defaultTalkLength := 30
]

{ #category : #accessing }
MicAgenda >> lastDay [
	
	^ self days last
]

{ #category : #accessing }
MicAgenda >> lastSegment [
	
	^ self lastDay segments last
]

{ #category : #adding }
MicAgenda >> newDay: aDayString [
	
	| day |
	day := MicDay new
		name: aDayString;
		agenda: self;
		yourself.
	
	days add: day.
	^ day
]

{ #category : #adding }
MicAgenda >> newSegment: aMicAgendaSegment [ 
	
	self lastDay newSegment: aMicAgendaSegment
]

{ #category : #'instance creation' }
MicAgenda >> newSegmentElement: aString [ 
	| element |
	element := (MicSegmentElement named: aString)
		agenda: self;
		yourself.
	
	self lastSegment addElement: element.
	^ element
]

{ #category : #accessing }
MicAgenda >> roomIds [
	
	^ self rooms keys
]

{ #category : #accessing }
MicAgenda >> rooms [
	^ rooms
]

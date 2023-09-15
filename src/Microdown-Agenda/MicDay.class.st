"
I represent a day in a conference agenda.
I'm composed of day segments.
"
Class {
	#name : #MicDay,
	#superclass : #MicAgendaElement,
	#instVars : [
		'segments',
		'agenda'
	],
	#category : #'Microdown-Agenda'
}

{ #category : #visiting }
MicDay >> accept: aVisitor [ 
	
	aVisitor visitDay: self
]

{ #category : #adding }
MicDay >> addAttributes: aDictionary [

	"No attributes on Agenda days"
]

{ #category : #adding }
MicDay >> addSegment: anAgendaSegment [ 
	
	segments add: anAgendaSegment
]

{ #category : #accessing }
MicDay >> agenda: anAgenda [

	agenda := anAgenda
]

{ #category : #initialization }
MicDay >> initialize [ 

	super initialize.
	segments := OrderedCollection new
]

{ #category : #'instance creation' }
MicDay >> newSegment: aString [ 
	
	| segment |
	segment := MicAgendaSegment new
		name: aString;
		agenda: agenda;
		yourself.
	segments add: segment.
	^ segment
]

{ #category : #accessing }
MicDay >> segments [
	^ segments
]

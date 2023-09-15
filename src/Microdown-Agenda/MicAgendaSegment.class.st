"
I represent a segment of a day in a conference agenda.
I'm composed of talks and breaks and I have a start time.
"
Class {
	#name : #MicAgendaSegment,
	#superclass : #MicAgendaElement,
	#instVars : [
		'elements',
		'agenda'
	],
	#category : #'Microdown-Agenda'
}

{ #category : #visiting }
MicAgendaSegment >> accept: aVisitor [ 
	
	aVisitor visitSegment: self
]

{ #category : #adding }
MicAgendaSegment >> addElement: aSegmentElement [

	elements add: aSegmentElement 
]

{ #category : #accessing }
MicAgendaSegment >> agenda: anAgenda [ 
	
	agenda := anAgenda
]

{ #category : #accessing }
MicAgendaSegment >> elements [
	^ elements
]

{ #category : #initialization }
MicAgendaSegment >> initialize [ 

	super initialize.
	elements := OrderedCollection new
]

{ #category : #accessing }
MicAgendaSegment >> startTime [ 

	^ self name asTime
]

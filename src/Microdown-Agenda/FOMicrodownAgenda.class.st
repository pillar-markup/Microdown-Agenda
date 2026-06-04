"
I'm a file written in Microdown to represent a conference agenda.
I'm used by Foliage as a model entity of a web site.
In this file, microdown syntax is used like a DSL to define the agenda.
"
Class {
	#name : 'FOMicrodownAgenda',
	#superclass : 'FOPageWithMetadata',
	#instVars : [
		'agenda'
	],
	#category : 'Microdown-Agenda-Foliage',
	#package : 'Microdown-Agenda',
	#tag : 'Foliage'
}

{ #category : 'accessing' }
FOMicrodownAgenda class >> supportedFileExtensions [
	^ #( mda ) 
]

{ #category : 'visiting' }
FOMicrodownAgenda >> acceptFOVisitor: aFOVisitor [

	^ aFOVisitor visitMicrodownAgenda: self 
]

{ #category : 'accessing' }
FOMicrodownAgenda >> agenda [
	^ agenda
]

{ #category : 'accessing' }
FOMicrodownAgenda >> agenda: anAgendaDescription [

	agenda := anAgendaDescription
]

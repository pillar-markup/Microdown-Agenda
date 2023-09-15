"
I represent an agenda element and I have a name.
"
Class {
	#name : #MicAgendaElement,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Microdown-Agenda'
}

{ #category : #visiting }
MicAgendaElement >> accept: aVisitor [

	self subclassResponsibility
]

{ #category : #adding }
MicAgendaElement >> addAttributes: aDictionary [

	self subclassResponsibility
]

{ #category : #accessing }
MicAgendaElement >> name [

	^ name
]

{ #category : #accessing }
MicAgendaElement >> name: aString [

	name := aString
]

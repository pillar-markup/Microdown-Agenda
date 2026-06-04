"
I'm a Microdown plugin to manage Conference Agenda.
I use some predefined HTML templates to render nicely an agenda in HTML.
"
Class {
	#name : 'MicAgendaDescription',
	#superclass : 'MicEnvironmentBlock',
	#category : 'Microdown-Agenda-Plugin',
	#package : 'Microdown-Agenda',
	#tag : 'Plugin'
}

{ #category : 'accessing' }
MicAgendaDescription class >> tag [

	^ 'agenda'
]

{ #category : 'visiting' }
MicAgendaDescription >> accept: aVisitor [
	
	aVisitor visitRoot: self.
]

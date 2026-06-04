"
I'm responsible of handling generation of HTML for an agenda
"
Class {
	#name : 'MicAgendaPluginHandler',
	#superclass : 'FOPluginHandler',
	#category : 'Microdown-Agenda-Plugin',
	#package : 'Microdown-Agenda',
	#tag : 'Plugin'
}

{ #category : 'description' }
MicAgendaPluginHandler class >> kind [

	^ 'agenda'
]

{ #category : 'operate' }
MicAgendaPluginHandler >> treat: aFOMicrodownAgenda [
	
	"nothing to do. Generation will come in publish phase"
]

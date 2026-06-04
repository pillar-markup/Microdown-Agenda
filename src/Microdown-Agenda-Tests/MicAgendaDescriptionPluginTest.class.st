Class {
	#name : 'MicAgendaDescriptionPluginTest',
	#superclass : 'TestCase',
	#category : 'Microdown-Agenda-Tests',
	#package : 'Microdown-Agenda-Tests'
}

{ #category : 'tests' }
MicAgendaDescriptionPluginTest >> testPluginCanParseMdToAgenda [

	| md doc agenda |
	md := String streamContents: [ :stream |
		stream 
			nextPutAll: '<!agenda'; cr;
			nextPutAll: MicAgendaGeneratorTest new agendaExempleOneTalk; cr;
			nextPutAll: '!>' ].
		
	doc := Microdown parse: md.
	agenda := (MicDocumentToAgenda new visit: doc; yourself) agenda.
	self assert: agenda class equals: MicAgenda.
	self assert: agenda days size equals: 1.
	self assert: agenda name equals: 'A cool agenda'.
	self assert: agenda roomIds equals: #('room1')
]

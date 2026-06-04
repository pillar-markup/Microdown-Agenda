Extension { #name : 'FOPublishVisitor' }

{ #category : '*Microdown-Agenda' }
FOPublishVisitor >> visitMicrodownAgenda: aFOMicrodownAgenda [

	| doc agenda |
	doc := aFOMicrodownAgenda agenda.
	agenda := (MicDocumentToAgenda new visit: doc; yourself) agenda.
	
	MicAgendaHtmlGenerator new
		buildAgenda: agenda 
		outputDir: aFOMicrodownAgenda publishPath parent
		name: (aFOMicrodownAgenda name withoutSuffix: '.mda').

	^ aFOMicrodownAgenda
]

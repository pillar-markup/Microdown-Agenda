Extension { #name : 'FOPublishVisitor' }

{ #category : '*Microdown-Agenda' }
FOPublishVisitor >> visitMicrodownAgenda: aFOMicrodownAgenda [

	| doc agenda |
	doc := aFOMicrodownAgenda agenda.
	agenda := (MicDocumentToAgenda new visit: doc; yourself) agenda.
	aFOMicrodownAgenda htmlGenerator buildAgenda: agenda.

	^ aFOMicrodownAgenda
]

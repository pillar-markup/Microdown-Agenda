"
Once we will have migrated to MicrodownV2 we will see.
"
Class {
	#name : 'FOMicrodownAgendaReader',
	#superclass : 'FOMicrodownV2Reader',
	#category : 'Microdown-Agenda',
	#package : 'Microdown-Agenda'
}

{ #category : 'testing' }
FOMicrodownAgendaReader class >> supportedFileExtensions [
	^ #( mda )
]

{ #category : 'reading' }
FOMicrodownAgendaReader >> createModelEntity [
	
	| rootBlock |
	rootBlock := self readDocumentFrom: self stream.
	^ FOMicrodownAgenda new
		sourcePath: file asPath;
		meta: rootBlock children first;
		agenda: rootBlock children second. 
	
]

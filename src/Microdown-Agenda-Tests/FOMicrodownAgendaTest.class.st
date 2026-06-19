Class {
	#name : 'FOMicrodownAgendaTest',
	#superclass : 'TestCase',
	#category : 'Microdown-Agenda-Tests',
	#package : 'Microdown-Agenda-Tests'
}

{ #category : 'accessing' }
FOMicrodownAgendaTest class >> resources [ 

	^ { MicAgendaSimpleResource }
]

{ #category : 'running' }
FOMicrodownAgendaTest >> tearDown [ 
	MicAgendaSimpleResource reset.
	super tearDown
]

{ #category : 'tests' }
FOMicrodownAgendaTest >> testAgendaHtmlIsGeneratedInRightDirectoryWhenRelativeFileRef [

	| agenda generator |
	MicAgendaSimpleResource current agendaPath: 'foo/bar'.
	agenda := MicAgendaSimpleResource current agendaExampleOneTalk.
	generator := agenda htmlGenerator.
	
	self assert: agenda publishPath equals: agenda website targetPath / 'foo' / 'bar' / 'example-one-agenda.mda'.
	self assert: agenda resourcesRelativePath equals: '../../'.
	self assert: generator resourcesOutputPath equals: '../../resources/agenda'
]

{ #category : 'tests' }
FOMicrodownAgendaTest >> testDefaultResourcesRelativePath [

	| agenda |
	
	agenda := MicAgendaSimpleResource current agendaExampleOneTalk. 
	
	self assert: agenda resourcesRelativePath equals: Path workingDirectory
]

{ #category : 'tests' }
FOMicrodownAgendaTest >> testResourcesRelativePathWhenAgendaNotInRootFolder [

	| agenda |
	MicAgendaSimpleResource current agendaPath: 'a/b'.
	agenda := MicAgendaSimpleResource current agendaExampleOneTalk. 
	
	self assert: agenda resourcesRelativePath equals: Path * 'a' / 'b'
]

"
`MicAgendaSimpleResource new agendaExampleOneTalk`
"
Class {
	#name : 'MicAgendaSimpleResource',
	#superclass : 'TestResource',
	#instVars : [
		'agendaExampleOneTalk',
		'root',
		'agendaPath',
		'srcDirectory'
	],
	#category : 'Microdown-Agenda-Tests',
	#package : 'Microdown-Agenda-Tests'
}

{ #category : 'accessing' }
MicAgendaSimpleResource >> agendaExampleOneTalk [

	| agendaPathSegments agendaFolder website |
	agendaExampleOneTalk ifNotNil: [ ^ agendaExampleOneTalk ].
	website := self buildWebSite.
	agendaPathSegments := (website fileSystem resolve: agendaPath) segments.
	agendaFolder := website resolvePath: (RelativePath withAll: agendaPathSegments).
	^ agendaFolder items at: self agendaFileName 
]

{ #category : 'accessing' }
MicAgendaSimpleResource >> agendaFileName [

	^ 'example-one-agenda.mda'
]

{ #category : 'accessing' }
MicAgendaSimpleResource >> agendaPath: aPath [

	agendaPath := aPath
]

{ #category : 'creating' }
MicAgendaSimpleResource >> buildWebSite [

	| website |

	self createAgendaFileIn: srcDirectory / agendaPath / self agendaFileName.
	website := FOWebSite new
		           fileSystem: root fileSystem;
		           targetPath: './target';
		           sourcePath: './src';
		           importFiles;
		           yourself.
	^ website
]

{ #category : 'creating' }
MicAgendaSimpleResource >> createAgendaFileIn: aFileReference [

	self ensureCreateDirectory: aFileReference parent.
	aFileReference writeStreamDo: [ :stream |
		stream 
			nextPutAll: '{
"title" : "Google Summer of Code Agenda",
"layout" : "agenda",
"plugin" : [ "kind" : "agenda" ]
}'; cr;
			nextPutAll: self markdownAgendaExampleOneTalk ]
]

{ #category : 'helpers' }
MicAgendaSimpleResource >> ensureCreateDirectory: aFileReference [ 
	
	aFileReference exists ifTrue: [ ^ aFileReference ].
	
	aFileReference parent exists
		ifFalse: [ self ensureCreateDirectory: aFileReference parent ].
	aFileReference ensureCreateDirectory.
		
	^ aFileReference
]

{ #category : 'initialization' }
MicAgendaSimpleResource >> initialize [

	super initialize.
	root := FileSystem memory root.
	srcDirectory := (root / 'src') ensureCreateDirectory.
	agendaPath := '.'
]

{ #category : 'accessing' }
MicAgendaSimpleResource >> markdownAgendaExampleOneTalk [

	 ^ '<!agenda
#A cool agenda
- rooms:
  - room1: Room One, Building A

## 3 march 2023

### 10:30

#### First talk
- length: 30
- speaker: Grace Hopper
- room: #room1
!>'
]

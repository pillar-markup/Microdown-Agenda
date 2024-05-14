"
From a Microdown-described agenda, generates a pillar file with MicAgenda extensions.
This is oly useful till we get the HTML generator fully working.

```
MicAgendaPillarGenerator on: './esug.github.io/2024-Conference/agenda.md' asFileReference
```
"
Class {
	#name : #MicAgendaPillarGenerator,
	#superclass : #MicHTMLVisitor,
	#instVars : [
		'output'
	],
	#category : #'Microdown-Agenda'
}

{ #category : #'instance creation' }
MicAgendaPillarGenerator class >> from: anAgenda [

	| generator |
	generator := self new.
	^ String streamContents: [ :stream |	
		generator output: stream.
		generator visitAgenda: anAgenda ]
		

]

{ #category : #'instance creation' }
MicAgendaPillarGenerator class >> on: aMicAgendaFileReference [
	| root agenda |
	root :=  Microdown parse: aMicAgendaFileReference contents.
	agenda := (MicDocumentToAgenda new visit: root; yourself) agenda.
	^ self from: agenda

]

{ #category : #visiting }
MicAgendaPillarGenerator >> closeTag [
	output nextPutAll: '!>'; cr.
]

{ #category : #accessing }
MicAgendaPillarGenerator >> output: aStream [

	output := aStream
]

{ #category : #visiting }
MicAgendaPillarGenerator >> visitAgenda: anAgenda [

	output 
		nextPutAll: '<!agenda|title=';
		nextPutAll: anAgenda name;
		cr.	
	anAgenda days do: [ :day | day accept: self ].
	self closeTag.
	

]

{ #category : #visiting }
MicAgendaPillarGenerator >> visitBreak: aSegment [

	output
		cr; 
		nextPutAll: '<!break|subject=';
		nextPutAll: aSegment name;
		nextPutAll: '&length=';
		nextPutAll: aSegment length minutes asString;
		nextPutAll: '&room=';
		nextPutAll: aSegment room.
	self closeTag.
	output cr
]

{ #category : #visiting }
MicAgendaPillarGenerator >> visitDay: aDay [

	output 
		nextPutAll: '<!day|start=';
		nextPutAll: aDay name; 
		cr.
	aDay segments do: [ :segment | segment accept: self ].
	self closeTag.
]

{ #category : #visiting }
MicAgendaPillarGenerator >> visitSegment: aSegment [

	output 
		cr;
		nextPutAll: '<!segment|start=';
		nextPutAll: (aSegment startTime print24 allButLast: 3);
		cr.
	aSegment elements do: [ :element | element accept: self ].
	self closeTag
]

{ #category : #visiting }
MicAgendaPillarGenerator >> visitTalk: aTalk [

	output 
		nextPutAll: '<!talk|subject=';
		nextPutAll: aTalk name;
		nextPutAll: '&author=';
		nextPutAll: aTalk speaker;
		nextPutAll: '&length=';
		nextPutAll: aTalk length minutes asString;
		nextPutAll: '&room=';
		nextPutAll: aTalk room.
	self closeTag
]

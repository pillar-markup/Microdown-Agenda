Class {
	#name : 'MicAgendaPublicationTest',
	#superclass : 'TestCase',
	#instVars : [
		'publisher',
		'root'
	],
	#category : 'Microdown-Agenda-Tests',
	#package : 'Microdown-Agenda-Tests'
}

{ #category : 'helpers' }
MicAgendaPublicationTest >> assertOutputDirectoryContains: aStringPath [

	self 
		assert: (self outputDirectory / aStringPath) exists
		description: 'Missing output file ', aStringPath 
]

{ #category : 'helpers' }
MicAgendaPublicationTest >> createAgendaFile [

	(self srcDirectory / 'agenda.mda') writeStreamDo: [ :stream |
		stream 
			nextPutAll:'{
"title" : "Google Summer of Code Agenda",
"layout" : "agenda",
"plugin" : [ "kind" : "agenda" ]
}'; cr;
nextPutAll: '<!agenda'; cr;
			nextPutAll: MicAgendaGeneratorTest new agendaExempleOneTalk; cr;
			nextPutAll: '!>' ]
]

{ #category : 'helpers' }
MicAgendaPublicationTest >> createFoliageConfiguration [

	(self srcDirectory / 'FoliageConfig.json') writeStreamDo: [ :stream |
		stream 
			nextPutAll: '{ #baseUri : ''http://esug.org'' }' ]
]

{ #category : 'helpers' }
MicAgendaPublicationTest >> createFooterTemplate [

	(self templateDirectory / 'footer') writeStreamDo: [ :stream |
		stream 
			nextPutAll:'<br>
<p>
<a href="{{{webRootPrefix}}}/index.html">Home</a>' ]
]

{ #category : 'helpers' }
MicAgendaPublicationTest >> createHeadTemplate [

	(self templateDirectory / 'head') writeStreamDo: [ :stream |
		stream 
			nextPutAll:'<head>
	    <meta charset="UTF-8" />
	    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
	    <title>Some title</title>
	</head>' ]
]

{ #category : 'helpers' }
MicAgendaPublicationTest >> createMdFileNamed: aName [

	(self srcDirectory / (aName, '.md')) writeStreamDo: [ :stream |
		stream 
			nextPutAll:'{
"title" : "Google Summer of Code",
"layout" : "default",
"publishDate" : "2019-05-51"
}'; cr;
			nextPutAll: '# ';
			nextPutAll: aName ]
]

{ #category : 'helpers' }
MicAgendaPublicationTest >> createTemplateNamed: aName [

	(self templateDirectory / aName) writeStreamDo: [ :stream |
		stream 
			nextPutAll:'<!DOCTYPE HTML>
<html>
	{{> head }}
	<body>
	<div id="mainContent">
		
	{{{body}}}
	
	{{> footer }}
	
	</div>
	
	</body>
	
</html>' ]
]

{ #category : 'accessing' }
MicAgendaPublicationTest >> fileSystemRoot [ 

	^ root
]

{ #category : 'accessing' }
MicAgendaPublicationTest >> outputDirectory [ 

	^ root / publisher targetPath
]

{ #category : 'running' }
MicAgendaPublicationTest >> setUp [

	super setUp.

	root :=  FileSystem memory root.
	publisher := FOPublisher new
		             baseUri: 'http://pharo.org';
		             fileSystem: root fileSystem;
		             targetPath: 'output';
		             templatePath: 'templates';
		             sourcePath: 'src'.
	self srcDirectory ensureCreateDirectory.
	self createFoliageConfiguration.
	self createHeadTemplate.
	self createFooterTemplate.
	self createTemplateNamed: 'default'.
	self createTemplateNamed: 'agenda'
]

{ #category : 'accessing' }
MicAgendaPublicationTest >> srcDirectory [ 

	^ root / publisher sourcePath
]

{ #category : 'accessing' }
MicAgendaPublicationTest >> templateDirectory [ 

	^ (root / publisher siteTemplatePath) ensureCreateDirectory
]

{ #category : 'tests' }
MicAgendaPublicationTest >> testAgendaPublication [

	self createMdFileNamed: 'foo'.
	self createAgendaFile.
	publisher publish.
	
	self assertOutputDirectoryContains: 'foo.html'.
	self assertOutputDirectoryContains: 'agenda.html'
]

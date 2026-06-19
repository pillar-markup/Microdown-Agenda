"
I'm a visitor transforming an AST with Microdown agenda nodes to HTML pages
"
Class {
	#name : 'MicAgendaHtmlGenerator',
	#superclass : 'MicHTMLVisitor',
	#instVars : [
		'time',
		'scheduleFile',
		'talksHtml',
		'daysHtml',
		'daysHeaderBlockHtml',
		'dayNumber',
		'abstractLink',
		'outputDir',
		'outputFile',
		'resourcesOutputDir',
		'resourcesPath',
		'resourcesOutputPath'
	],
	#category : 'Microdown-Agenda-Visitors',
	#package : 'Microdown-Agenda',
	#tag : 'Visitors'
}

{ #category : 'instance creation' }
MicAgendaHtmlGenerator class >> on: scheduleFileRef [

	^ self new
		scheduleFile: scheduleFileRef;
		yourself
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> abstractLink [

	^ abstractLink
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> abstractLink: abstractHtmlRef [

	abstractLink := abstractHtmlRef ifEmpty: [ nil ]
]

{ #category : 'private' }
MicAgendaHtmlGenerator >> activeDayCssClasses [
	
	^ dayNumber = 1
		          ifTrue: [ 'show active' ]
		          ifFalse: [ '' ]
]

{ #category : 'accessing - templates' }
MicAgendaHtmlGenerator >> agendaTemplate [ 
	
	^ self templatesDir / 'agenda.mustache'
]

{ #category : 'building' }
MicAgendaHtmlGenerator >> build [
	
	self buildInOutputDir: self outputDir
]

{ #category : 'building' }
MicAgendaHtmlGenerator >> buildAgenda: anAgenda [
	
	self logGenerationStart.
	
	self visit: anAgenda.
	self outputFile writeStreamDo: [ :stream | stream nextPutAll: self contents ].
	self copyResourcesIfAbsent.
	
	InformativeNotification signal: 'Succesfully generated ' , self outputFile fullName
]

{ #category : 'building' }
MicAgendaHtmlGenerator >> buildAgenda: anAgenda outputDir: outputDirectory name: aName [

	self prepareOutputDir: outputDirectory name: aName.
	self buildAgenda: anAgenda	
]

{ #category : 'building' }
MicAgendaHtmlGenerator >> buildInOutputDir: outputDirectory [

	| root agenda |
	outputDir := outputDirectory.
	root := Microdown parse: self scheduleFile contents.
	agenda := (MicDocumentToAgenda new
		           visit: root;
		           yourself) agenda.
	self 
		buildAgenda: agenda 
		outputDir: outputDir 
		name: self scheduleFile basenameWithoutExtension
]

{ #category : 'private' }
MicAgendaHtmlGenerator >> copyResourcesIfAbsent [

	self resourcesOutputDir exists ifTrue: [ ^ self ].
	
	self resourcesDir copyAllTo: self resourcesOutputDir.
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> currentDir [
	" Core repository where to find resources, templates.
	They come with Microdown Agenda git repository.
	If the git repository is not found, we assume resources and templates to be available in the same directory as the image file"

	^ [ self gitRepositoryDir ]
		on: NotFound 
		do: [ FileLocator workingDirectory / 'agenda' ]
]

{ #category : 'private' }
MicAgendaHtmlGenerator >> dayHeaderBlockHtmlForDay: aDay [

	^ (MustacheTemplate on:
		                       self dayHeaderBlockTemplate) value: { 
			                      ('DAY_ID' -> self dayId).
			                      ('ACTIVE_CLASSES' -> self activeDayCssClasses).
			                      ('DAY_NUMBER' -> ('Day-0' , dayNumber asString)).
			                      ('DATE' -> aDay name) } asDictionary.

]

{ #category : 'accessing - templates' }
MicAgendaHtmlGenerator >> dayHeaderBlockTemplate [

	^ self templatesDir / 'dayHeaderBlock.mustache'
]

{ #category : 'private' }
MicAgendaHtmlGenerator >> dayHtml [

	^ (MustacheTemplate on: self dayTalksTemplate) value: { 
			           ('DAY_ID' -> self dayId).
			           ('ACTIVE_CLASSES' -> self activeDayCssClasses).
			           ('SCHEDULES' -> talksHtml asString) } asDictionary
]

{ #category : 'private' }
MicAgendaHtmlGenerator >> dayId [
	
	^ 'day' , dayNumber asString
]

{ #category : 'accessing - templates' }
MicAgendaHtmlGenerator >> dayTalksTemplate [

	^ self templatesDir / 'dayTalks.mustache'
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> defaultOutputDir [

	^ FileLocator workingDirectory / 'generated'
]

{ #category : 'private' }
MicAgendaHtmlGenerator >> ensureOutputFileParentCreated: aFileReference [

	self outputDir ensureCreateDirectory.
	aFileReference parent exists ifTrue: [ ^ self ].
	
	self ensureOutputFileParentCreated: aFileReference parent.
	aFileReference parent ensureCreateDirectory
]

{ #category : 'private' }
MicAgendaHtmlGenerator >> gitRepositoryDir [

	| dir |
	dir := (IceRepository registry 
    		detect: [ :each | 'Microdown-Agenda' = each name ]) repositoryDirectory.
		
	dir exists ifFalse: [ NotFound signal ].
	^ dir
]

{ #category : 'initialization' }
MicAgendaHtmlGenerator >> initialize [

	super initialize.
	time := ''.
	daysHtml := ''.
	daysHeaderBlockHtml := ''.
	talksHtml := ''.
	dayNumber := 0.
]

{ #category : 'private' }
MicAgendaHtmlGenerator >> logGenerationStart [

	Smalltalk logStdOutDuring: [:logger |
		logger 
			nextPutAll: 'generating agenda for "';
			nextPutAll: self scheduleFile fullName;
			nextPut: $";
			cr ]. 
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> outputDir [

	^ outputDir ifNil: [ outputDir := self defaultOutputDir ]
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> outputDir: aDirectory [

	outputDir := aDirectory
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> outputFile [
	
	^ outputFile
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> outputFile: aFileReference [
	
	outputFile := aFileReference
]

{ #category : 'building' }
MicAgendaHtmlGenerator >> prepareOutputDir: aDirectory name: aName [

	outputDir := aDirectory.
	outputFile := self outputDir / (aName , '.html').
	self ensureOutputFileParentCreated: outputFile.
	outputFile ensureDelete.

]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> resourcesDir [

	^ self currentDir / 'resources'
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> resourcesOutputDir [

	^ resourcesOutputDir ifNil: [ self outputDir / 'resources' ] 
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> resourcesOutputDir: aDirectory [

	resourcesOutputDir := aDirectory 
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> resourcesOutputPath [
	
	^ resourcesOutputPath 
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> resourcesOutputPath: aPath [
	
	resourcesOutputPath := aPath 
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> resourcesPath [

	^ resourcesPath ifNil: [ './resources' ]
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> scheduleFile [

	^ scheduleFile
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> scheduleFile: aFileReference [ 
	scheduleFile := aFileReference
]

{ #category : 'accessing - templates' }
MicAgendaHtmlGenerator >> talkTemplate [ 

	^ self templatesDir / 'talk.mustache'
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> templatesDir [

	^ self currentDir / 'templates'
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> time [

	^ time
]

{ #category : 'accessing' }
MicAgendaHtmlGenerator >> time: aTime [

	time := aTime
]

{ #category : 'private' }
MicAgendaHtmlGenerator >> timePlus: aDuration [

	self time: (self time addTime: aDuration)
]

{ #category : 'visiting' }
MicAgendaHtmlGenerator >> visitAgenda: anAgenda [

	| agendaHtml |
	
	anAgenda days do: [ :day | day accept: self ].

	agendaHtml := (MustacheTemplate on: self agendaTemplate) value: { 
			          ('AGENDA_NAME' -> anAgenda name).
						 ('HAS_ABSTRACT' -> self abstractLink notNil).
						 ('ABSTRACT_LINK' -> self abstractLink).
			          ('DAYS_HEADER_BLOCK_HTML' -> daysHeaderBlockHtml).
			          ('DAYS_HTML' -> daysHtml).
						 ('RESOURCES_PATH' -> self resourcesOutputPath) } asDictionary.
	canvas nextPutAll: agendaHtml
]

{ #category : 'visiting' }
MicAgendaHtmlGenerator >> visitBreak: aBreak [

	" talk and break templates are the same "
	self visitTalk: aBreak 
]

{ #category : 'visiting' }
MicAgendaHtmlGenerator >> visitDay: aDay [

	dayNumber := dayNumber + 1.
	daysHeaderBlockHtml := daysHeaderBlockHtml , (self dayHeaderBlockHtmlForDay: aDay).
	aDay segments do: [ :segment | segment accept: self ].
	daysHtml := daysHtml , self dayHtml.
	talksHtml := ''
]

{ #category : 'visiting' }
MicAgendaHtmlGenerator >> visitSegment: aSegment [

	self time: aSegment startTime.
	aSegment elements do: [ :element | element accept: self ]
]

{ #category : 'visiting' }
MicAgendaHtmlGenerator >> visitTalk: aTalk [

	| timeString talk |
	timeString := self time asString, ' - '.
	self timePlus: aTalk length.
	timeString := timeString , self time asString.

	talk := (MustacheTemplate on: self talkTemplate) value: { 
			        ('TIME' -> timeString trim).
			        ('SPEAKER' -> aTalk speaker).
			        ('SUBJECT' -> aTalk name).
			        ('has_link' -> aTalk link isNotNil).
			        ('LINK' -> aTalk link).
			        ('ROOM' -> aTalk roomName) } asDictionary.
	talksHtml := talksHtml , talk
]

"
I generate HTML specificly for a calendar in HTML from a template and a microdown AST.
"
Class {
	#name : #MicAgendaGenerator,
	#superclass : #MicHTMLVisitor,
	#instVars : [
		'time',
		'scheduleFile',
		'talksHtml',
		'daysHtml',
		'daysHeaderBlockHtml',
		'dayNumber'
	],
	#category : #'Microdown-Agenda'
}

{ #category : #private }
MicAgendaGenerator >> activeDayCssClasses [
	
	^ dayNumber = 1
		          ifTrue: [ 'show active' ]
		          ifFalse: [ '' ]
]

{ #category : #'accessing - templates' }
MicAgendaGenerator >> agendaTemplate [ 
	
	^ self templatesDir / 'agenda.mustache'
]

{ #category : #building }
MicAgendaGenerator >> build: scheduleFileRef [
	
	| file outputFile |
	scheduleFile := scheduleFileRef. 
	file := Microdown parse: self scheduleFile contents.
	outputFile := self outputDir / (self scheduleFile basenameWithoutExtension, '.html').
	self outputDir ensureCreateDirectory.
	outputFile ensureDelete.
	self visit: file.
	outputFile writeStreamDo: [ :stream | stream nextPutAll: self contents ].
	self copyResourcesIfAbsent.
]

{ #category : #building }
MicAgendaGenerator >> copyResourcesIfAbsent [

	self resourcesOutputDir exists ifTrue: [ ^ self ].
	
	self resourcesDir copyAllTo: self resourcesOutputDir.
]

{ #category : #accessing }
MicAgendaGenerator >> currentDir [
	" Core repository where to find resources, templates.
	They come with Microdown Agenda git repository.
	If the git repository is not found, we assume resources and templates to be available in the same directory as the agenda file"

	^ [ self gitRepositoryDir ]
		on: NotFound 
		do: [ self scheduleFile parent ]
]

{ #category : #private }
MicAgendaGenerator >> dayHeaderBlockHtmlForDay: aDay [

	^ (MustacheTemplate on:
		                       self dayHeaderBlockTemplate) value: { 
			                      ('DAY_ID' -> self dayId).
			                      ('ACTIVE_CLASSES' -> self activeDayCssClasses).
			                      ('DAY_NUMBER' -> ('Day-0' , dayNumber asString)).
			                      ('DATE' -> aDay start) } asDictionary.

]

{ #category : #'accessing - templates' }
MicAgendaGenerator >> dayHeaderBlockTemplate [

	^ self templatesDir / 'dayHeaderBlock.mustache'
]

{ #category : #private }
MicAgendaGenerator >> dayHtml [

	^ (MustacheTemplate on: self dayTalksTemplate) value: { 
			           ('DAY_ID' -> self dayId).
			           ('ACTIVE_CLASSES' -> self activeDayCssClasses).
			           ('SCHEDULES' -> talksHtml asString) } asDictionary
]

{ #category : #private }
MicAgendaGenerator >> dayId [
	
	^ 'day' , dayNumber asString
]

{ #category : #'accessing - templates' }
MicAgendaGenerator >> dayTalksTemplate [

	^ self templatesDir / 'dayTalks.mustache'
]

{ #category : #private }
MicAgendaGenerator >> gitRepositoryDir [

	^ (IceRepository registry 
    		detect: [ :each | 'Microdown-Agenda' = each name ]) repositoryDirectory
]

{ #category : #initialization }
MicAgendaGenerator >> initialize [

	super initialize.
	time := ''.
	daysHtml := ''.
	daysHeaderBlockHtml := ''.
	talksHtml := ''.
	dayNumber := 0.
]

{ #category : #accessing }
MicAgendaGenerator >> outputDir [

	^ self scheduleFile parent / 'generated'
]

{ #category : #accessing }
MicAgendaGenerator >> resourcesDir [

	^ self currentDir / 'resources'
]

{ #category : #accessing }
MicAgendaGenerator >> resourcesOutputDir [

	^ self outputDir / 'resources'
]

{ #category : #accessing }
MicAgendaGenerator >> scheduleFile [

	^ scheduleFile
]

{ #category : #'accessing - templates' }
MicAgendaGenerator >> talkTemplate [ 

	^ self templatesDir / 'talk.mustache'
]

{ #category : #accessing }
MicAgendaGenerator >> templatesDir [

	^ self currentDir / 'templates'
]

{ #category : #accessing }
MicAgendaGenerator >> time [

	^ time
]

{ #category : #accessing }
MicAgendaGenerator >> time: aTime [

	time := aTime
]

{ #category : #private }
MicAgendaGenerator >> timePlus: nbMinutes [

	self time: (self time addTime: nbMinutes minutes)
]

{ #category : #visiting }
MicAgendaGenerator >> visitAgenda: anAgenda [

	| agenda |
	self visitChildrenOf: anAgenda.
	agenda := (MustacheTemplate on: self agendaTemplate) value: { 
			          ('AGENDA_NAME' -> anAgenda title).
			          ('DAYS_HEADER_BLOCK_HTML' -> daysHeaderBlockHtml).
			          ('DAYS_HTML' -> daysHtml) } asDictionary.
	canvas nextPutAll: agenda
]

{ #category : #visiting }
MicAgendaGenerator >> visitBreak: aBreak [

	" talk and break templates are the same "
	self visitTalk: aBreak 
]

{ #category : #visiting }
MicAgendaGenerator >> visitDay: aDay [

	dayNumber := dayNumber + 1.
	daysHeaderBlockHtml := daysHeaderBlockHtml , (self dayHeaderBlockHtmlForDay: aDay).
	self visitChildrenOf: aDay.
	daysHtml := daysHtml , self dayHtml.
	talksHtml := ''
]

{ #category : #visiting }
MicAgendaGenerator >> visitSegment: aSegment [

	self time: aSegment start asTime.
	self visitChildrenOf: aSegment.
]

{ #category : #visiting }
MicAgendaGenerator >> visitTalk: aTalk [

	| timeString talk |
	timeString := self time asString, ' - '.
	self timePlus: aTalk length asInteger.
	timeString := timeString , self time asString.

	talk := (MustacheTemplate on: self talkTemplate) value: { 
			        ('TIME' -> timeString trim).
			        ('SPEAKER' -> aTalk author).
			        ('SUBJECT' -> aTalk subject).
			        ('ROOM' -> aTalk room) } asDictionary.
	talksHtml := talksHtml , talk
]

"
I generate HTML specificly for a calendar in HTML from a template and a microdown AST.
"
Class {
	#name : #MicAgendaGenerator,
	#superclass : #MicHTMLVisitor,
	#instVars : [
		'time',
		'daysHeadersBlock',
		'daysTalks',
		'daysNumber',
		'scheduleFile',
		'talksHtml'
	],
	#category : #'Microdown-Agenda'
}

{ #category : #'accessing - templates' }
MicAgendaGenerator >> agendaTemplate [ 
	
	^ self templatesDir / 'agenda.mustache'
]

{ #category : #building }
MicAgendaGenerator >> build: scheduleFileRef [
	
	| file outputFile |
	scheduleFile := scheduleFileRef. 
	file := Microdown parse: self scheduleFile contents.
	outputFile := self outputDir / 'schedule.html'.
	self outputDir ensureCreateDirectory.
	outputFile ensureDelete.
	self visit: file.
	outputFile writeStreamDo: [ :stream | stream nextPutAll: self contents ]
]

{ #category : #accessing }
MicAgendaGenerator >> currentDir [

	^ self scheduleFile parent
]

{ #category : #'accessing - templates' }
MicAgendaGenerator >> dayHeaderBlockTemplate [

	^ self templatesDir / 'dayHeaderBlock.mustache'
]

{ #category : #'accessing - templates' }
MicAgendaGenerator >> dayTalksTemplate [

	^ self templatesDir / 'dayTalks.mustache'
]

{ #category : #initialization }
MicAgendaGenerator >> initialize [

	super initialize.
	time := ''.
	daysTalks := ''.
	daysHeadersBlock := ''.
	talksHtml := ''.
	daysNumber := 0.
]

{ #category : #accessing }
MicAgendaGenerator >> outputDir [

	^ self currentDir / 'generated'
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
			          ('NUMBERDAY' -> daysNumber).
			          ('DAYSBLOCK' -> daysHeadersBlock).
			          ('DAYS' -> daysTalks) } asDictionary.
	canvas nextPutAll: agenda
]

{ #category : #visiting }
MicAgendaGenerator >> visitBreak: aBreak [

	" talk and break templates are the same "
	self visitTalk: aBreak 
]

{ #category : #visiting }
MicAgendaGenerator >> visitDay: aDay [

	| day dayBlock number numberDay active |
	daysNumber := daysNumber + 1.
	active := daysNumber = 1
		          ifTrue: [ 'show active' ]
		          ifFalse: [ ' ' ].
	number := 'day' , daysNumber asString.
	numberDay := 'Day-0' , daysNumber asString.
	dayBlock := (MustacheTemplate on: self dayHeaderBlockTemplate) 
		            value: { 
				            ('NUMBER' -> number).
				            ('ACTIVE' -> active).
				            ('DAYNUMBER' -> numberDay).
				            ('DATE' -> aDay start) } asDictionary.
	daysHeadersBlock := daysHeadersBlock , dayBlock.
	self visitChildrenOf: aDay.
	day := (MustacheTemplate on: self dayTalksTemplate) value: { 
			       ('DAYNUMBER' -> number).
			       ('ACTIVE' -> active).
			       ('SCHEDULES' -> talksHtml asString) } asDictionary.
	daysTalks := daysTalks , day.
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

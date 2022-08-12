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
		'talks',
		'daysNumber',
		'scheduleFile'
	],
	#category : #'Microdown-Agenda'
}

{ #category : #'accessing - templates' }
MicAgendaGenerator >> agendaTemplate [ 
	
	^ self templatesDir / 'agenda.mustache'
]

{ #category : #visiting }
MicAgendaGenerator >> build: scheduleFileRef [
	
	| file outputFile |
	scheduleFile := scheduleFileRef. 
	file := Microdown parse: self scheduleFile contents.
	outputFile := self outputDir / 'schedule.html'.
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
	talks := ''.
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

{ #category : #visiting }
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

	| length talk |
	length := self time , ' - '.
	self timePlus: aBreak length.
	length := length , self time.

	talk := (MustacheTemplate on: self talkTemplate) value: { 
			        ('TIME' -> length trim).
			        ('SPEAKER' -> aBreak author).
			        ('SUBJECT' -> aBreak subject).
			        ('ROOM' -> aBreak room) } asDictionary.
	talks := talks , talk
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
			       ('SCHEDULES' -> talks asString) } asDictionary.
	daysTalks := daysTalks , day.
	talks := ''
]

{ #category : #visiting }
MicAgendaGenerator >> visitSegment: aSegment [

	self time: aSegment start asTime.
	self visitChildrenOf: aSegment.
]

{ #category : #visiting }
MicAgendaGenerator >> visitTalk: aTalk [

	| length talk |
	length := self time , ' - '.
	self timePlus: aTalk length.
	length := length , self time.

	talk := (MustacheTemplate on: self talkTemplate) value: { 
			        ('TIME' -> length trim).
			        ('SPEAKER' -> aTalk author).
			        ('SUBJECT' -> aTalk subject).
			        ('ROOM' -> aTalk room) } asDictionary.
	talks := talks , talk
]

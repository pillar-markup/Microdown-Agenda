Class {
	#name : #MicAgendaAstTest,
	#superclass : #TestCase,
	#instVars : [
		'parser'
	],
	#category : #'Microdown-Agenda-Tests'
}

{ #category : #running }
MicAgendaAstTest >> setUp [

	super setUp.
	parser := Microdown new.
]

{ #category : #tests }
MicAgendaAstTest >> testCanParseAgendaAttributes [

	| source root agenda |
	source := '# A cool agenda

- defaultTalkLength: 60
- rooms:
  - amphiA: Amphiteater, building B
  - amphiB: Big Room, building A
  - room1: Some room, building A'.

	root :=  parser parse: source.
	agenda := (MicDocumentToAgenda new visit: root; yourself) agenda.
	
	self assert: agenda name equals: 'A cool agenda'.
	self assert: agenda defaultTalkLength equals: 1 hour.
	self assert: agenda rooms size equals: 3.
	self assertCollection: agenda roomIds hasSameElements: #(amphiA amphiB room1).

]

{ #category : #tests }
MicAgendaAstTest >> testCanParseBreak [

	| source root agenda modelGenerator segment break |
	source := '#### Break
- length: 120
- room: #amphiA'.

	agenda := MicAgenda new.
	segment := (agenda newDay: '') newSegment: ''.
	root := parser parse: source.
	modelGenerator := MicDocumentToAgenda new.
	modelGenerator agenda: agenda.
	
	modelGenerator visit: root.
	
	break := segment elements first.
	self assert: break length equals: 2 hours.
	self assert: break room equals: #amphiA.
]

{ #category : #tests }
MicAgendaAstTest >> testCanParseDay [

	| source root agenda |
	source := '# A cool agenda

## 2023 march 3'.

	root :=  parser parse: source.
	agenda := (MicDocumentToAgenda new visit: root; yourself) agenda.
	
	self assert: agenda name equals: 'A cool agenda'.
	self assert: agenda days size equals: 1.
	self assert: agenda days first name equals: '2023 march 3'
]

{ #category : #tests }
MicAgendaAstTest >> testCanParseSegment [

	| source root agenda modelGenerator segments segment |
	source := '### 10:30
#### First talk
#### Break
#### Second talk'.

	agenda := MicAgenda new.
	agenda newDay: ''.
	root := parser parse: source.
	modelGenerator := MicDocumentToAgenda new.
	modelGenerator agenda: agenda.
	
	modelGenerator visit: root.
	
	segments := agenda days first segments.
	self assert: segments size equals: 1.
	segment := segments first.
	self assert: segment startTime equals: (Time hour: 10 minute: 30 second: 0).
	self assert: segment elements size equals: 3.
	self assert: segment elements first name equals: 'First talk'.
	self assert: segment elements second isBreak.
	self assert: segment elements third name equals: 'Second talk'.

]

{ #category : #tests }
MicAgendaAstTest >> testCanParseTalk [

	| source root agenda modelGenerator segment talk |
	source := '#### First talk
- length: 30
- speaker: Delporte Gaylord
- room: #amphiA
- link: talks/talk1'.

	agenda := MicAgenda new.
	segment := (agenda newDay: '') newSegment: ''.
	root := parser parse: source.
	modelGenerator := MicDocumentToAgenda new.
	modelGenerator agenda: agenda.
	
	modelGenerator visit: root.
	
	talk := segment elements first.
	self assert: talk length equals: 30 minutes.
	self assert: talk speaker equals: 'Delporte Gaylord'.
	self assert: talk room equals: #amphiA.
	self assert: talk link equals: 'talks/talk1'.

]

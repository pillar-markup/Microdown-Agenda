"
This class contains tests but all the test are not correct because we need to have a directory with the templates because to generate the calendar.
"
Class {
	#name : #MicAgendaGeneratorTest,
	#superclass : #TestCase,
	#instVars : [
		'parser',
		'writer'
	],
	#pools : [
		'MicMicrodownSharedPool'
	],
	#category : #'Microdown-Agenda-Tests'
}

{ #category : #exemple }
MicAgendaGeneratorTest >> agendaExempleMultiplesTalks [

 ^ '#A cool agenda

## 3 march 2023

### 10:30
#### First talk
- length: 30
- speaker: Grace Hopper
- room: Building B

#### Break
- length: 120
- room: Building A

#### Second talk
- length: 60
- speaker: Alan Turing
- room: Building C


## 4 march 2023

### 10:00
#### The Laws of Thought
- length: 30
- speaker: George Boole
- room: Building G

#### Break
- length: 60
- room: Building F

#### The Analytical Engine
- length: 60
- speaker: Ada Lovelace
- room: Building Q
'

]

{ #category : #exemple }
MicAgendaGeneratorTest >> agendaExempleOneTalk [

 ^ '#A cool agenda
- rooms:
  - room1: Room One, Building A

## 3 march 2023

### 10:30

#### First talk
- length: 30
- speaker: Grace Hopper
- room: #room1'
	
]

{ #category : #building }
MicAgendaGeneratorTest >> agendaFor: agendaMarkdownString [

	| root |
	root :=  parser parse: agendaMarkdownString.
	^ (MicDocumentToAgenda new 
			visit: root; 
			yourself) agenda.
]

{ #category : #running }
MicAgendaGeneratorTest >> setUp [

	super setUp.
	parser := Microdown new.
	writer := MicAgendaHtmlGenerator new.
]

{ #category : #tests }
MicAgendaGeneratorTest >> testConvertMicFileCorrectlyWithMultiplesTalks [

	"Look at the class comment for more information about this test"

	| agenda html |

	agenda := self agendaFor: self agendaExempleMultiplesTalks.
	writer visit: agenda.
	
	html := writer contents.
	self assert: (html includesSubstring: '3 march 2023').
	self assert: (html includesSubstring: '<span class="time">10:30 am - 11:00 am</span>').
	self assert: (html includesSubstring: '<span class="name">Grace Hopper</span>').
	self assert: (html includesSubstring: '<div class="subject">First talk</div>').
	self assert: (html includesSubstring: '<div class="venue">Building B</div>').
	
	self assert: (html includesSubstring: '<span class="time">11:00 am - 1:00 pm</span>').
	self assert: (html includesSubstring: '<div class="subject">Break</div>').
	self assert: (html includesSubstring: '<div class="venue">Building A</div>').
	
	self assert: (html includesSubstring: '<span class="time">1:00 pm - 2:00 pm</span>').
	self assert: (html includesSubstring: '<span class="name">Alan Turing</span>').
	self assert: (html includesSubstring: '<div class="subject">Second talk</div>').
	self assert: (html includesSubstring: '<div class="venue">Building C</div>').
	
	self assert: (html includesSubstring: '4 march 2023').
	self assert: (html includesSubstring: '<span class="time">10:00 am - 10:30 am</span>').
	self assert: (html includesSubstring: '<span class="name">George Boole</span>').
	self assert: (html includesSubstring: '<div class="subject">The Laws of Thought</div>').
	self assert: (html includesSubstring: '<div class="venue">Building G</div>').
	
	self assert: (html includesSubstring: '<span class="time">10:30 am - 11:30 am</span>').
	self assert: (html includesSubstring: '<div class="subject">Break</div>').
	self assert: (html includesSubstring: '<div class="venue">Building A</div>').
	
	self assert: (html includesSubstring: '<span class="time">11:30 am - 12:30 pm</span>').
	self assert: (html includesSubstring: '<span class="name">Ada Lovelace</span>').
	self assert: (html includesSubstring: '<div class="subject">The Analytical Engine</div>').
	self assert: (html includesSubstring: '<div class="venue">Building C</div>').
]

{ #category : #tests }
MicAgendaGeneratorTest >> testConvertMicFileCorrectlyWithOneTalk [

	| agenda html |

	agenda := self agendaFor: self agendaExempleOneTalk.
	writer visit: agenda.
	
	html := writer contents.
	self assert: (html includesSubstring: '3 march 2023').
	self assert: (html includesSubstring: '<span class="time">10:30 am - 11:00 am</span>').
	self assert: (html includesSubstring: '<span class="name">Grace Hopper</span>').
	self assert: (html includesSubstring: 'div class="subject">First talk</div>').
]

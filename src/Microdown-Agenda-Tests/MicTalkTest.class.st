Class {
	#name : #MicTalkTest,
	#superclass : #TestCase,
	#category : #'Microdown-Agenda-Tests'
}

{ #category : #tests }
MicTalkTest >> testTalkGetDefaultLengthWhenNoLengthSpecified [

	| agenda segment talk |
	agenda := MicAgenda new.
	agenda defaultTalkLength: 20.
	
	segment := (agenda newDay: '') newSegment: '10:00'.
	talk := agenda newSegmentElement: 'Foo'.
	
	self assert: talk length equals: 20

		
]

{ #category : #tests }
MicTalkTest >> testTalkGetDefaultRoomWhenNoRoomSpecified [

	| agenda segment talk |
	agenda := MicAgenda new.
	agenda defaultRoom: 'Room 1'.
	
	segment := (agenda newDay: '') newSegment: '10:00'.
	talk := agenda newSegmentElement: 'Foo'.
	
	self assert: talk room equals: 'Room 1'

		
]

{ #category : #tests }
MicTalkTest >> testTalkGetSpecificRoomWhenRoomSpecified [

	| agenda segment talk |
	agenda := MicAgenda new.
	agenda defaultRoom: 'Room 1'.
	
	segment := (agenda newDay: '') newSegment: '10:00'.
	talk := agenda newSegmentElement: 'Foo'.
	talk room: 'Room 2'.
	
	self assert: talk room equals: 'Room 2'

		
]

{ #category : #tests }
MicTalkTest >> testTalkGetSpecifictLengthWhenLengthSpecified [

	| agenda segment talk |
	agenda := MicAgenda new.
	agenda defaultTalkLength: 20.
	
	segment := (agenda newDay: '') newSegment: '10:00'.
	talk := agenda newSegmentElement: 'Foo'.
	talk length: 30.
	
	self assert: talk length equals: 30

		
]

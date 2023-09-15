"
I represent a talk, pat of a day segment of an agenda.
I have an author and a loink to the talk detail. 
"
Class {
	#name : #MicTalk,
	#superclass : #MicSegmentElement,
	#instVars : [
		'link',
		'speaker'
	],
	#category : #'Microdown-Agenda'
}

{ #category : #'instance creation' }
MicTalk class >> named: aString [

	^ self new
		name: aString;
		yourself
]

{ #category : #visiting }
MicTalk >> accept: aVisitor [ 
	
	aVisitor visitTalk: self
]

{ #category : #adding }
MicTalk >> addAttributes: aDictionary [

	super addAttributes: aDictionary.
	aDictionary
		at: #speaker ifPresent: [ :value | speaker := value ];
		at: #link ifPresent: [ :value | link := value ]
]

{ #category : #accessing }
MicTalk >> link [
	^ link
]

{ #category : #accessing }
MicTalk >> speaker [
	^ speaker
]

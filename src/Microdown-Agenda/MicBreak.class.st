"
I represent a break in a conference day segment.
"
Class {
	#name : #MicBreak,
	#superclass : #MicSegmentElement,
	#category : #'Microdown-Agenda'
}

{ #category : #visiting }
MicBreak >> accept: aVisitor [ 

	aVisitor visitBreak: self
]

{ #category : #adding }
MicBreak >> addAttributes: aDictionary [

	super addAttributes: aDictionary.
	aDictionary
		at: #label ifPresent: [ :value | name := value ]
]

{ #category : #testing }
MicBreak >> isBreak [
	
	^ true
]

{ #category : #accessing }
MicBreak >> name [ 

	^ name ifNil: [ 'Break' ]
]

{ #category : #accessing }
MicBreak >> speaker [ 

	^ ''
]

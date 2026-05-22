Extension { #name : 'MicListItemBlock' }

{ #category : '*Microdown-Agenda' }
MicListItemBlock >> basicText [

	^ String streamContents: [ :str | children do: [ :each | str nextPutAll: each bodyString ] ]
]

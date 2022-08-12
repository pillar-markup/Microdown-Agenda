Class {
	#name : #BaselineOfMicrodownAgenda,
	#superclass : #BaselineOf,
	#category : #BaselineOfMicrodownAgenda
}

{ #category : #baselines }
BaselineOfMicrodownAgenda >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self microdown: spec.
		self mustache: spec.				

		spec
			package: #'Microdown-Agenda';
			package: #'Microdown-Agenda-Tests'
				with: [ spec requires: #( #'Microdown-Agenda' ) ].
				
		spec
			group: 'default' with: #('Microdown-Agenda-Tests'). ]
]

{ #category : #baseline }
BaselineOfMicrodownAgenda >> microdown: spec [ 

	spec baseline: 'Microdown' with: [ 
		spec 
			"repository: (self class environment at: #BaselineOfPharo) microdownRepository;"
			repository: 'github://pillar-markup/Microdown:dev/src';
			loads: #('Microdown-HTMLExporter-Tests') ]
]

{ #category : #baseline }
BaselineOfMicrodownAgenda >> mustache: spec [ 

	spec baseline: 'Mustache' with: [ 
			spec
				repository: 'github://noha/mustache:v1.1/repository';
				loads: #('Core') ]
]

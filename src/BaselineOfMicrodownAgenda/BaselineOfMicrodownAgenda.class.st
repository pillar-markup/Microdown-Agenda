Class {
	#name : 'BaselineOfMicrodownAgenda',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfMicrodownAgenda',
	#package : 'BaselineOfMicrodownAgenda'
}

{ #category : 'baselines' }
BaselineOfMicrodownAgenda >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self microdown: spec.
		self mustache: spec.				

		spec
			package: #'Microdown-Agenda'
				with: [ spec requires: #( #Microdown #Mustache ) ];
			package: #'Microdown-Agenda-Tests'
				with: [ spec requires: #( #'Microdown-Agenda' ) ].
				
		spec
			group: 'default' with: #('Microdown-Agenda-Tests'). ]
]

{ #category : 'querying' }
BaselineOfMicrodownAgenda >> installedMicrodownVersion [

	^ (MetacelloProjectRegistry projects detect: [ :metacelloProject | metacelloProject name = 'Microdown' ]) 
		repositories repositorySpecs first description
]

{ #category : 'baseline' }
BaselineOfMicrodownAgenda >> microdown: spec [ 

	spec baseline: 'Microdown' with: [ 
		spec 
			repository: self microdownRepository;
			loads: #('Microdown-HTMLExporter-Tests') ]
]

{ #category : 'querying' }
BaselineOfMicrodownAgenda >> microdownRepository [ 

	"Use installed microdown version if available to avoid conflicts"
	^ [ self installedMicrodownVersion ]
		on: NotFound
		do: [ 'github://pillar-markup/Microdown:dev/src' ]
]

{ #category : 'baseline' }
BaselineOfMicrodownAgenda >> mustache: spec [ 

	spec baseline: 'Mustache' with: [ 
			spec
				repository: 'github://noha/mustache:v1.3/repository';
				loads: #('Core') ]
]

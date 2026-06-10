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
BaselineOfMicrodownAgenda >> installedVersionBeforePharo14For: aProjectName [

	^ (MetacelloProjectRegistration registry baselineProjectSpecs detect: [ :metacelloProject | metacelloProject name = aProjectName ]) 
		repositories map keys first
]

{ #category : 'querying' }
BaselineOfMicrodownAgenda >> installedVersionFor: aProjectName [
	
	SystemVersion current major < 14 
		ifTrue: [ ^ self installedVersionBeforePharo14For: aProjectName ].

	^ (MetacelloProjectRegistry projects detect: [ :metacelloProject | metacelloProject name = aProjectName ]) 
		repositories repositorySpecs first description
]

{ #category : 'baselines' }
BaselineOfMicrodownAgenda >> microdown: spec [ 

	spec baseline: 'Microdown' with: [ 
		spec 
			repository: self microdownRepository;
			loads: #('Microdown-HTMLExporter-Tests') ]
]

{ #category : 'querying' }
BaselineOfMicrodownAgenda >> microdownRepository [ 

	"Use installed microdown version if available to avoid conflicts"
	^ [ self installedVersionFor: 'Microdown' ]
		on: NotFound
		do: [ 'github://pillar-markup/Microdown:dev/src' ]
]

{ #category : 'baselines' }
BaselineOfMicrodownAgenda >> mustache: spec [ 

	spec baseline: 'Mustache' with: [ 
			spec
				repository: self mustacheRepository;
				loads: #('Core') ]
]

{ #category : 'querying' }
BaselineOfMicrodownAgenda >> mustacheRepository [ 

	"Use installed Mustache version if available to avoid conflicts"
	^ [ self installedVersionFor: 'Mustache' ]
		on: NotFound
		do: [ 'github://noha/mustache:v1.4/repository' ]
]

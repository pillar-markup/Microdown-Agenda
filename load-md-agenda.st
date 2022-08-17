#( 'BaselineOfMicrodown' 'Microdown' 'Microdown-Tests' 'Microdown-ResolvePath' 'Microdown-ResolvePath-Tests') 
    do: [ :each | 
        (RPackageOrganizer default packageNamed: each ifAbsent: [ nil ]) 
            ifNotNil: [ :aPackage | aPackage removeFromSystem ] ].

Metacello new 
    repository: 'gitlocal://', ('./Microdown-Agenda' asFileReference fullName), '/src';
    baseline: 'MicrodownAgenda'; 
    load.

Smalltalk snapshot: true andQuit: true
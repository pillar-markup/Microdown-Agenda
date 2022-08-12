# Microdown-Agenda
A microdown extension to manage agenda (schedule and speakers) and generate html output

# The differents elements of a calendar

You have several things in a calendar, you have 
- the agenda, 
- the days, 
- the segments,
- the talks and breaks.

The hierachy is as following: an agenda is composed of one to multiple days split in segments containing talks and breaks.
A file looks like this:

![image](https://user-images.githubusercontent.com/60885865/184166117-e8028bbc-280c-414f-9c0b-ab71b3bf5ba6.png)

  
# How to use it?

## Loading Microdown-Agenda

```Smalltalk
Metacello new
	repository: 'github://pillar-markup/Microdown-Agenda:main/src';
	baseline: 'MicrodownAgenda';
	load.
 ```

### Generating an agenda
You first need to have a microdown file which contains the elements of your agenda with the templates and the ressources in the same directory like this:
![image](https://user-images.githubusercontent.com/60885865/184165031-88993e1d-7ae0-49e5-9f1a-741f25e63183.png)


Once you have it, you can generate the agenda from a Pharo image with **Microdown-Agenda** loaded:
```Smalltalk
MicAgendaGenerator new build: 'Microdown-Agenda/example/schedule.md' asFileReference
```

The HTML agenda will be generated in the directory `GeneratedHTML`. Everything needed by the agenda will be in this folder.

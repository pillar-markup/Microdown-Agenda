# Microdown-Agenda
A microdown extension to manage agenda (schedule and speakers) and generate html output

# What you need to use it

You need two things:

  - The package Microdown-Agenda and Microdown-Agenda-tests from Microdown (More info here ->https://github.com/pillar-markup/Microdown).
  - The templates and the ressources used in order to generate the agenda. 
  
# The differents elements of a calendar

You have several things in a calendar, you have the agenda, the days, the segments and the talks and breaks.
The hierachy is that you have one agenda which contain one to multiples day which contains segments which also contains talks and breaks.
A file look like this:
![image](https://user-images.githubusercontent.com/60885865/184166117-e8028bbc-280c-414f-9c0b-ab71b3bf5ba6.png)

  
# Hot to use it

So now that we have all what we need, in order to use it, you need to have a microdown file which contains the elements of your calendar with the templates and the ressources in the same directory like this:
![image](https://user-images.githubusercontent.com/60885865/184165031-88993e1d-7ae0-49e5-9f1a-741f25e63183.png)


And once you have it, in your pharo image, you need to build it as a File Reference like below:
![image](https://user-images.githubusercontent.com/60885865/184164659-770273cb-623b-4518-a694-71667267ac42.png)

And this will generate in the directory GeneratedFile the HTML file corresponding to your microdown file.

# Note
#### A quick terminal based note taker written in Nim.

## Installation
First have nim installed. and open the note folder inside of a terminal,
 then run the following command.
`nim c -d:release note`

## Examples

Currently as we don't install to any path ./ in the note directory is
the only way to run it. 

`./note -t Hello World`
This will create a timestamped note in the default notes.txt file that
says 'Hello World'

`./note -f other.txt Hello World`
This will create a new text file to save notes into. this will not make this 
the primary note file and must be specified every run if you wish to use a 
non-default text file.

`./note -h`
This simply opens the help menu, which really is just a few printed statements
on the flags that can be used in the program.
# Note
#### A quick terminal based note taker written in Nim.

## Installation

### Unix
First have nim installed. Run the install.sh script to compile note.nim and symlink the
executable into /usr/local/bin. This requires sudo or root execution.

### Windows
A windows installer is in the works.

### Uninstall
Run uninstall.sh with sudo or as root. This removes our folder
and removes the symlink from the /usr/local/bin folder.

## Examples

`note Hello World`
Creates a note for the current directory.
This can be read with
`note -r`
which prints out all the notes in the note table.

`note -t test Hello World`
This will create a new note table called test. This can be used to keep notes separate from each other.

`note -c`
The -c flag will remove a specified notes table from the db. When no note table is specified running this will clear the default notes table. 

`note -h`
This simply opens the help menu, which really is just a few printed statements
on the flags that can be used in the program.

`./note -l`
Simply lists all notes created that are stored in the db

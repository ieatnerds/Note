# ieatnerds(Nicholas Kelly)
# importantnk@gmail.com
#
# This will create a note based on the command line arguments used
# to run the program. 
#
# This note will have several options to append things such as dates to the
# note. These messages will be written to a file called notes.txt

###         ###
### Imports ###
###         ###

import strutils, osproc, os, times, terminal, sequtils
var
    file: File
    message: string
message = ""

type
    argError* = object of Exception

###       ###
### Flags ###
###       ###

proc head(): void =
    # Append date to head of message
    message = getDateStr()
    message.add("-->")
    message.add(getClockStr())
    message.add("\n")

proc help(): void =
    # This flag will display help options to the console when used.
    setForegroundColor(fgBlue)
    stdout.write "Help! \n"
    writeStyled "This is the help menu for note.nim \n"
    stdout.write "More coming soon!\n"
    stdout.write "The current arguments for this program include\n"
    writeStyled "1. -h For the help menu\n"
    writeStyled "2. -t To append time to the top of the note\n"
    writeStyled "3. -f For specifying a note txt file.\n"
    resetAttributes()
    stdout.write "\n"
    quit()
    
###            ###
### Procedures ###
###            ###
 
proc isArg(arg: string): bool =
    # Returns true if passed string starts with "-"
    if arg.startsWith("-"):
        return true
    else:
        return false

proc noteFile(filename = "notes.txt"): File =
    # Used to specify the file to save notes into
    result = open(filename, fmAppend)
    
proc writeMess(message: string): void =
    # This procedure will write a give message to the open file 
    # and then it will close the file, assuming that the file should not 
    # be kept open when we are no longer using it.
    file.writeLine(message)
    file.close()

proc main(): void =
    # Main will do the heavy lifting of the program, as usual, tying everything
    # else in the program together.
    var
        arguments = commandLineParams()
        k = 0
    file = noteFile()
    for i in 0..(high(arguments)):
        if(isArg(arguments[i])):
            if(arguments[i] == "-h"): # help
                help()
            if(arguments[i] == "-f"): # file
                k = i+1
                file = noteFile(arguments[k])
                arguments[k] = ""
                # arguments.delete(k)
                # arguments.add("")
            if(arguments[i] == "-t"): # time append
                head()
        else:
            message.add(arguments[i])
            message.add(" ")
            
    message.add("\n")
    message.add("----------------------------")
    writeMess(message)

###      ###
### Main ###
###      ###
           
main()

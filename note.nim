# Nicholas Kelly
# This will create a note based on the command line arguments used
# to run the program. 
#
# this note will have several options to append things such as dates to the
# note. these messages will be written to a file called notes.txt


import strutils, osproc, os, times, terminal,sequtils

var appType: string = "console"

var file: File
var message: string
message = ""

type
    argError* = object of Exception

###       ###
### Flags ###
###       ###

proc head(): void =
    # append date to head of message
    message = getDateStr()
    message.add("-->")
    message.add(getClockStr())
    message.add("\n")

proc diag(): void =
    # this function will add all other flags to 
    # the message for testing purposes.
    head()

proc fiop(): void =
    # This is the flag operation for specifying a file
    echo ""  # So it compiles

proc help(): void =
    # This flag will display help options to the console when used.
    setForegroundColor(fgBlue)
    stdout.write "Help! \n"
    writeStyled  "This is the help menu for note.nim \n"
    stdout.write "More coming soon!"
    resetAttributes()
    stdout.write "\n"
    
###            ###
### Procedures ###
###            ###
 
proc isArg(arg: string): bool =
    # Returns true if passed string starts with "-"
    if arg.startsWith("-"):
        return true
    else:
        return false

proc executeArg(arg: string): void =
    # executes given argument
    if(toLowerAscii(arg) == "-t"):  # t for Time
        head()
    if(tolowerAscii(arg) == "-d"):  # d for diagnostics
        diag()
    if(tolowerAscii(arg) == "-h"):
        help()
    else:
        raise newException(argError,"Argument not recognized.")

proc noteFile(filename = "notes.txt"): File =
    # Used to specify the file to save notes into
    var o = open(filename, fmAppend)
    return o

proc writeMess(message: string): void =
    # this procedure will write a givne message to the open file 
    # and then it will close the file, assuming that the file should not 
    # be kept open when we are no longer using it.
    # not that it matters when the program is going to terminate anyways.
    file.writeLine(message)
    file.close()

proc main(): void =
    # Main will do the heavy liftig of the program, as usual, tying everything
    # else in the program together.
    var arguments = commandLineParams()
    var i = 0
    var k = 0
    file = noteFile()
    for i in 0..(high(arguments)-1):
        if (isArg(arguments[i])):
            if (arguments[i] == "-h"):
                executeArg(arguments[i])
                quit()
            if (arguments[i] == "-f"):
                k = i+1
                file = noteFile(arguments[k])
                arguments.delete(k)  # arguments[k])
            else:
                executeArg(arguments[i])
        else:
            message.add(arguments[i])
            message.add(" ")
    message.add("\n")
    message.add("----------------------------")
    writeMess(message)
            
main()

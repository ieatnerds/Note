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

import strutils, osproc, os, times, terminal, sequtils, db_sqlite, typetraits

### Variables ###
var
  file: File
  message: string = ""

### Databse Setup ###
var exist = 0
if(fileExists("metadata.db")):
  exist = 1

let db = open("metadata.db", nil, nil, nil)

### Types ###
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
  writeStyled "3. -f For specifying a note txt file\n"
  writeStyled "4. -c To remove notes.txt\n"
  resetAttributes()
  stdout.write "\n"
  quit()

proc clear(file: string = "notes.txt"): void =
  echo ""
#  if(file):
#  	removeFile(file)
#  	quit()
    
###            ###
### Procedures ###
###            ###
 
proc isArg(arg: string): bool =
  # Returns true if passed string starts with "-"
  if arg.startsWith("-"):
    return true
  else:
    return false

proc createTable(): void =
  # This will be used to create the metadata table if it is not
  # already present in the database
  db.exec(sql"""CREATE TABLE meta (
  	            name string,
  	            date string)""")

proc insertData(name:string = "nil"): void =
  # Used to insert a new note file name into the database
  var date = getDateStr()
  db.exec(sql"INSERT INTO meta (name, date) VALUES (?, ?)", name, date)

proc getData(): string =
  # This will return the names on all entries in the meta table
  var data: string
  for x in db.rows(sql"SELECT * FROM meta"):
    echo x
  return data

proc inData(Name:string = "nil"): bool =
  # This will be used to check if a name is already in the database
  # This will return true upon success and false upon failure
  try:
    db.exec(sql"SELECT name FROM meta WHERE name = ?", Name)
    return true
  except:
    return false

proc noteFile(filename = "notes.txt"): File =
  # Used to specify the file to save notes into
  open(filename, fmAppend)
    
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
  if(exist != 1):
    createTable()
    
  for i in 0..(high(arguments)):
    if(isArg(arguments[i])):
      if(arguments[i] == "-c"): # Clear
        var data = getData()
        echo data.type.name
        clear(data)
      elif(arguments[i] == "-h"): # Help
        help()
      elif(arguments[i] == "-f"): # File
        k = i+1
        file = noteFile(arguments[k])
        if(not inData(arguments[k])):
          insertData(arguments[k])
          echo "successfully inserted data"
        arguments[k] = "" # Preserves list length
        # arguments.delete(k)
        # arguments.add("")
      elif(arguments[i] == "-t"): # time append
        head()
      else:
        # throw error hcdere
        raise newException(argError, "Argument not recognized.")
    else:
      message.add(arguments[i])
      message.add(" ")
      
  message.add("\n")
  message.add("----------------------------")
  writeMess(message)
  db.close

###      ###
### Main ###
###      ###

main()

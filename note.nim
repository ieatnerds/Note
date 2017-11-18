# ieatnerds(Nicholas Kelly)
# importantnk@gmail.com
#
# This will create a note based on the command line arguments used
# to run the program. 
#
# This note will have several options to append things such as dates to the
# note. These messages will be written to a file called notes.txt

###                    ###
### Imports & Includes ###
###                    ###

import 
  strutils, osproc, os, times,
  terminal, sequtils, db_sqlite, typetraits

include sqlutil # Also drags logutil and util with it

### Variables ###
var message = ""

### Types ###
type
  argError* = object of Exception

###       ###
### Flags ###
###       ###

proc help(): void =
  # This flag will display help options to the console when used.
  setForegroundColor(fgBlue)
  stdout.write "Help! \n"
  writeStyled "This is the help menu for note.nim \n"
  stdout.write "More coming soon!\n"
  stdout.write "The current arguments for this program include\n"
  writeStyled "1. -h For the help menu\n"
  writeStyled "2. -t For specifying a note table\n"
  writeStyled "3. -c To remove notes.txt\n"
  writeStyled "4. -l Lists all files written to in db\n"
  writeStyled "5. -r For reading contents of note table\n"
  resetAttributes()
  stdout.write "\n"
  info("Help menu accessed")
  quit()

proc clear(files: seq = @["notes"]): void =
  info("Clear files was called.")
  echo "Would you like to remove the following?:"
  for i in 0..high(files):
    echo files[i]
  echo "\nPlease enter y or n."
  var ans = readLine(stdin)
  if(ans == "y"):
    for i in 0..high(files):
      delData(files[i]) # Removes the actual .txt file
      delmeta(files[i]) # remove entry from database
    echo "Removed files."
  else:
    info("No files were removed.")
    echo "No files were removed."

###            ###
### Procedures ###
###            ###
 
proc isArg(arg: string): bool =
  # Returns true if passed string starts with "-"
  if arg.startsWith("-"):
    return true
  else:
    return false

# TODO rewrite to add data to note table
proc writeMess(table:string, message:string): void =
  # This procedure will write a give message to the open file 
  # and then it will close the file, assuming that the file should not 
  # be kept open when we are no longer using it.
  notice("Calling insertData")
  insertData(table, message)
  info("Note table:", table, " was written to.")

# TODO rewrite to print from note table
proc printTable(table:string): void =
  #cats from file name
  var info = @[""]
  info = getnote(table)
  for x in info:
    echo x

proc main(): void =
  # Main will do the heavy lifting of the program, as usual, tying everything
  # else in the program together.
  var
    arguments = commandLineParams()
    k = 0
    table_name = currDur
    nice_name = ""
  if(not exist):
    createMeta()
    
  for i in 0..(high(arguments)):
    if(isArg(arguments[i])):
      if(arguments[i] == "-c"): # Clear
        notice("Argument clear called")
        var name: string
        notice("argument read called")
        if(k+1 >= len(arguments)):
          notice("no table specified for read")
          name = table_name&"notes"
        else:
          name = table_name&arguments[k+1]
          notice("reading table:", name)
        delMeta(name)
        delData(name)
        quit()
        
      elif(arguments[i] == "-h"): # Help
        notice("argument help called")
        help()
        
      elif(arguments[i] == "-t"): # table
        notice("argument table called")
        k = i+1
        table_name = table_name&arguments[k]
        nice_name = nicename&arguments[k]
        arguments[k] = "" # Preserves list length
        # arguments.delete(k)
        # arguments.add("")
        
      elif(arguments[i] == "-l"): # Print from SQL
        notice("print from sql called")
        print_db()
      
      elif(arguments[i] == "-r"): # read table Contents
        var name: string
        notice("argument read called")
        if(k+1 >= len(arguments)):
          notice("no table specified for read")
          name = table_name&"notes"
        else:
          name = table_name&arguments[k+1]
          notice("reading table:", name)

        printTable(name)
        quit()

      else:
        # throw error here
        notice("unrecognized argument")
        raise newException(argError, "Argument not recognized.")

    else:
      notice("adding to message")
      message.add(arguments[i])
      message.add(" ")
  
  if(table_name == currDur):
    notice("No table specified. setting to default")
    table_name = table_name&"notes"
    nice_name = "notes"

  createNote(table_name)
  insertMeta(table_name, nice_name)

  notice("calling write message in main with table:",table_name, "and note", message)
  writeMess(table_name, message)
  db.close

###      ###
### Main ###
###      ###

main()

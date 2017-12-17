# ieatnerds(Nicholas Kelly)
# importantnk@gmail.com
#
# This will create a note based on the command line arguments used
# to run the program.
#
# This note will have several options to append things such as dates to the
# note. These messages will be written to a file called notes.txt

#               
# Documentation 
#               
## :Author: Nicholas Kelly
## This is the documentation for the note module
##
## This was made in an attempt to create easy, quick notes while remaining in
## the terminal.

#                    
# Imports & Includes 
#                    

import
  strutils, osproc, os, times,
  terminal, db_sqlite, typetraits

include sqlutil # Also drags logutil and util with it

# Variables 
var message = ""

# Types 
type
  argError* = object of Exception

#       
# Flags 
#       

## Flag Procedures
## ===============
## These are the procedures that are linked with a command flag for the program.

proc help*(): void =

  ## Help flag procedure
  ## This flag will display help options to the console when used.

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
  quit()

proc clear*(files: seq = @["notes"]): void =
  ## Clear flag procedure
  info("Clear files was called.")
  echo "Would you like to remove the following?:"
  for i in 0..high(files):
    echo files[i]
  echo "\nPlease enter y or n."
  var ans = readLine(stdin)
  if(ans == "y"):
    for i in 0..high(files):
      delData(files[i])
      delMeta(files[i])
      echo "Removed table: ",files[i]
      info("Removed table: ", files[i])
  else:
    info("No tables were removed.")
    echo "No notes were removed."

#            
# Procedures 
#            

## Procedures
## ==========
## Tese are the regular procedures for note.nim

proc isArg*(arg: string): bool =
  ## Returns true if passed string starts with "-"
  ## Returns false otherwise.
  if arg.startsWith("-"):
    return true
  else:
    return false

proc writeMess*(table:string, message:string): void =
  ## This procedure will insert the given message into the specified table
  ## Usually into the table for the directory you're currently in
  insertData(table, message)
  info("Note table:", table, " was written to.")

proc printTable*(table:string): void =
  ## Prints out data from specified table.
  var info = @[""]
  info = getNote(table)
  for x in info:
    echo x

proc main(): void =
  # Main will do the heavy lifting of the program, as usual, tying everything
  # else in the program together.
  var
    arguments = commandLineParams()
    k = 0
    table_name = currDur
    niceName = ""
  if(not exist):
    createMeta()

  for i in 0..(high(arguments)):
    if(isArg(arguments[i])):
      if(arguments[i] == "-c"): # Clear
        var name: string
        if(k+1 >= len(arguments)):
          name = table_name&"notes"
        else:
          name = table_name&arguments[k+1]
        delMeta(name)
        delData(name)
        quit()

      elif(arguments[i] == "-h"): # Help
        help()

      elif(arguments[i] == "-t"): # table
        k = i+1
        table_name = table_name&arguments[k]
        niceName = niceName&arguments[k]
        arguments[k] = "" # Preserves list length

      elif(arguments[i] == "-l"): # Print from SQL
        print_db()

      elif(arguments[i] == "-r"): # read table Contents
        var name: string
        if(k+1 >= len(arguments)):
          name = table_name&"notes"
        else:
          name = table_name&arguments[k+1]

        printTable(name)
        quit()

      else:
        # throw error here
        notice("unrecognized argument")
        raise newException(argError, "Argument not recognized.")

    else:
      message.add(arguments[i])
      message.add(" ")

  if(table_name == currDur):
    notice("No table specified. setting to default")
    table_name = table_name&"notes"
    niceName = "notes"

  createNote(table_name)
  insertMeta(table_name, niceName)

  notice("calling write message in main with table:",table_name,
         "and note", message)
  writeMess(table_name, message)
  db.close

#      
# Main 
#      

main()

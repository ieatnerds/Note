# Utility file for sql database interactions.
import db_sqlite, sequtils, os, osproc, times

include logutil


# Database dirLoc

### Databse Setup ###
var exist = 0
if(fileExists(dirLoc&"metadata.db")):
  exist = 1

let db = open(dirLoc&"metadata.db", nil, nil, nil)
info("Opened sql database.")

### Procedures
proc createTable(): void =
  # This will be used to create the metadata table if it is not
  # already present in the database
  info("Created table.")
  db.exec(sql"""CREATE TABLE meta (
  	            name string,
  	            date string)""")

proc getNum(): int =
  var num = 0
  var data = @[""]
  data.delete(0)
  for x in db.rows(sql"SELECT * FROM meta"):
    data.add(x[0])

  for y in 0..(high(data)):
    if(num < cast[int](data[y])):
      num = cast[int](data[y])
    return num

proc insertData(name:string = "nil"): void =
  # Used to insert a new note file name into the database
  var date = getDateStr()
  db.exec(sql"INSERT INTO meta (name, date) VALUES (?, ?)", name, date)
  info("Inserted data into table")

proc getData(): seq =
  # This will return the names on all entries in the meta table
  var data = @[""]
  data.delete(0)
  for x in db.rows(sql"SELECT * FROM meta"):
    data.add(x[0])
  return data

proc inData(name:string = "nil"): bool =
  # This will be used to check if a name is already in the database
  # This will return true upon success and false upon failure
  var data = db.getValue(sql"SELECT name FROM meta WHERE name = ?", name)
  if(data != ""):
    return true
  else:
    return false

proc delData(name:string ="nil"): void =
  # This procedure will remove a given row from the database. 
  # Used by the clear procedure
  db.exec(sql"DELETE FROM meta WHERE name = ?", name)
  info("Removed data from database.")

proc print_db(filename = dirLoc&"metadata.db"): void =
  #prints out names of all storage files
  var data = getData()
  for i in 0..(high(data)):
    echo data[i] 

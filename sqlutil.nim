# Utility file for sql database interactions.
import db_sqlite, sequtils, os, osproc, times


# Database location
when defined windows:
  const location = "C:/somewhere/over/the/rainbow"
else:
  const location = "/var/data/Note/"

### Databse Setup ###
var exist = 0
if(fileExists(location&"metadata.db")):
  exist = 1

let db = open(location&"metadata.db", nil, nil, nil)

### Procedures
proc createTable(): void =
  # This will be used to create the metadata table if it is not
  # already present in the database
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

proc print_db(filename = location&"metadata.db"): void =
  #prints out names of all storage files
  var data = getData()
  for i in 0..(high(data)):
    echo data[i] 

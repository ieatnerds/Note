# Utility file for sql database interactions.
import db_sqlite, sequtils, os, osproc, times

include logutil # drags util with it


# Database dirLoc

### Databse Setup ###
var exist = 0
if(fileExists(dirLoc&"metadata.db")):
  exist = 1

let db = open(dirLoc&"metadata.db", nil, nil, nil)
info("Opened sql database.")

### Procedures
proc createTable(name:string = "meta"): void =
  # This will be used to create a given table in the database
  # any columns that need to be added can be added in its own
  # procedure using the alter table command
  info("Created table:", name)
  db.exec(sql"CREATE TABLE IF NOT EXISTS ? ()", name)

proc createMeta(): void =
  # this procedure will create the main "meta" table.
  createTable()
  db.exec(sql"ALTER TABLE meta ADD COLUMN id INTEGER PRIMARY KEY")
  db.exec(sql"ALTER TABLE meta ADD COLUMN table_name STRING")
  db.exec(sql"ALTER TABLE meta ADD COLUMN nice_name STRING")
  db.exec(sql"ALTER TABLE meta ADD COLUMN last_edit STRING")
  db.exec(sql"ALTER TABLE meta ADD COLUMN full_path STRING")
  db.exec(sql"ALTER TABLE meta ADD COLUMN tags STRING")

proc createNote(name: string): void =
  createTable(name)
  db.exec(sql"ALTER TABLE ? ADD COLUMN id INTEGER PRIMARY KEY", name)
  db.exec(sql"ALTER TABLE ? ADD COLUMN date STRING", name)
  db.exec(sql"ALTER TABLE ? ADD COLUMN note STRING", name)
  db.exec(sql"ALTER TABLE ? ADD COLUMN tags STRING", name)

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

proc insertMeta(name:string, nice_name:string, tags:string = nil): void =
  # used to insert data into the meta table
  # nice name should be named like 'notes' or 'misc'
  var date = getDateStr()
  db.exec(sql"INSERT INTO meta (table_name, nice_name, last_Edit, fullpath, tags) VALUES(?,?,?,?,?)", name, nice_name, date, currdur, tags)
  info("Inserted data:", currdur&nice_name, " into meta")

proc insertData(table:string, note:string, tags:string = nil): void =
  # Used to insert data into a note table
  var date = getDateStr()
  db.exec(sql"INSERT INTO ? (date, note, tag) VALUES (?, ?, ?)", date, note, date)
  info("Inserted data:", note, " into", table)

proc getmeta(table:string): seq =
  var data = @[""]
  data.delete(0)
  for x in db.rows(sql"SELECT table_name FROM meta WHERE fullpath = ?", currdur):
    data.add(x)
  return data

proc getnote(table:seq): seq =
  var data = @[""]
  data.delete(0)
  for x in db.rows(sql"SELECT * FROM ?", table[0]):
    data.add(x)
  info("Retrieved notes from table:", table)
  return data

proc delmeta(table:string): void =
  db.exec(sql"DELETE FROM meta WHERE table_name = ?", table)
  info("Removed data:", table, " from meta.")

proc delData(table:string): void =
  # This procedure will remove a given row from the database. 
  # Used by the clear procedure
  db.exec(sql"DROP ?", table)
  info("Removed table:", table, " from database.")

proc print_db(): void =
  #prints out names of all note tables from meta
  db.exec(sql"SELECT table_name FROM meta")

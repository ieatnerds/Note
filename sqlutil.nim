# Utility file for sql database interactions.

## This is the documentation for the sqlutil module.
import db_sqlite, sequtils, os, osproc, times, strutils

include logutil # drags util with it

# Databse Setup #
var exist = false
if(fileExists(dirLoc&"metadata.db")):
  exist = true

let db = open(dirLoc&"metadata.db", nil, nil, nil)
info("Opened sql database.")

## Procedures
proc createTable(name:string = "meta"): void =
  ## This will be used to create a given table in the database
  ## any columns that need to be added can be added in its own
  ## procedure using the alter table command
  
  db.exec(sql"CREATE TABLE IF NOT EXISTS ? (id INTEGER PRIMARY KEY)", name)
  info("Created table:", name)

proc createMeta(): void =
  ## this procedure will create the main "meta" table.
  createTable()
  db.exec(sql"ALTER TABLE meta ADD COLUMN table_name STRING")
  db.exec(sql"ALTER TABLE meta ADD COLUMN nice_name STRING")
  db.exec(sql"ALTER TABLE meta ADD COLUMN last_edit STRING")
  db.exec(sql"ALTER TABLE meta ADD COLUMN full_path STRING")
  db.exec(sql"ALTER TABLE meta ADD COLUMN tags STRING")

proc createNote(table: string): void =
  var name = replace(table, currDur, "")
  createTable(table)
  discard db.tryExec(sql"ALTER TABLE ? ADD COLUMN date STRING", table)
  discard db.tryExec(sql"ALTER TABLE ? ADD COLUMN note STRING", table)
  discard db.tryExec(sql"ALTER TABLE ? ADD COLUMN tags STRING", table)

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
  ## used to insert data into the meta table
  ## nice name should be named like 'notes' or 'misc'
  var date = getDateStr()
  db.exec(sql"INSERT INTO meta (table_name, nice_name, last_Edit, full_path, tags) VALUES(?,?,?,?,?)", name, nice_name, date, currdur, tags)
  info("Inserted data:", currdur&nice_name, " into meta")

proc insertData(table:string, note:string, tags:string = nil): void =
  ## Used to insert data into a note table
  var date = getDateStr()
  var name = replace(table, currDur, "")
  db.exec(sql"INSERT INTO ? (date, note, tags) VALUES (?, ?, ?)", table, date, note, tags)
  info("Inserted data:", note, " into", table)

proc getMeta(table:string): seq =
  var data = @[""]
  data.delete(0)
  for x in db.rows(sql"SELECT table_name FROM meta WHERE fullpath = ?", currdur):
    data.add(x)
  return data

proc getNote(table:string): seq =
  var data = @[""]
  data.delete(0)
  for x in db.rows(sql"SELECT * FROM ?", table):
    data.add(x)
  info("Retrieved notes from table:", table)
  return data

proc delMeta(table:string): void =
  db.exec(sql"DELETE FROM meta WHERE table_name = ?", table)
  info("Removed data:", table, " from meta.")

proc delData(table:string): void =
  ## This procedure will remove a given row from the database. 
  ## Used by the clear procedure
  db.exec(sql"DROP TABLE ?", table)
  info("Removed table:", table, " from database.")

proc print_db(): void =
  ## prints out names of all note tables from meta
  db.exec(sql"SELECT table_name FROM meta")

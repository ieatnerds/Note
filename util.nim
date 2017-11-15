# Main util file for note.nim
# Contains constants such as path to note folder

# Define note folder based on operating system
when defined windows:
  var dirLoc = "C:/somewhere/over/the/rainbow"
else: # Else should be unix
  const dirLoc = "/var/data/Note/"




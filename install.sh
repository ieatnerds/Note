#!/bin/bash

$(nim c -d:release note.nim) # make a release build of note
$(cp ./note /usr/local/bin)
$(mkdir -p /var/data/Note)
$(chmod a+w /var/data/Note)
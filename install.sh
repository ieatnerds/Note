#!/bin/bash

$(nim c -d:release --threads:on note.nim) # make a release build of note
$(mkdir -p /var/data/Note)
$(chmod a+w /var/data/Note)
$(cp ./note /var/data/Note/note)
$(ln -sf /var/data/Note/note /usr/local/bin)

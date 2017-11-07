#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

$(nim c -d:release note.nim) # make a release build of note
$(cp ./note /usr/local/bin)

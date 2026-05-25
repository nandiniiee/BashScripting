#!/bin/bash
BINARY="/home/nandini/bashScripting/services/copyBinary"
SOURCE="/home/nandini/bashScripting/services/file1.txt"
DESTINATION="/home/nandini/bashScripting/services/copied.txt"

# passing them as arguments
$BINARY $SOURCE $DESTINATION

# we will do scheduling through cron

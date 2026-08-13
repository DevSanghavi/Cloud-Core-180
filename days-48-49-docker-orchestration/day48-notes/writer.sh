#!/bin/sh
mkdir -p /data
echo "Note from container at $(date)" >> /data/notes.txt
cat /data/notes.txt

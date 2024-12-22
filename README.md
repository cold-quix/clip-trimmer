# clip-trimmer
A PowerShell script that enables simple clip trimming by appending a string to the filename.

## Intent
I have found that saving clips from gaming and sharing them can be a pain, especially when using non-linear editors to trim clips. Using [ffmpeg](https://ffmpeg.org/) commands like `ffmpeg -n -ss start_time -t duration -i input.mp4 output.mp4` can help, but it's clunky to do this for every single clip. Thus, I made this PowerShell script.

This could become a batch/bash script with a little work, but I use PowerShell as often as I can.

## Parameters
`-in`: The filetype to look for. Defaults to mp4.

`-out`: The output format. Defaults to mp4. Uses default ffmpeg settings for re-encoding if different from `-in`.

## Usage
To prepare video files in a directory for trimming, rename them something like `gaming highlight7 2_25`

When run, the script creates a directory `./trimmed` if it doesn't exist. Then it looks in the current directory for all video files matching `-in`'s type with a filename ending in a number, an underscore, then another number. The numbers are the start and end timestamps for the desired clip.

Example: `cool sweet clip 4_17.mp4` will create a 13-second video starting at 00:04 and ending at 00:17, output in `./trimmed` as `cool sweet clip.mp4`

## Notes
1. Avoid exotic characters in filenames, since that may cause unexpected behavior.
﻿1. File name must be a series of words separated by spaces, then the final "#_#" in that exact order. Numbers can be used in filenames.
1. Will not overwrite existing files in ./trimmed/ output directory since -n is passed in ffmpeg command. This is intentional so you can batch trim a bunch of files, output them to ./trimmed/, review them, and redo any with wrong timestamps. Simply delete the output and rename the input, then run the script again.

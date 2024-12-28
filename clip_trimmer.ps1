<#
For each MP4 file in a directory, trim and re-encode a clip of it based on text at the end of the filename.
Output videos are placed in a subfolder named 'trimmed'.

"cool sweet clip 4_17.mp4" will create a video starting at 00:04 and ending at 00:17, output in ./trimmed as "cool sweet clip.mp4".

PARAMS:
- type: The filetype to look for. Defaults to mp4.
- out:  The filetype to output in. Defaults to mp4. Uses default ffmpeg settings for re-encoding.

NOTES:
- File name must be a series of words separated by spaces, then the final "number_number" word in that exact order.
- Will not overwrite existing files in ./trimmed/ output directory since -n is passed in ffmpeg command.
  This is intentional so you can batch trim a bunch of files, output them to ./trimmed/, review them,
  and redo any with wrong timestamps. Simply delete the output and rename the input, then run the script again.
#>

# Look for MP4s by default
param(
    $in = "mp4",
    $out = "mp4"
)

$destination = "./trimmed"
if (Test-Path -Path $destination)
{
    echo "Output directory 'trimmed' already present"
}
else
{
    echo "Making output directory 'trimmed'"
    mkdir trimmed
}

Get-ChildItem . -Filter *.$in |
ForEach-Object {
    $video = $_.Name
    echo "Working on: $video"
    $outputExtension = ".$out"
    
    $vidArray = $video -split ".$in" # Remove .extension from end of filename
    $vidArray = @($vidArray) -ne '' # Remove empty elements

    $vidArray = $vidArray[0] -split " " # Split on spaces
    $outputName = $vidArray[0..($vidArray.length - 2)] # Save name as original filename minus timestamp
    $vidArray = $vidArray[-1] -split "[_]" | Where-Object { $_ -ne '' } # Split timestamp on '_'
    $start = $vidArray[0]
    $end = $vidArray[1]
    $duration = $end - $start
    echo "Start: $start"
    echo "End: $end"
    echo "Duration: $duration"
    echo "Output path: $destination/$outputName$outputExtension"
    # Pass -n to prevent overwrites
    ffmpeg -n -ss $start -t $duration -i $_.Name $destination/$outputName$outputExtension
}


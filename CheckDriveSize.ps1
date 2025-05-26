$drive = Get-PSDrive -Name C
$freeSpaceGB = $drive.Free / 1GB
$desiredSpace = 30
if ($freeSpaceGB -ge $thresholdGB) {
    # Success, space is 30GB or more, exiting with code 0
    exit 0
} else {
    # Failure, space is less than 30GB, exiting with code 1
    exit 1
}
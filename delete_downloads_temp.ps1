$user_profile_location = "C:\Users"
$log_file_path = Join-Path -Path $PSScriptRoot -ChildPath "TestLog.txt"

function Clear-Folder{
param (
        $FolderName,
        $OlderThanDays
    )

$limit = (Get-Date).AddDays($OlderThanDays*-1)

Write-Output "Deleting contents of folder $FolderName older than $limit" >> $log_file_path
Get-ChildItem -Path $FolderName -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force
}


$user_profiles = Get-ChildItem $user_profile_location

foreach ($user_profile in $user_profiles) {
$profile_location = Join-Path -Path $user_profile_location -ChildPath $user_profile
$downloads = Join-Path -Path $profile_location -ChildPath "Downloads"
Clear-Folder -FolderName $downloads -OlderThanDays 60
$temp = Join-Path -Path $profile_location -ChildPath "AppData\Local\Temp"
Clear-Folder -FolderName $temp -OlderThanDays 1
}

Clear-Folder -FolderName "c:\windows\temp" -OlderThanDays 1
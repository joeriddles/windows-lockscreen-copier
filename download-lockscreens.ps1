param ($destination_folder)
if ($null -eq $destination_folder) {
    $destination_folder = $HOME + "\Pictures\"
    $lockscreen_folder = $destination_folder + "Lockscreens\"
    if (!(Test-Path -Path $lockscreen_folder)) {
        New-Item -Path $destination_folder -Name "Lockscreens" -ItemType "directory"
        Write-Host "Created Lockscreen directory"
    }
    $destination_folder = $lockscreen_folder
}

$source_path = $HOME + "\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\"
$files = @(Get-ChildItem -Path $source_path)
$files.ForEach({
    $file_path = $source_path + "\" + $_
    $destination_path = $destination_folder + $_ + ".jpg"
    Copy-Item -Path $file_path -Destination $destination_path
})

Write-Host "Copied" $files.Count "files to" $destination_folder
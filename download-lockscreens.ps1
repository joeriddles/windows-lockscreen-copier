$path = $HOME + "\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\"
Write-Host $path
$destination_folder = "C:\Users\JosephRiddle\Pictures\Lockscreens\"
$files = @(Get-ChildItem -Path $Path)
$files.ForEach({
    $file_path = $path + "\" + $_
    $destination_path = $destination_folder + $_ + ".jpg"
    Copy-Item -Path $file_path -Destination $destination_path
})
Write-Host "Copied" $files.Count "files."
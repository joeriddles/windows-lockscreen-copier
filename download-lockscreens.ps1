param ($destination_folder)
if ($null -eq $destination_folder) {
    $destination_folder = $HOME + "\Pictures\Lockscreens\"
}
Write-Host "Destination Path:" $destination_folder

$source_path = $HOME + "\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\"
$files = @(Get-ChildItem -Path $source_path)
$files.ForEach({
    $file_path = $source_path + "\" + $_
    $destination_path = $destination_folder + $_ + ".jpg"
    Copy-Item -Path $file_path -Destination $destination_path
})
Write-Host "Copied" $files.Count "files."
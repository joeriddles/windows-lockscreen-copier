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

try {
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
} catch {
    Write-Host "Could not load System.Drawing. Cannot read image dimensions."
}

$source_path = $HOME + "\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\"
$files = @(Get-ChildItem -Path $source_path)
$files.ForEach({
    $image_name = $_
    $file_path = $source_path + "\" + $image_name

    $Image = $null
    try {
        $Image = [System.Drawing.Image]::FromFile($file_path)
    } catch {
        Write-Host "Could not load image: " $image_name
    }

    if (!($null -eq $Image)) {
        if (1920 -eq $Image.Height -and 1080 -eq $Image.Width) {
            $image_name = "desktop-" + $image_name
        } elseif (1080 -eq $Image.Height -and 1920 -eq $Image.Width) {
            $image_name = "mobile-" + $image_name
        } else {
            # This image does not appear to be a background
            return
        }
    }

    $destination_path = $destination_folder + $image_name + ".jpg"
    Copy-Item -Path $file_path -Destination $destination_path
})

Write-Host "Copied" $files.Count "files to" $destination_folder
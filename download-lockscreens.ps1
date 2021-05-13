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
    Write-Error "Could not load System.Drawing. Cannot read image dimensions."
}

$copied_count = 0
$desktop_count = 0
$mobile_count = 0

$lockscreen_source_path = $HOME + "\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets\"
if (!(Test-Path -Path $lockscreen_source_path)) {
    Write-Error "Oh no! I can't find the lockscreen wallpaper path on this computer!"
    exit -1
}

$files = @(Get-ChildItem -Path $lockscreen_source_path)
$files.ForEach({
    $image_name = $_.Name
    $file_path = $lockscreen_source_path + "\" + $image_name

    $Image = $null
    try {
        $Image = [System.Drawing.Image]::FromFile($file_path)
    } catch { }

    if (!($null -eq $Image)) {
        if (1920 -eq $Image.Height -and 1080 -eq $Image.Width) {
            $mobile_count += 1
            $image_name = "mobile_" + $mobile_count
        } elseif (1080 -eq $Image.Height -and 1920 -eq $Image.Width) {
            $desktop_count += 1
            $image_name = "desktop_" + $desktop_count
        } else {
            # This image does not appear to be a background
            return
        }
    }

    $destination_path = $destination_folder + $image_name + ".jpg"
    Copy-Item -Path $file_path -Destination $destination_path
    $copied_count = $copied_count + 1
})

Write-Host @"
Copied ${copied_count} files to ${destination_folder}
    - ${desktop_count} desktop images
    - ${mobile_count} mobile images
"@
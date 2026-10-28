Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\Prashanth\OneDrive\Pictures\Camera Roll\PRASHANTH - WIN_20200424_123505.JPG"
$outDir = "c:\Users\Prashanth\prashanth-portfolio\assets"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$src = [System.Drawing.Image]::FromFile($srcPath)

# Face sits in the right-center of the 1280x720 webcam frame
$cropSize = 640
$cropX = 520
$cropY = 20
$rect = New-Object System.Drawing.Rectangle $cropX, $cropY, $cropSize, $cropSize

$avatarSize = 640
$avatar = New-Object System.Drawing.Bitmap $avatarSize, $avatarSize
$g = [System.Drawing.Graphics]::FromImage($avatar)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.DrawImage($src, (New-Object System.Drawing.Rectangle 0, 0, $avatarSize, $avatarSize), $rect, [System.Drawing.GraphicsUnit]::Pixel)

# Gentle brightness lift
$cm = New-Object System.Drawing.Imaging.ColorMatrix
$cm.Matrix00 = 1.08
$cm.Matrix11 = 1.08
$cm.Matrix22 = 1.08
$cm.Matrix33 = 1
$cm.Matrix40 = 0.04
$cm.Matrix41 = 0.04
$cm.Matrix42 = 0.04
$attrs = New-Object System.Drawing.Imaging.ImageAttributes
$attrs.SetColorMatrix($cm)
$bright = New-Object System.Drawing.Bitmap $avatarSize, $avatarSize
$gb = [System.Drawing.Graphics]::FromImage($bright)
$gb.DrawImage($avatar, (New-Object System.Drawing.Rectangle 0, 0, $avatarSize, $avatarSize), 0, 0, $avatarSize, $avatarSize, [System.Drawing.GraphicsUnit]::Pixel, $attrs)

$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoder = [System.Drawing.Imaging.Encoder]::Quality
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters 1
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter $encoder, 88L

$bright.Save("$outDir\avatar.jpg", $jpegCodec, $encoderParams)

# Open Graph card
$og = New-Object System.Drawing.Bitmap 1200, 630
$go = [System.Drawing.Graphics]::FromImage($og)
$go.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$go.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$go.Clear([System.Drawing.Color]::FromArgb(255, 7, 17, 31))
$accent = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 100, 255, 218))
$text = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 230, 241, 255))
$muted = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 136, 146, 176))
$go.FillEllipse($accent, 86, 141, 348, 348)
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$path.AddEllipse(94, 149, 332, 332)
$go.SetClip($path)
$go.DrawImage($bright, 94, 149, 332, 332)
$go.ResetClip()

$family = New-Object System.Drawing.FontFamily "Segoe UI"
$syne = New-Object System.Drawing.Font($family, 42, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point)
$mono = New-Object System.Drawing.Font($family, 16, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point)
$go.DrawString("PRASHANTH S", $syne, $text, 480, 210)
$go.DrawString("ML Engineer  |  DHL IT Services", $mono, $accent, 480, 290)
$go.DrawString("Production ML, pipelines, and logistics analytics", $mono, $muted, 480, 340)

$og.Save("$outDir\og.jpg", $jpegCodec, $encoderParams)

$g.Dispose(); $gb.Dispose(); $go.Dispose()
$avatar.Dispose(); $bright.Dispose(); $og.Dispose(); $src.Dispose()
Write-Output "Wrote avatar.jpg and og.jpg"

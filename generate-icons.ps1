Add-Type -AssemblyName System.Drawing

# ----- App Icon 512x512 -----
Write-Host "Generating appicon.png..."
$size = 512
$bmp = new-object System.Drawing.Bitmap($size, $size)
$bmp.SetResolution(96, 96)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Rounded rect clip
$cr = [int]($size * 0.195)
$path = new-object System.Drawing.Drawing2D.GraphicsPath
$path.AddArc(0, 0, $cr*2, $cr*2, 180, 90)
$path.AddArc($size-$cr*2, 0, $cr*2, $cr*2, 270, 90)
$path.AddArc($size-$cr*2, $size-$cr*2, $cr*2, $cr*2, 0, 90)
$path.AddArc(0, $size-$cr*2, $cr*2, $cr*2, 90, 90)
$path.CloseFigure()
$g.Clip = new-object System.Drawing.Region($path)

# Gradient background (blue → green)
$rect = new-object System.Drawing.Rectangle(0, 0, $size, $size)
$brush = new-object System.Drawing.Drawing2D.LinearGradientBrush(
    $rect,
    [System.Drawing.Color]::FromArgb(0, 122, 255),
    [System.Drawing.Color]::FromArgb(52, 199, 89),
    [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
)
$g.FillRectangle($brush, $rect)
$g.ResetClip()

# Witte "A" met mooie proporties
$font = new-object System.Drawing.Font("Arial", 380, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$white = new-object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$fmt = new-object System.Drawing.StringFormat
$fmt.Alignment = [System.Drawing.StringAlignment]::Center
$fmt.LineAlignment = [System.Drawing.StringAlignment]::Center
$g.DrawString("a", $font, $white, ($size/2), ($size/2)+8, $fmt)
$font.Dispose()
$white.Dispose()
$fmt.Dispose()
$g.Dispose()
$bmp.Save("appicon.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "  -> appicon.png saved"

# ----- Favicon 32x32 -----
Write-Host "Generating favicon.png..."
$fsize = 32
$fbmp = new-object System.Drawing.Bitmap($fsize, $fsize)
$fbmp.SetResolution(96, 96)
$fg = [System.Drawing.Graphics]::FromImage($fbmp)
$fg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$fg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$fg.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Gradient background
$frect = new-object System.Drawing.Rectangle(0, 0, $fsize, $fsize)
$fbrush = new-object System.Drawing.Drawing2D.LinearGradientBrush(
    $frect,
    [System.Drawing.Color]::FromArgb(0, 122, 255),
    [System.Drawing.Color]::FromArgb(52, 199, 89),
    [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
)
$fg.FillRectangle($fbrush, $frect)

# Witte "A"
$ffont = new-object System.Drawing.Font("Arial", 24, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$fwhite = new-object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$ffmt = new-object System.Drawing.StringFormat
$ffmt.Alignment = [System.Drawing.StringAlignment]::Center
$ffmt.LineAlignment = [System.Drawing.StringAlignment]::Center
$fg.DrawString("a", $ffont, $fwhite, ($fsize/2), ($fsize/2)+1, $ffmt)
$ffont.Dispose()
$fwhite.Dispose()
$ffmt.Dispose()
$fg.Dispose()
$fbmp.Save("favicon.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "  -> favicon.png saved"

# ----- Favicon ICO -----
Write-Host "Generating favicon.ico..."
$icoStream = new-object System.IO.MemoryStream
$icoWriter = new-object System.IO.BinaryWriter($icoStream)
$icoWriter.Write(0)
$icoWriter.Write(1)
$icoWriter.Write(1)
$icoWriter.Write([byte]$fsize)
$icoWriter.Write([byte]$fsize)
$icoWriter.Write([byte]0)
$icoWriter.Write([byte]0)
$icoWriter.Write([int16]1)
$icoWriter.Write([int16]32)
$bmpStream = new-object System.IO.MemoryStream
$fbmp.Save($bmpStream, [System.Drawing.Imaging.ImageFormat]::Bmp)
$bmpBytes = $bmpStream.ToArray()
$icoWriter.Write(6+16)
$icoWriter.Write($bmpBytes.Length)
$icoWriter.Write($bmpBytes)
$icoWriter.Flush()
$icoStream.Flush()
[System.IO.File]::WriteAllBytes("favicon.ico", $icoStream.ToArray())
$icoWriter.Dispose()
$icoStream.Dispose()
$bmpStream.Dispose()
$fbmp.Dispose()
$bmp.Dispose()
Write-Host "  -> favicon.ico saved"
Write-Host "Done!"

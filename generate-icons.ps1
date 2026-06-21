Add-Type -AssemblyName System.Drawing

function Draw-MinimalSyringe {
    param([System.Drawing.Graphics]$g, [int]$cx, [int]$cy, [float]$s)

    $white = [System.Drawing.Color]::White
    $pw = new-object System.Drawing.Pen($white, [math]::Max(1.5, $s * 2.0))
    $pw.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $pw.StartCap = [System.Drawing.Drawing2D.LineCap]::Round

    # Needle — diagonal line pointing up-right
    $g.DrawLine($pw, $cx+[int](13*$s), $cy-[int](10*$s), $cx+[int](20*$s), $cy-[int](3*$s))

    # Barrel — simple rounded rectangle
    $bp = new-object System.Drawing.Pen($white, [math]::Max(1.2, $s * 1.8))
    $g.DrawRectangle($bp, $cx-[int](8*$s), $cy+[int](3*$s), [int](20*$s), [int](16*$s))

    # Plunger rod
    $g.DrawLine($pw, $cx+[int](2*$s), $cy+[int](19*$s), $cx+[int](2*$s), $cy+[int](27*$s))

    # Plunger handle — simple filled rect
    $g.FillRectangle([System.Drawing.Brushes]::White, $cx-[int](4*$s), $cy+[int](25*$s), [int](12*$s), [int](3*$s))

    # Finger rests — two short lines on each side
    $fw = new-object System.Drawing.Pen($white, [math]::Max(1.5, $s * 2.2))
    $g.DrawLine($fw, $cx-[int](8*$s), $cy+[int](6*$s), $cx-[int](14*$s), $cy+[int](6*$s))
    $g.DrawLine($fw, $cx+[int](12*$s), $cy+[int](6*$s), $cx+[int](18*$s), $cy+[int](6*$s))
}

# ----- App Icon 512x512 (behoudt gradient) -----
Write-Host "Generating appicon.png..."
$size = 512
$bmp = new-object System.Drawing.Bitmap($size, $size)
$bmp.SetResolution(96, 96)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

$cr = [int]($size * 0.195)
$path = new-object System.Drawing.Drawing2D.GraphicsPath
$path.AddArc(0, 0, $cr*2, $cr*2, 180, 90)
$path.AddArc($size-$cr*2, 0, $cr*2, $cr*2, 270, 90)
$path.AddArc($size-$cr*2, $size-$cr*2, $cr*2, $cr*2, 0, 90)
$path.AddArc(0, $size-$cr*2, $cr*2, $cr*2, 90, 90)
$path.CloseFigure()
$g.Clip = new-object System.Drawing.Region($path)

$rect = new-object System.Drawing.Rectangle(0, 0, $size, $size)
$brush = new-object System.Drawing.Drawing2D.LinearGradientBrush(
    $rect,
    [System.Drawing.Color]::FromArgb(0, 122, 255),
    [System.Drawing.Color]::FromArgb(52, 199, 89),
    [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
)
$g.FillRectangle($brush, $rect)
$g.ResetClip()

Draw-MinimalSyringe $g ($size/2) ($size/2) ($size/65.0)
$g.Dispose()
$bmp.Save("appicon.png", [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "  -> appicon.png saved"

# ----- Favicon 32x32 — SIMPEL & STRAK -----
Write-Host "Generating favicon.png (simpel & strak)..."
$fsize = 32
$fbmp = new-object System.Drawing.Bitmap($fsize, $fsize)
$fbmp.SetResolution(96, 96)
$fg = [System.Drawing.Graphics]::FromImage($fbmp)
$fg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$fg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$fg.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Gradient background (zelfde als appicon)
$frect = new-object System.Drawing.Rectangle(0, 0, $fsize, $fsize)
$fbrush = new-object System.Drawing.Drawing2D.LinearGradientBrush(
    $frect,
    [System.Drawing.Color]::FromArgb(0, 122, 255),
    [System.Drawing.Color]::FromArgb(52, 199, 89),
    [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
)
$fg.FillRectangle($fbrush, $frect)

# Zelfde syringe als appicon (via Draw-Syringe)
Write-Host "  drawing favicon syringe..."
Draw-MinimalSyringe $fg ($fsize/2) ($fsize/2) ($fsize/65.0)
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

Add-Type -AssemblyName System.Drawing

function Draw-Syringe {
    param([System.Drawing.Graphics]$g, [int]$cx, [int]$cy, [float]$s)

    $white = [System.Drawing.Color]::White
    $ww = new-object System.Drawing.Pen($white, [math]::Max(1.0, $s * 1.8))
    $ww.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
    $ww.StartCap = [System.Drawing.Drawing2D.LineCap]::Round

    # Pre-calc all coordinates
    $n1x = $cx + [int](7*$s); $n1y = $cy - [int](12*$s)
    $n2x = $cx + [int](13*$s); $n2y = $cy - [int](6*$s)

    $t1x = $cx + [int](5*$s); $t1y = $cy - [int](6*$s)
    $t2x = $cx + [int](9*$s); $t2y = $cy - [int](3*$s)
    $t3x = $cx + [int](4*$s); $t3y = $cy - [int](1*$s)

    $bx = $cx - [int](9*$s); $by = $cy

    $prx = $cx - [int](1*$s); $pry1 = $cy + [int](15*$s); $pry2 = $cy + [int](21*$s)

    $hx = $cx - [int](5*$s); $hy = $cy + [int](20*$s)
    $hw = [int](8*$s); $hh = [int](3*$s)
    $hr = [int](3*$s)

    $fl1x1 = $cx - [int](9*$s);  $fl1y = $cy + [int](2*$s);  $fl1x2 = $cx - [int](14*$s)
    $fl2x1 = $cx - [int](9*$s);  $fl2y = $cy + [int](6*$s);  $fl2x2 = $cx - [int](14*$s)
    $fl3x1 = $cx + [int](7*$s);  $fl3y = $cy + [int](2*$s);  $fl3x2 = $cx + [int](12*$s)
    $fl4x1 = $cx + [int](7*$s);  $fl4y = $cy + [int](6*$s);  $fl4x2 = $cx + [int](12*$s)

    $lqx = $cx - [int](6*$s); $lqy = $cy + [int](10*$s); $lqx2 = $cx + [int](4*$s)

    # Needle
    $g.DrawLine($ww, $n1x, $n1y, $n2x, $n2y)

    # Needle tip
    $tipPts = @(
        (new-object System.Drawing.PointF($t1x, $t1y)),
        (new-object System.Drawing.PointF($t2x, $t2y)),
        (new-object System.Drawing.PointF($t3x, $t3y))
    )
    $g.FillPolygon([System.Drawing.Brushes]::White, $tipPts)

    # Barrel
    $bp = new-object System.Drawing.Pen($white, [math]::Max(1.0, $s * 1.5))
    $g.DrawRectangle($bp, $bx, $by, [int](16*$s), [int](15*$s))

    # Plunger rod
    $g.DrawLine($ww, $prx, $pry1, $prx, $pry2)

    # Plunger handle
    $handle = new-object System.Drawing.Drawing2D.GraphicsPath
    $handle.AddArc($hx, $hy, $hr*2, $hr*2, 180, 90)
    $handle.AddArc($hx+$hw-$hr*2, $hy, $hr*2, $hr*2, 270, 90)
    $handle.AddLine($hx+$hw, $hy+$hr, $hx+$hw, $hy+$hh-$hr)
    $handle.AddArc($hx+$hw-$hr*2, $hy+$hh-$hr*2, $hr*2, $hr*2, 0, 90)
    $handle.AddArc($hx, $hy+$hh-$hr*2, $hr*2, $hr*2, 90, 90)
    $handle.CloseFigure()
    $g.FillPath([System.Drawing.Brushes]::White, $handle)

    # Finger flanges
    $fw = new-object System.Drawing.Pen($white, [math]::Max(1.5, $s * 2.0))
    $g.DrawLine($fw, $fl1x1, $fl1y, $fl1x2, $fl1y)
    $g.DrawLine($fw, $fl2x1, $fl2y, $fl2x2, $fl2y)
    $g.DrawLine($fw, $fl3x1, $fl3y, $fl3x2, $fl3y)
    $g.DrawLine($fw, $fl4x1, $fl4y, $fl4x2, $fl4y)

    # Liquid level
    $lp = new-object System.Drawing.Pen([System.Drawing.Color]::FromArgb(140, 255, 255, 255), [math]::Max(1.0, $s * 1.2))
    $g.DrawLine($lp, $lqx, $lqy, $lqx2, $lqy)
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

Draw-Syringe $g ($size/2) ($size/2) ($size/60.0)
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

# Solid background — geen gradient
$bgColor = [System.Drawing.Color]::FromArgb(0, 122, 255)  # #007aff
$fg.Clear($bgColor)

# Witte syringe, dikkere lijnen voor kleine favicon
Write-Host "  drawing favicon syringe..."
$s = $fsize / 52.0  # scale factor

$white = [System.Drawing.Color]::White
$pw = new-object System.Drawing.Pen($white, [math]::Max(1.5, $s * 2.2))
$pw.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$pw.StartCap = [System.Drawing.Drawing2D.LineCap]::Round

$cx = $fsize/2; $cy = $fsize/2 - 1

# Needle
$fg.DrawLine($pw, $cx+[int](6*$s), $cy-[int](10*$s), $cx+[int](11*$s), $cy-[int](5*$s))

# Needle tip (filled triangle)
$tip1x = $cx+[int](4*$s); $tip1y = $cy-[int](5*$s)
$tip2x = $cx+[int](8*$s); $tip2y = $cy-[int](2*$s)
$tip3x = $cx+[int](3*$s); $tip3y = $cy
$tipPts2 = [System.Drawing.PointF[]]@(
    (new-object System.Drawing.PointF($tip1x, $tip1y)),
    (new-object System.Drawing.PointF($tip2x, $tip2y)),
    (new-object System.Drawing.PointF($tip3x, $tip3y))
)
$fg.FillPolygon([System.Drawing.Brushes]::White, $tipPts2)

# Barrel
$bp2 = new-object System.Drawing.Pen($white, [math]::Max(1.2, $s * 1.8))
$fg.DrawRectangle($bp2, $cx-[int](8*$s), $cy+[int](1*$s), [int](14*$s), [int](13*$s))

# Plunger rod
$fg.DrawLine($pw, $cx-[int](1*$s), $cy+[int](14*$s), $cx-[int](1*$s), $cy+[int](19*$s))

# Plunger handle
$fg.FillRectangle([System.Drawing.Brushes]::White, $cx-[int](4*$s), $cy+[int](18*$s), [int](6*$s), [int](3*$s))

# Finger flanges
$fw2 = new-object System.Drawing.Pen($white, [math]::Max(1.5, $s * 2.2))
$fg.DrawLine($fw2, $cx-[int](8*$s), $cy+[int](2*$s), $cx-[int](12*$s), $cy+[int](2*$s))
$fg.DrawLine($fw2, $cx-[int](8*$s), $cy+[int](5*$s), $cx-[int](12*$s), $cy+[int](5*$s))
$fg.DrawLine($fw2, $cx+[int](6*$s), $cy+[int](2*$s), $cx+[int](10*$s), $cy+[int](2*$s))
$fg.DrawLine($fw2, $cx+[int](6*$s), $cy+[int](5*$s), $cx+[int](10*$s), $cy+[int](5*$s))

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

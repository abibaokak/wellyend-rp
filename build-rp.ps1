$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = Join-Path (Get-Location) '.rpbuild'
if (Test-Path $root) { Remove-Item -Recurse -Force $root }
New-Item -ItemType Directory -Force -Path $root | Out-Null

function Write-Utf8([string]$path, [string]$content) {
    $dir = Split-Path -Parent $path
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
    [IO.File]::WriteAllText($path, $content, (New-Object Text.UTF8Encoding($false)))
}

function New-Bitmap([int]$w, [int]$h) {
    $b = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($b)
    $g.Clear([System.Drawing.Color]::Transparent)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
    return @{ B = $b; G = $g }
}

function Save-Png([string]$path, $canvas) {
    $canvas.G.Dispose()
    $canvas.B.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $canvas.B.Dispose()
}

function Brush([int]$a, [int]$r, [int]$g, [int]$b) {
    return New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($a, $r, $g, $b))
}

function Pen([int]$a, [int]$r, [int]$g, [int]$b, [int]$width = 1) {
    return New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb($a, $r, $g, $b), $width)
}

# --- pack.mcmeta: 1.21.11 = 75, supported 48..75 ---
Write-Utf8 (Join-Path $root 'pack.mcmeta') '{"pack":{"pack_format":75,"supported_formats":[48,75],"description":"WellyEndEvent - кастомный лут Энда"}}'

# --- иконка ---
$icon = New-Bitmap 128 128
$bg = Brush 255 14 8 28
$icon.G.FillRectangle($bg, 0, 0, 128, 128)
$glow = Brush 255 123 47 247
for ($i = 0; $i -lt 5; $i++) {
    $alpha = 70 - $i * 12
    $p = Brush $alpha 180 90 255
    $icon.G.FillEllipse($p, 18 + $i * 8, 18 + $i * 8, 92 - $i * 16, 92 - $i * 16)
}
$shardBrush = Brush 255 235 225 255
$edge = Pen 255 140 100 255 3
$points = [System.Drawing.Point[]]@(
    (New-Object System.Drawing.Point(64, 16)), (New-Object System.Drawing.Point(94, 38)),
    (New-Object System.Drawing.Point(88, 90)), (New-Object System.Drawing.Point(64, 112)),
    (New-Object System.Drawing.Point(38, 90)), (New-Object System.Drawing.Point(33, 38))
)
$icon.G.FillPolygon($shardBrush, $points)
$icon.G.DrawPolygon($edge, $points)
$rune = Brush 255 150 80 255
$icon.G.FillRectangle($rune, 58, 34, 7, 54)
$icon.G.FillRectangle($rune, 72, 46, 7, 38)
$cyan = Brush 255 90 225 255
$icon.G.FillRectangle($cyan, 44, 74, 40, 6)
$icon.G.FillRectangle($cyan, 50, 84, 28, 4)
Save-Png (Join-Path $root 'pack.png') $icon

# --- модели ванильных предметов с overrides по custom_model_data ---
function Write-VanillaModel([string]$name, [string]$texture, [int]$cmd, [string]$model) {
    $json = @"
{
  "parent": "minecraft:item/generated",
  "textures": { "layer0": "minecraft:item/$texture" },
  "overrides": [
    { "predicate": { "custom_model_data": $cmd }, "model": "$model" }
  ]
}
"@
    Write-Utf8 (Join-Path $root "assets\minecraft\models\item\$name.json") $json
}

Write-VanillaModel 'paper' 'paper' 2001 'welly:item/end_shard'
Write-VanillaModel 'netherite_scrap' 'netherite_scrap' 2002 'welly:item/ancient_scrap'
Write-VanillaModel 'ender_pearl' 'ender_pearl' 2003 'welly:item/end_pearl'
Write-VanillaModel 'snowball' 'snowball' 2004 'welly:item/smoke_bomb'

foreach ($m in @('end_shard', 'ancient_scrap', 'end_pearl', 'smoke_bomb')) {
    Write-Utf8 (Join-Path $root "assets\welly\models\item\$m.json") (@"
{
  "parent": "minecraft:item/generated",
  "textures": { "layer0": "welly:item/$m" }
}
"@)
}

$texDir = Join-Path $root 'assets\welly\textures\item'
if (-not (Test-Path $texDir)) { New-Item -ItemType Directory -Force -Path $texDir | Out-Null }

# --- Осколок Энда: светящийся кристалл с рунами ---
$c = New-Bitmap 32 32
$paper = Brush 255 240 236 250
$c.G.FillPolygon($paper, [System.Drawing.Point[]]@(
    (New-Object System.Drawing.Point(16, 2)), (New-Object System.Drawing.Point(27, 8)),
    (New-Object System.Drawing.Point(29, 22)), (New-Object System.Drawing.Point(16, 30)),
    (New-Object System.Drawing.Point(4, 22)), (New-Object System.Drawing.Point(5, 8))
))
$c.G.DrawPolygon((Pen 255 120 90 180 2), [System.Drawing.Point[]]@(
    (New-Object System.Drawing.Point(16, 2)), (New-Object System.Drawing.Point(27, 8)),
    (New-Object System.Drawing.Point(29, 22)), (New-Object System.Drawing.Point(16, 30)),
    (New-Object System.Drawing.Point(4, 22)), (New-Object System.Drawing.Point(5, 8))
))
$violet = Brush 255 155 80 255
$c.G.FillRectangle($violet, 13, 7, 3, 17)
$c.G.FillRectangle($violet, 19, 10, 3, 13)
$c.G.FillRectangle($violet, 15, 17, 7, 3)
$cyan = Brush 255 90 220 255
$c.G.FillRectangle($cyan, 8, 22, 16, 3)
$c.G.FillRectangle($cyan, 11, 25, 10, 2)
Save-Png (Join-Path $texDir 'end_shard.png') $c

# --- Древний обломок: незеритовый осколок с оранжевой прожилкой ---
$c = New-Bitmap 32 32
$metal = Brush 255 62 58 72
$c.G.FillPolygon($metal, [System.Drawing.Point[]]@(
    (New-Object System.Drawing.Point(6, 4)), (New-Object System.Drawing.Point(25, 3)),
    (New-Object System.Drawing.Point(30, 13)), (New-Object System.Drawing.Point(24, 28)),
    (New-Object System.Drawing.Point(7, 27)), (New-Object System.Drawing.Point(2, 15))
))
$c.G.DrawPolygon((Pen 255 22 20 28 2), [System.Drawing.Point[]]@(
    (New-Object System.Drawing.Point(6, 4)), (New-Object System.Drawing.Point(25, 3)),
    (New-Object System.Drawing.Point(30, 13)), (New-Object System.Drawing.Point(24, 28)),
    (New-Object System.Drawing.Point(7, 27)), (New-Object System.Drawing.Point(2, 15))
))
$shine = Brush 255 120 118 138
$c.G.FillRectangle($shine, 8, 7, 10, 3)
$ember = Brush 255 255 150 60
$c.G.FillRectangle($ember, 18, 12, 3, 11)
$c.G.FillRectangle($ember, 14, 20, 7, 3)
Save-Png (Join-Path $texDir 'ancient_scrap.png') $c

# --- Жемчуг Края: фиолетово-голубой жемчуг ---
$c = New-Bitmap 32 32
$c.G.FillEllipse((Brush 255 92 44 150), 3, 3, 26, 26)
$c.G.FillEllipse((Brush 255 150 90 235), 6, 5, 20, 20)
$c.G.FillEllipse((Brush 255 210 180 255), 9, 8, 10, 8)
$c.G.FillEllipse((Brush 255 90 225 255), 17, 18, 6, 5)
$c.G.DrawEllipse((Pen 255 60 25 110 2), 3, 3, 26, 26)
Save-Png (Join-Path $texDir 'end_pearl.png') $c

# --- Дымовая бомба: тёмный шар с фитилём ---
$c = New-Bitmap 32 32
$c.G.FillEllipse((Brush 255 34 40 50), 4, 7, 24, 21)
$c.G.FillEllipse((Brush 255 74 84 98), 7, 9, 17, 14)
$c.G.FillEllipse((Brush 255 130 145 160), 9, 10, 7, 5)
$c.G.FillRectangle((Brush 255 180 120 255), 15, 2, 3, 7)
$c.G.FillRectangle((Brush 255 255 220 120), 14, 0, 5, 4)
$c.G.FillRectangle((Brush 255 22 26 34), 5, 20, 22, 4)
Save-Png (Join-Path $texDir 'smoke_bomb.png') $c

# --- zip ---
$zip = Join-Path (Get-Location) 'WellyEndEventRP.zip'
if (Test-Path $zip) { Remove-Item -Force $zip }
[IO.Compression.ZipFile]::CreateFromDirectory($root, $zip)
Remove-Item -Recurse -Force $root

$hash1 = (Get-FileHash -Algorithm SHA1 $zip).Hash.ToLowerInvariant()
$hash256 = (Get-FileHash -Algorithm SHA256 $zip).Hash.ToLowerInvariant()
"PACK: $zip"
"SIZE: $((Get-Item $zip).Length)"
"SHA1: $hash1"
"SHA256: $hash256"

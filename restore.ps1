$ErrorActionPreference = "Stop"
$tag = "data-backup-2026-11-07"
$repo = "vaibhav7087/gesture_detection"
$entries = @(
  @{ file = 'app-debug.apk'; rel = 'build\app\outputs\apk\debug\app-debug.apk'; chunks = @('app-debug.apk'); sha256 = 'd13bb58aed7d83372002c7a99c3ab347ec8657573e5adb04ac21e127b9b120f3' },
  @{ file = 'app-debug.apk'; rel = 'build\app\outputs\flutter-apk\app-debug.apk'; chunks = @('app-debug.apk'); sha256 = 'd13bb58aed7d83372002c7a99c3ab347ec8657573e5adb04ac21e127b9b120f3' }
)
$dl = Join-Path $PSScriptRoot "restore_download"
New-Item -ItemType Directory -Force -Path $dl | Out-Null
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { Write-Error "gh CLI required and authenticate, e.g. set GH_TOKEN env" }
Write-Host "Downloading release assets for $repo"
& gh release download $tag --repo $repo --dir $dl
foreach ($e in $entries) {
  $out = Join-Path $PSScriptRoot $e.rel
  $parent = Split-Path $out -Parent
  New-Item -ItemType Directory -Force -Path $parent | Out-Null
  $fs = [System.IO.File]::Create($out)
  foreach ($c in $e.chunks) {
    $cp = Join-Path $dl $c
    if (-not (Test-Path -LiteralPath $cp)) { Write-Error "missing chunk $cp" }
    $in = [System.IO.File]::OpenRead($cp)
    $buf = New-Object byte[] 67108864
    while ($true) { $n = $in.Read($buf, 0, $buf.Length); if ($n -le 0) { break }; $fs.Write($buf, 0, $n) }
    $in.Close()
  }
  $fs.Close()
  $h = (Get-FileHash -LiteralPath $out -Algorithm SHA256).Hash.ToLower()
  if ($h -ne $e.sha256.ToLower()) { Write-Error "SHA256 mismatch for $($e.file) expected $($e.sha256) got $h" }
  Write-Host "OK $($e.file)"
}
Write-Host "restore complete"


param(
    [ValidatePattern('^[a-zA-Z0-9.-]+$')][string]$Board = '192.168.1.170',
    [string]$ToolRoot = $(if ($env:ORPHAN_RTLSDR) { $env:ORPHAN_RTLSDR } else { Join-Path $PSScriptRoot 'rtl-sdr' })
)
$ErrorActionPreference = 'Stop'
$exe = Get-ChildItem -LiteralPath $ToolRoot -Recurse -Filter rtl_tcp.exe -File | Select-Object -First 1
if (!$exe) { throw "Osmocom rtl_tcp.exe was not found under $ToolRoot" }
if (Get-NetTCPConnection -State Listen -LocalPort 1234 -ErrorAction SilentlyContinue) {
    throw 'Port 1234 is already in use. The receiver may already be running.'
}
$folder = Join-Path $env:TEMP 'orphan-nesdr'
New-Item -ItemType Directory -Force -Path $folder | Out-Null
$rtl = Start-Process -FilePath $exe.FullName -WindowStyle Hidden -PassThru `
    -ArgumentList '-a','127.0.0.1','-p','1234','-f','92100000','-s','250000','-n','24' `
    -RedirectStandardOutput (Join-Path $folder 'rtl.out') -RedirectStandardError (Join-Path $folder 'rtl.err')
try {
    $ssh = Start-Process -FilePath (Get-Command ssh).Source -WindowStyle Hidden -PassThru `
        -ArgumentList '-NT','-o','BatchMode=yes','-o','ExitOnForwardFailure=yes','-o','ServerAliveInterval=15',
            '-R','127.0.0.1:9123:127.0.0.1:1234',("root@" + $Board) `
        -RedirectStandardOutput (Join-Path $folder 'ssh.out') -RedirectStandardError (Join-Path $folder 'ssh.err')
    Start-Sleep -Seconds 1
    if ($rtl.HasExited -or $ssh.HasExited) { throw "Receiver or SSH tunnel exited. Check $folder" }
    Write-Output "NESDR running (rtl_tcp $($rtl.Id), ssh $($ssh.Id)). Open http://$($Board):8000/"
} catch {
    if (!$rtl.HasExited) { Stop-Process -Id $rtl.Id }
    if ($ssh -and !$ssh.HasExited) { Stop-Process -Id $ssh.Id }
    throw
}

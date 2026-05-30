# Removes generated/imported Dune Awakening server instances.

$ErrorActionPreference = 'Continue'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$logDir = Join-Path $root 'logs'
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$logPath = Join-Path $logDir 'remove-installed-instances.log'

function Write-Log {
    param([string]$Message)
    $line = "[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $Message
    Write-Host $line
    Add-Content -LiteralPath $logPath -Value $line -Encoding UTF8
}

function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

Write-Log 'Starting Dune installed-instance cleanup.'
if (-not (Test-IsAdmin)) {
    Write-Log 'ERROR: This cleanup must run as Administrator.'
    exit 1
}

$vmName = 'dune-awakening'
try {
    $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
    if ($vm) {
        Write-Log "Found Hyper-V VM '$vmName' in state $($vm.State)."
        if ($vm.State -ne 'Off') {
            Write-Log "Stopping VM '$vmName'..."
            Stop-VM -VM $vm -TurnOff -Force -ErrorAction Stop | Out-Null
        }
        Write-Log "Removing Hyper-V VM '$vmName'..."
        Remove-VM -VM $vm -Force -ErrorAction Stop
        Write-Log "Removed Hyper-V VM '$vmName'."
    } else {
        Write-Log "Hyper-V VM '$vmName' was not registered."
    }
} catch {
    Write-Log "ERROR removing VM: $($_.Exception.Message)"
}

$candidatePaths = @()
foreach ($drive in 'C','D','E','F') {
    $candidatePaths += "$drive`:\DuneAwakeningServer"
}

foreach ($path in $candidatePaths) {
    try {
        if (-not (Test-Path -LiteralPath $path)) { continue }

        $resolved = (Resolve-Path -LiteralPath $path).Path
        $leaf = Split-Path -Leaf $resolved
        $parent = Split-Path -Parent $resolved
        if ($leaf -ne 'DuneAwakeningServer' -or -not ($parent -match '^[A-Z]:\\?$')) {
            Write-Log "Skipping unexpected path: $resolved"
            continue
        }

        Write-Log "Removing generated install folder: $resolved"
        Remove-Item -LiteralPath $resolved -Recurse -Force -ErrorAction Stop
        Write-Log "Removed folder: $resolved"
    } catch {
        Write-Log "ERROR removing '$path': $($_.Exception.Message)"
    }
}

$sshDir = Join-Path $env:LOCALAPPDATA 'DuneAwakeningServer'
try {
    if (Test-Path -LiteralPath $sshDir) {
        Write-Log "Removing local generated SSH/settings folder: $sshDir"
        Remove-Item -LiteralPath $sshDir -Recurse -Force -ErrorAction Stop
        Write-Log "Removed local generated SSH/settings folder."
    }
} catch {
    Write-Log "ERROR removing local generated SSH/settings folder: $($_.Exception.Message)"
}

Write-Log 'Cleanup finished.'

. "$($profile | split-path -parent)\Save-Credits.ps1"
. "$($profile | split-path -parent)\Save-RDPFiles.ps1"
. "$($profile | split-path -parent)\Get-LoginNeeded.ps1"
. "$($profile | split-path -parent)\Invoke-Parallel.ps1"

$profilepath = ($profile | Split-Path -Parent)
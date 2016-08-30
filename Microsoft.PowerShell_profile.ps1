. "$($profile | split-path -parent)\Save-Credits.ps1"
. "$($profile | split-path -parent)\Save-RDPFiles.ps1"
. "$($profile | split-path -parent)\Get-LoginNeeded.ps1"
. "$($profile | split-path -parent)\Invoke-Parallel.ps1"

$ProfileGithubURL = 'https://github.com/rodmhgl/PowerShellProfile.git'
$profilepath = ($profile | Split-Path -Parent)
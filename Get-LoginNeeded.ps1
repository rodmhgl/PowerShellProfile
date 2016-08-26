function Get-LoginNeeded () {
    try { 
        Get-AzureRmContext -ErrorAction Stop | Out-Null
        write-output $false
    }
    catch {
        Write-Output $true
    }    
}
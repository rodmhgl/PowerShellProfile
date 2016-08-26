Function Save-RDPFiles { 
    param(
        [Parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        $SubscriptionName = 'Windows Azure  MSDN - Visual Studio Premium',
        [string]$LocalPath = "$([Environment]::GetFolderPath("UserProfile"))\Downloads"
    )

    if (Get-LoginNeeded) {
        try { 
            Login-AzureRmAccount -ErrorAction Stop
            #$AzureRMAccount = Add-AzureRmAccount
        }
        catch { 
            Write-Error -Message "Unable to login - exiting - $($_)"
            Continue
        }  
    }

    Select-AzureRmSubscription -SubscriptionName $SubscriptionName
    
    foreach ($vm in (Get-AzureRMVM -ResourceGroupName $ResourceGroupName)) {
        Get-AzureRmRemoteDesktopFile -ResourceGroupName $ResourceGroupName -Name $vm.name -LocalPath "$LocalPath\$($vm.name).rdp"
    }
}
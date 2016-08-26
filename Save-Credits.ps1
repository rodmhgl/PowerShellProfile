# Inspired by (and mostly stolen from) Darren Robinson's script at 
# https://blog.kloud.com.au/2016/02/10/synchronously-startstop-all-azure-resource-manager-virtual-machines-in-a-resource-group/
# Requires Invoke-Parallel.ps1 - https://github.com/RamblingCookieMonster/Invoke-Parallel
Function Save-Credits { 
    param(
        [ValidateSet('Start','Stop')]
        [Parameter(Mandatory=$true)]
        [string]$power,
        [Parameter(Mandatory=$true)]
        [string]$ResourceGroupName,
        $SubscriptionName = 'Windows Azure  MSDN - Visual Studio Premium'
    )
    
    # see if we already have a session. If we don't don't re-auth
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
    write-host "Enumerating VM's from AzureRM in Resource Group '"$ResourceGroupName "'"
    $vms = Get-AzureRMVM -ResourceGroupName $ResourceGroupName  
    $vmrunninglist = @()
    $vmstoppedlist = @()


    Foreach($vm in $vms) {
        $vmstatus = Get-AzureRMVM -ResourceGroupName $ResourceGroupName -name $vm.name -Status       
        $PowerState = (get-culture).TextInfo.ToTitleCase(($vmstatus.statuses)[1].code.split("/")[1])
          
        write-host "VM: '"$vm.Name"' is" $PowerState
        
        if ($Powerstate -eq 'Running') {
            $vmrunninglist = $vmrunninglist + $vm.name
        }

        if ($Powerstate -eq 'Deallocated') {
            $vmstoppedlist = $vmstoppedlist + $vm.name
        } 
    }

            
    if ($power -eq 'start') {
        write-host "Starting VM's "$vmstoppedlist " in Resource Group "$ResourceGroupName       
        $vmstoppedlist | Invoke-Parallel -ImportVariables -NoCloseOnTimeout -ScriptBlock {
        Start-AzureRMVM -ResourceGroupName $ResourceGroupName -Name $_ -Verbose }
    }
    

    if ($power -eq 'stop') {
        write-host "Stopping VM's "$vmrunninglist " in Resource Group "$ResourceGroupName       
        $vmrunninglist | Invoke-Parallel -ImportVariables -NoCloseOnTimeout -ScriptBlock {
        Stop-AzureRMVM -ResourceGroupName $ResourceGroupName -Name $_ -Verbose -Force }
    }
}
## TODO hard coded variables for now - need to be removed
$rgName = "private_cloud_rg4"

## private cloud variables
$cloudName = "azps_test_cloud"

## get private cloud
$privateCloud = Get-AzVMwarePrivateCloud -ResourceGroupName $rgName -Name $cloudName

##does private cloud exist?
if ($null -eq $privateCloud) {
    Write-Host "Private cloud $cloudName does not exist"
    exit 1
}

if ($null -ne $privateCloud)
{
    do {
        $privateCloud = Get-AzVMwarePrivateCloud -ResourceGroupName $rgName -Name $cloudName
        $provisioningStatus = $privateCloud.provisioningState
        $timestamp = get-date -Format "dd-MM-yyyy - HH:mm:ss"
        switch ($provisioningStatus) {
            "Building" 
            {
                write-host "Provisioning status for $cloudName is : " -NoNewline 
                write-host $provisioningStatus -ForegroundColor Yellow -NoNewline
                write-host " ($timestamp)"
                Start-Sleep -Seconds 300
                ## TODO add time stamp to output
            }
            "Succeeded"
            {
                write-host "Provisioning status for $cloudName is : " -NoNewline 
                write-host $provisioningStatus -ForegroundColor Green -NoNewline
                write-host " ($timestamp)"
                break
            }
            Default
            {
                write-host "Provisioning status for $cloudName is : " -NoNewline 
                write-host $provisioningStatus -ForegroundColor Red -NoNewline
                write-host " ($timestamp)"
                Start-Sleep -Seconds 300
                ## TODO add time stamp to output
            }
        }
    } until (
        $provisioningStatus -ne "Building"
    )
}

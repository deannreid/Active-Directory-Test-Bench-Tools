<# 
  File intended to configure the DC & Network Settings
    IP:	          	10.0.13.37
    NetA:	        10.0.13.0
    IP Range:	    	10.0.13.1 - 10.0.13.254
    BCast:      	10.0.13.255
    Subnet Mask:	255.255.255.0
    DNS:          1.1.1.1
                  8.8.8.8
#>

##
# Variables
##
$cmpName 	    = "TSTDC-01"
$netbiosName 	= "XHTEST"
$domain     	= "xhstcloudtest.com"

$ADSMPasswd   = "Il0v3R34l1yL0ngP@s2W0rD2"

$IPAddr 	    = "10.0.13.37"
$SNetMsk 	    = "255.255.255.0"
$Gtway 		    = "10.0.13.1"
$DNSP 		    = "1.1.1.1"
$DNSS 		    = "8.8.8.8"


#################
# DO NOT CHANGE #
#################
Write-Host "Setting Networking Config"

netsh int ip set address "ethernet" static $IPAddr $SNetMsk $Gtway 1
netsh int ip set dns "ethernet" static $DNSP primary
netsh int ip set dns "ethernet" static $DNSS secondary
Write-Host "Local IP set to $IPAddr"

Write-Host "Setting Computer Name"
Rename-Computer -NewName "$cmpName"
Write-Host "Computer Name set to $cmpName"

Write-Host "Installing Server Manager"
Import-Module ServerManager

Write-Host "Installing Remote Server Admin Tools"
Add-WindowsFeature RSAT-AD-PowerShell,RSAT-AD-AdminCenter

Write-Host "Deploying Active Directory Domain..."
    Install-WindowsFeature AD-domain-services, DNS -IncludeAllSubFeature -IncludeManagementTools
    Import-Module ADDSDeployment
    Install-ADDSForest `
    -SafeModeAdministratorPassword $ADSMPasswd `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "7" `
    -DomainName $domain `
    -DomainNetbiosName $netbiosName `
    -ForestMode "7" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true

Write-Host "Computer Name set to $cmpName"
Write-Host "IP to access the server is: $IPAddr"
Write-Host "Alternatively you can use $cmpName:"

Write-Host "A Restart is Required to complete installation"
$rstrtAnswer = Read-Host -Prompt "Do you want to restart now? (y/n)"
switch ($rstrtAnswer) {
    "y" {
        Restart-Computer -Force -Verbose
    }
    "n" {
        Write-Host "Please restart manually for installation to complete.
    }
    default {
        Write-Host "Invalid Answer, Please restart manually.
    }
}

#Restart-Computer -Force -Verbose

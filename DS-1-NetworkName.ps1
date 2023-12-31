<# 
  File intended to configure the DC Network Settings & Computer name.
    IP:	          	10.0.13.37
    NetA:	        10.0.13.0
    IP Range:	    	10.0.13.1 - 10.0.13.254
    BCast:      	10.0.13.255
    Subnet Mask:	255.255.255.0
    DNS:          1.1.1.1
                  8.8.8.8
#>

#############
# Variables #
#############
$cmpName 	= "TSTDC-01"
$netbiosName 	= "XHTEST"
$domain     	= "xhstcloudtest.com"

$ADSMPasswd   	= "Il0v3R34l1yL0ngP@s2W0rD2"

$IPAddr		= "10.0.13.37"
$SNetMsk 	= "255.255.255.0"
$Gtway 		= "10.0.13.1"
$DNSP 		= "1.1.1.1"
$DNSS 		= "8.8.8.8"


#################
# DO NOT CHANGE #
#################

Write-Host "Setting Networking Config"

netsh int ip set address "ethernet" static $IPAddr $SNetMsk $Gtway 1
netsh int ip set dns "ethernet" static $DNSP primary
netsh int ip set dns "ethernet" static $DNSS secondary
	
Rename-Computer -NewName "$cmpName"

Restart-Computer -Force -Verbose

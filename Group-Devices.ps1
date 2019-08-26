######################################################
##                                                  ##
## INSTALL MODULE - MAKE SURE YOU HAVE ADMIN RIGHTS ##
##                                                  ##
######################################################

Install-Module MsolService

#################################
##                             ##
## CONNECT TO AZURE AD SERVICE ##
##                             ##
#################################

Connect-MsolService

#############################################
##                                         ##
## YOU CAN GET THE OBJECT ID FROM AZURE AD ##
##                                         ##
########################################################
##                                                    ##
## MAKE SURE YOU SET YOUR FILE LOCATION AT THE BOTTOM ##
##                                                    ##
########################################################


$Group = Get-MsolGroupMember -GroupObjectID (Read-Host "Enter ObjectID for the Group") | Select EmailAddress

$list = New-Object System.Collections.Generic.List[string]

foreach ($UPN in $Group)
{
    $list.Add($UPN.EmailAddress.ToString().Trim());
}

$list.sort();

$Object = foreach ($User in $list)
{
    Get-MsolDevice -RegisteredOwnerUpn $User | Select DeviceID
}

$list1 = New-Object System.Collections.Generic.List[string]

foreach ($item in $Object)
{
    $list1.Add($item.DeviceID.ToString().Trim());
}

$list1.sort();

$Get = foreach ($ID in $list1)
{
    Get-MsolDevice -DeviceID $ID | Select DisplayName,DeviceOSType,DeviceOSVersion,RegisteredOwners
}

#########################################
##                                     ##
## EXPORT THE FILE TO DESIRED LOCATION ##
##                                     ##
#########################################

echo $get | Out-File (Read-Host "Where do you want the file to go? ex. c:\bfusa\Groupname.csv")
Import-Module -Name GPWmiFilter
#Create The GPOs!
Write-Output "Creating the 4 GPOs..."
New-GPO -Name "Security Remediations" -Comment "Security Remediations"
New-GPO -Name "Security Remediations - Servers" -Comment "Server Security Remediations - Servers"
New-GPO -Name "Security Remediations - Workstations" -Comment "Workstations Security Remediations"
New-GPO -Name "Security Remediations - Browser Cache" -Comment "Server Browser Cache Cleanup"
#Create the WMI FIlters
Write-Output "Creating the 2 WMI Filters..."
New-GPWmiFilter -Name "Servers" -Server $env:COMPUTERNAME -Expression 'select * from Win32_OperatingSystem where ProductType="2" or ProductType="3"' -Description "Servers"
New-GPWmiFilter -Name "Workstations" -Server $env:COMPUTERNAME -Expression 'Select * from Win32_OperatingSystem WHERE producttype = 1' -Description "Workstations"
#Apply WMI FIlters to 3 GPOs
Write-Output "Apply WMI Filters..."
$wmifilter = Get-GPWmiFilter -Name "Workstations"
Get-GPO -Name "Security Remediations - Workstations" -Server $env:COMPUTERNAME | Set-GPWmiFilterAssignment -Filter "Workstations"
$wmifilter = Get-GPWmiFilter -Name "Servers"
Get-GPO -Name "Security Remediations - Servers" | Set-GPWmiFilterAssignment -Filter "Servers"
$wmifilter = Get-GPWmiFilter -Name "Servers"
Get-GPO -Name "Security Remediations - Browser Cache" | Set-GPWmiFilterAssignment -Filter "Servers"
Write-Output "Linking 3 GPOs..."
#Workstations GPO done manually based on environment
New-GPLink -Name "Security Remediations - Servers" -Target "OU=Domain Controllers,$((Get-ADDomain).DistinguishedName)" -LinkEnabled Yes
New-GPLink -Name "Security Remediations - Browser Cache" -Target "OU=Domain Controllers,$((Get-ADDomain).DistinguishedName)" -LinkEnabled Yes

New-GPLink -Name "Security Remediations" -Target "$((Get-ADDomain).DistinguishedName)" -LinkEnabled Yes

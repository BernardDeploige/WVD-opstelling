# =================================================================
# ARTIFICIALTEST WVD | All powershell commands - NOT AUTOMATED!
# =================================================================
#directory id/Azure AD Tenant ID: 980ceafc-98eb-4d06-9f59-b80f20f85e41
#Azure subscription ID: 1bea3147-ae48-4309-8193-e648ae5f0417

# Setting Deployment context
# -----------------------------------------------------------------
$brokerurl = "https://rdbroker.wvd.microsoft.com"

# Azure AD Tenant ID / Directory ID
$aadTenantId = "980ceafc-98eb-4d06-9f59-b80f20f85e41"

# Azure subscription ID
$azureSubscriptionId = "1bea3147-ae48-4309-8193-e648ae5f0417"

Add-RdsAccount -DeploymentUrl $brokerurl

# Create New Tenant
New-RdsTenant -Name ArtWVDTenant -AadTenantId $aadTenantId -AzureSubscriptionId $azureSubscriptionId

# Add new RDS Owner
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -UserPrincipalName Admin@artificialtest.onmicrosoft.com -TenantGroupName "Default Tenant Group" -TenantName ArtWVDTenant

# Create host pools
New-RdsHostPool -TenantName ArtWVDTenant -name “art-WVD-Host-Pool01"
New-RdsHostPool -TenantName ArtWVDTenant -name “art-WVD-Host-Pool02"

New-RdsAppGroup -TenantName ArtWVDTenant -HostPoolName "art-WVD-Host-Pool01" -AppGroupName “Full Desktop Application Group”
New-RdsAppGroup -TenantName ArtWVDTenant -HostPoolName "art-WVD-Host-Pool02" -AppGroupName “Remote Application Group”

# Certificate commands for VPN connection
# ---------------------------------------

# Root certificate
$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
-Subject "CN=P2SRootCert" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\\CurrentUser\\My" -KeyUsageProperty Sign -KeyUsage CertSign

# Client certificate
New-SelfSignedCertificate -Type Custom -DnsName P2SChildCert -KeySpec Signature `
-Subject "CN=P2SChildCert" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\\CurrentUser\\My" `
-Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")

# Add users when VM is provisioned
# --------------------------------

# Log in with azure credentials
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"

# Verify host pools
Get-RdsSessionHost ArtWVDTenant art-WVD-Host-Pool01
Get-RdsSessionHost ArtWVDTenant art-WVD-Host-Pool02

# Assign users
Add-RdsAppGroupUser -TenantName ArtWVDTenant -HostPoolName art-WVD-Host-Pool01 -AppGroupName “Desktop Application Group” -UserPrincipalName WVDUser1@artificialtest.be
Add-RdsAppGroupUser -TenantName ArtWVDTenant -HostPoolName art-WVD-Host-Pool01 -AppGroupName “Desktop Application Group” -UserPrincipalName WVDUser2@artificialtest.be
Add-RdsAppGroupUser -TenantName ArtWVDTenant -HostPoolName art-WVD-Host-Pool01 -AppGroupName “Desktop Application Group” -UserPrincipalName florentdeploige@artificialtest.be

Add-RdsAppGroupUser -TenantName ArtWVDTenant -HostPoolName art-WVD-Host-Pool02 -AppGroupName “Remote Application Group” -UserPrincipalName WVDUser1@artificialtest.be
Add-RdsAppGroupUser -TenantName ArtWVDTenant -HostPoolName art-WVD-Host-Pool02 -AppGroupName “Remote Application Group” -UserPrincipalName WVDUser3@artificialtest.be
Add-RdsAppGroupUser -TenantName ArtWVDTenant -HostPoolName art-WVD-Host-Pool02 -AppGroupName “Remote Application Group” -UserPrincipalName bernarddeploige@artificialtest.be

# Remove User from app group (if needed)
Remove-RdsAppGroupUser -TenantName ArtWVDTenant -HostPoolName art-WVD-Host-Pool02 -AppGroupName “Remote Application Group” -UserPrincipalName WVDUser3@artificialtest.be

# Publish apps for Remote application group
# -----------------------------------------

Get-RdsStartMenuApp ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group”

# After running the command above, a list of publishable apps will be displayed. Adding apps through PS can be done with following commands:
New-RdsRemoteApp ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group” -Name "Internet Explorer" -AppAlias internetexplorer
New-RdsRemoteApp ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group” -Name "Access" -AppAlias access
New-RdsRemoteApp ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group” -Name "Excel" -AppAlias excel
New-RdsRemoteApp ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group” -Name "OneDrive" -AppAlias onedrive
New-RdsRemoteApp ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group” -Name "Outlook" -AppAlias outlook
New-RdsRemoteApp ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group” -Name "Paint" -AppAlias paint
New-RdsRemoteApp ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group” -Name "PowerPoint" -AppAlias powerpoint
New-RdsRemoteApp ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group” -Name "Remote Desktop Connection" -AppAlias remotedesktopconnection
New-RdsRemoteApp ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group” -Name "Word" -AppAlias word

# Microsoft Edge (Browser)
New-RdsRemoteApp ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group” -Name "Edge" -FilePath "shell:Appsfolder\Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge" -IconPath C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\MicrosoftEdge.exe

# Remove published application from the host pool
Remove-RdsRemoteApp -TenantName ArtWVDTenant art-WVD-Host-Pool02 “Remote Application Group” -Name "Internet Explorer"

# Set custom name for session host in certain hostpool (Session host -> Windows 10 HP1)
Set-RdsRemoteDesktop -TenantName ArtWVDTenant -HostPoolName art-WVD-Host-Pool01 -AppGroupName “Desktop Application Group” -FriendlyName "Windows 10 HP1"



# Diagnostics
# -----------

# Check diagnostics for WVD users.
$TenantName =  'ArtWVDTenant'
## Date in MM/dd/YYYY
Get-RdsDiagnosticActivities `
    -TenantName $TenantName `
    -StartTime 03/10/2020 `
    -EndTime 03/12/2020 `
    | Sort-Object -Property ActivityType, UserName `
    |ft -AutoSize

# Check diagnostics for particular activityID
$TenantName =  'ArtWVDTenant'
Get-RdsDiagnosticActivities `
    -TenantName $TenantName `
    -ActivityId ebd00992-088c-4850-ab75-37b8fd900000
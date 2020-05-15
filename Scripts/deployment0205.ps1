New-RdsAppGroup -TenantName art-WVDTenant -HostPoolName "art-wvd-bap-hostpool" -AppGroupName “Full Desktop Application Group”
New-RdsAppGroup -TenantName art-WVDTenant -HostPoolName "art-wvd-bap-hostpool" -AppGroupName “Remote Application Group”

New-RdsRemoteApp art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "Access" -AppAlias access
New-RdsRemoteApp art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "Excel" -AppAlias excel
New-RdsRemoteApp art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "OneDrive" -AppAlias onedrive
New-RdsRemoteApp art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "Outlook" -AppAlias outlook
New-RdsRemoteApp art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "Paint" -AppAlias paint
New-RdsRemoteApp art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "PowerPoint" -AppAlias powerpoint
New-RdsRemoteApp art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "Word" -AppAlias word

Add-RdsAppGroupUser -TenantName Art-WVDTenant -HostPoolName art-wvd-bap-hostpool -AppGroupName “Desktop Application Group” -UserPrincipalName koenverbeke@artificialtest.be
Add-RdsAppGroupUser -TenantName Art-WVDTenant -HostPoolName art-wvd-bap-hostpool -AppGroupName “Remote Application Group” -UserPrincipalName bernarddeploige@artificialtest.be

Remove-RdsAppGroupUser -TenantName Art-WVDTenant -HostPoolName art-WVD-bap-hostpool -AppGroupName “remote Application Group” -UserPrincipalName bernarddeploige@artificialtest.be
Remove-RdsAppGroupUser -TenantName Art-WVDTenant -HostPoolName art-wvd-bap-hostpool -AppGroupName “remote Application Group” -UserPrincipalName bernarddeploige@artificialtest.be

# GPU DEMO
New-RdsHostPool -TenantName Art-WVDtenant -Name "wvd-demo"
New-RdsAppGroup -TenantName art-WVDTenant -HostPoolName "wvd-demo" -AppGroupName “Full Desktop Application Group”

Get-RdsAppGroup -TenantName art-wvdtenant -HostPoolName "wvd-demo" | Remove-RdsAppGroup
Get-RdsAppGroup -TenantName art-wvdtenant -HostPoolName "wvd-demo" | Remove-RdsSessionHost
Get-RdsAppGroup -TenantName art-wvdtenant -HostPoolName "wvd-demo" | Remove-RdsHostPool


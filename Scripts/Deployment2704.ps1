New-RdsTenant -Name art-WVDTenant -AadTenantId 980ceafc-98eb-4d06-9f59-b80f20f85e41 -AzureSubscriptionId 6ce77760-0029-41c2-98cc-14eb3947820a
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -UserPrincipalName admin@artificialtest.onmicrosoft.com -TenantGroupName "Default Tenant Group" -TenantName art-WVDTenant

# niet gebruikt denk ik vvvvv
New-RdsHostPool -TenantName art-WVDtenant -name “art-wvd-bap-hostpool"

New-RdsAppGroup -TenantName art-WVDtenant -HostPoolName art-wvd-bap-hostpool -AppGroupName “Remote Application Group” -ResourceType RemoteApp

New-RdsRemoteApp Art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "Word" -AppAlias word
New-RdsRemoteApp Art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "Excel" -AppAlias excel
New-RdsRemoteApp Art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "Paint" -AppAlias Paint
New-RdsRemoteApp Art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "PowerPoint" -AppAlias powerpoint
New-RdsRemoteApp Art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "Access" -AppAlias access
New-RdsRemoteApp Art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "Outlook" -AppAlias outlook
New-RdsRemoteApp Art-WVDTenant art-wvd-bap-hostpool “Remote Application Group” -Name "OneDrive" -AppAlias onedrive

Add-RdsAppGroupUser -TenantName Art-WVDTenant -HostPoolName art-WVD-HostPool01 -AppGroupName “Remote Application Group” -UserPrincipalName bernarddeploige@artificialtest.be
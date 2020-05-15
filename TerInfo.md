# Dingen die niet vergeten mogen worden

## ArtificialTest.be

- Azure AD Tenant ID/Directory ID: `980ceafc-98eb-4d06-9f59-b80f20f85e41`
- Azure Subscription ID: `6ce77760-0029-41c2-98cc-14eb3947820a`
- free Azure subscription ID: `1bea3147-ae48-4309-8193-e648ae5f0417`
- WVD Tenant name subscription: `art-WVDTenant` (in powershell script bij stap 2)
- WVD Tenant name free subscription: `ArtWVDTenant` (in powershell script bij stap 2)
- Resource group: `art-wvd-weu` (Artificial-wvd-westeurope)
- DC name: `art-dc1`
- Region: `West europe`
- (VM) Size DC: `Standard B2s (€ 34,47/month)`
- DC admin: `artadmin`
- DC admin password: `job + bedrijf`
- open poorten: `HTTP (80), HTTPS (443), RDP (3389)`
- Virtual Network Name: `art-wvd-weu-vnet`
- Subnet: `default(10.0.0.0/24)`
- public IP: `art-dc1-ip`

- Desktop app VM name: `art-wvd-w10`
- Remote apps VM name: `art-wvd-apps`
- WVD admin: `artadmin`
- DC admin password: `job + bedrijf`
- Region: `West europe`
- (VM) Size Desktop app: `Standard DS1 v2 (€ 41,04/month)`
- (VM) Size Remote apps: `Standard DS1 v2 (€ 41,04/month)`
- WVD admin password: `job + bedrijf`
- Host pool desktop: `art-WVD-Host-Pool01`
- Host pool apps: `art-WVD-Host-Pool02`
- Desktop app VM name: `art-wvd-w10`
- Remote apps VM name: `art-wvd-apps`
- shared folder in DC1: `\\art-dc1\WVDProfile`

Gebruikers in `art-WVD-Host-Pool01` (full desktop):
- wvduser1
- wvduser2
- florent deploige
- bernard deploige

Gebruikers in `art-WVD-Host-Pool02` (remote apps):
- wvduser1
- wvduser3
- bernard deploige

### Diagnostics

- app name: `art-wvd-diag`
- Client Id : `4ccf35c6-be41-4d86-ba5d-9c3c56bf5d40`
- Client Secret Key: `MjdkZTA1NTctMWI3Yi00NDU2LWI4YzctNGM4YmU3ZmQ3ZWE0=`

- Log analytics workspace name: `art-wvd-diag-workspace`
- The Log Analytics workspace Id: `c34665b9-e3e1-4908-95d9-ee793567f5e1`

## Azure AD Sync

Open elevated powershell sessie. Importeer Azure AD Sync module met volgend commando:

```
Import-Module ADSync
```

Om een volledige sync uit te voeren: 

```
Start-ADSyncSyncCycle -PolicyType Initial
```

Om een delta sync uit te voeren:

```
Start-ADSyncSyncCycle -PolicyType Delta
```


## Notities

Connect to azure with powershell using `Connect-AzAccount` command.

### Hostpools

Zie de video van [Azure academy - WVD #2 Management](https://www.youtube.com/watch?v=1q2ecz_mYeA)

- Hostpool heeft een sessielimiet van 999 999 sessies.
- Hostpools kunnen loadbalanced worden. Verkeer voor bepaalde hostpool kan worden verdeelt over verschillende VM's die aangeduid zijn op die hostpool.
- Activiteiten van users worden vooral via PS bekeken

### User profiles

Zie de video van [Azure academy - WVD #3 Management](https://www.youtube.com/watch?v=_aIKvkGNOmE)

User profile management is belangrijk zodat een gebruiker een consistente gebruikservaring heeft. Wanneer de gebruiker aan meldt in WVD, meldt hij/zij zicht aan in een profiel dat van hem/haar is. Dit betekent bvb. Bureaublad naar keuze, bepaalde items op startmenu, enz... Dit is afhankelijk van welke permissies de gebruiker heeft. Uiteraard moet dit profiel ergens opgeslagen worden. Dit kan aan de hand van 3rd party tools. Maar ook via fslogix. Dit werkt aan de hand van profile containers. 

Benodigdheden: 
- DC
- File share server (kan op DC maar is niet best practice)

[Downloadlink FSLogix](https://aka.ms/fslogix_download)

### HA profiles

Zie de video van [Azure academy - WVD #4 HA Profiles](https://www.youtube.com/watch?v=f-gBzo6Mslk)

Niet van toepassing voor onze opstelling. Handig voor internationale bedrijven met werknemers over de hele wereld. 

### WVD Diagnostics

Zie de video van [Azure academy - WVD #9 Diagnostics](https://youtu.be/CSqY0Vtbksk)

Benodigdheden:
- Azure subscription owner
- Permissies om resources aan te maken in Azure
- Permissies om Azure AD apps te maken in Azure
- RDS Owner of Contributer rechten
- Azure Powershell module
- Azure AD Module
- Subscription ID


directory: 5cf7310e-091a-4bc5-acd7-26c721d4cccd

### Log analytics

- eens installed op vm's duurt het tussen 24 en 36 uur tot de volledige date injected is in het sepago monitoring systeem.
- na install duurt het +- 30 minuten voor de data van de dependancy agents tevoorschijn komt in azure

- log in op azure met powershell
- log in op rds met powershell door `Add-RdsAccount DeploymentUrl "https://rdbroker.wvd.microsoft.com"`
```
Set-RDSTenant `
    -Name 'ArtWVDTenant' `
    -LogAnalyticsWorkspaceID '7bbd982e-38f6-45e0-a80c-974ff135a835'`
    -LogAnalyticsPrimaryKey 'SmI39E0esiffmJiPzX6YL6uUf6WNi7hrnvUXdoDt7Uapf3nR89dV/5QHCO+x5HS5Fq/vb/zLFeq8HpZ8Wdwpcw=='
```

# BAP - Demo
hostpool: `art-wvd-bap-hostpool`
vm: `art-wvd-bap`
tenant group: `Default Tenant Group`
tenant name: `art-WVDTenant`
tenant owner: `admin@artificialtest.onmicrosoft.com`

Gebruikers in "Remote Application Group" uit `art-wvd-bap-hostpool`:
- julianmugnes@artificialtest.be

Gebruikers in "Full Desktop Application Group" uit `art-wvd-bap-hostpool`:
- koenverbeke@artificialtest.be


### PS commands:
- Verify hostpools
`Get-RdsSessionHost art-wvdtenant art-wvd-bap-hostpool`

- Verify appgroups in hostpool
`Get-RdsAppGroup -TenantName art-wvdtenant -HostPoolName art-wvd-bap-hostpool`

- Verify Users in appgroup
`Get-RdsAppGroupUser -TenantName art-wvdtenant -HostPoolName art-wvd-bap-hostpool -AppGroupName "Remote Application Group" `

### DEMO INTUNE & WVD

- Toon VM + Foto
- Toon Teamviewer
- Policies: Intune > Device configuration > profiles
- Maak nieuwe policy en toon wat ge kunt doen
- Autopilot: Intune > Device enrolment > Windows Enrollment

- WVD Profile container met FSLogix. Fileserver op DC NIET best practice
- Gepersonaliseerde desktop
- Remote Apps
- Github repository die bijna af is
- 3 lessen gevolgd:
    - March updates for IT Pro's
    - Opleiding WVD door Diego Lens van Ingram Micro
    - SMB Demystify call community call over WVD door cloud champion
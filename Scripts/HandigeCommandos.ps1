# =================================================================
#       ARTIFICIALTEST WVD | Handige Powershell commando's
# =================================================================

# Aanmelden op Azure account
Connect-AzAccount

# Log in op Azure AD (met zelfde credentials als hierboven)
Connect-AzureAD

# Check VM usage van uw subscription per locatie
Get-AzVMUsage -Location "westeurope"

# Bekijk resources in huidige resource group
Get-AzResourceGroup

Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"

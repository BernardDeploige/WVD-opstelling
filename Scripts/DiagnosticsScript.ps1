# =================================================================
#            ARTIFICIALTEST WVD | Diagnostics script
# =================================================================


# *****************************************************************
# *           Variables | Change variables appropriately          *
# *****************************************************************

# Tenant name
$TenantName =  'ArtWVDTenant'

# Start date in MM/dd/YYYY
$StartTime = "03/10/2020"

# End date in MM/dd/YYYY
$EndTime = "03/12/2020"

# Activity ID
 $ActivityId = "6e8c9b79-0a63-40e1-bef4-9244e5fa0100"

# *****************************************************************
# *              Diagnostics script | DO NOT CHANGE               *
# *****************************************************************

# Check activity table
# -----------------------------------------------------------------

Get-RdsDiagnosticActivities `
    -TenantName $TenantName `
    -StartTime $StartTime `
    -EndTime $EndTime `
    | Sort-Object -Property ActivityType, UserName `
    |ft -AutoSize

# Check diagnostics for particular activityID
# -----------------------------------------------------------------
Get-RdsDiagnosticActivities `
    -TenantName $TenantName `
    -ActivityId $ActivityId
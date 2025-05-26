#######################################################################################################
#                                                                                                     #
# Use this script at your own risk.                                                                   #
# Read, test and understand all of the code using a test account before putting it into production    #
#                                                                                                     #
# Creates Rentetion Policies for online archiving and enables online archiving for all Mailboxes      #
#                                                                                                     #
#######################################################################################################
#
#
#
# Initiliase module ###############################################
if ((Get-Module "ExchangeOnlineManagement")) {
    # module is not loaded
    Write-Host "Installing ExchagneOnlineManagement Module"
    Install-Module -Name ExchangeOnlineManagement
}
Import-Module ExchangeOnlineManagement
#
#Connect to 365 Compliance Center
Connect-IPPSSession
#
Write-Host ""
Write-Host "CREATING COMPLIANCE POLICIES" -ForegroundColor Red
Write-Host ""
Write-Host "#########################################" -ForegroundColor Gray
Write-Host ""
#
#Get Customer Name, Domain names, and users/UPNs
$CustName = Read-Host "Please enter the Customer Name"
# Create the Exchange Only Retention Policy
New-RetentionPolicyTag "Default 3 year move to archive" -Type All -RetentionEnabled $true -AgeLimitForRetention 365 -RetentionAction MoveToArchive
New-RetentionPolicyTag "Junk Email" -Type JunkEmail -RetentionEnabled $true -AgeLimitForRetention 30 -RetentionAction Delete
New-RetentionPolicyTag "Personal Never Delete" -Type Personal -RetentionEnabled $true -AgeLimitForRetention 30 -RetentionAction Delete

New-RetentionPolicy "Default $CustName Retention Policy" -RetentionPolicyTagLinks "Default 3 year move to archive","Junk Email", "Personal Never Delete"

# Force Archive Job
Start-ManagedFolderAssistant -Identity user@example.com
#######################################################################################################
#                                                                                                     #
# Use this script at your own risk.                                                                   #
# Read, test and understand all of the code using a test account before putting it into production    #
#                                                                                                     #
# Creates ATP Policies                                                                                #
#                                                                                                     #
#######################################################################################################
#
#Available Policies:
#Anti Phishing
#Safe Attachments
#Safe Links
#Anti Spam
#Anti Malware
#
# Initiliase module ###############################################
if ((Get-Module "ExchangeOnlineManagement")) {
    # module is not loaded
    Write-Host "Installing ExchagneOnlineManagement Module"
    Install-Module -Name ExchangeOnlineManagement
}
Import-Module ExchangeOnlineManagement
#
#Connect to 365 exchange online
Connect-ExchangeOnline
#
#Get Customer Name, Domain names, and users/UPNs
$CustName = Read-Host "Please enter the Customer Name eg. Stasmayer"
$domains = (Get-AcceptedDomain).DomainName
$Users= foreach($Mailbox in $(get-mailbox)){'"'+$Mailbox.DisplayName+';'+$Mailbox.UserPrincipalName+'"'}
$UserList = $Users -join ","
#
Clear-Host
#
Write-Host ""
Write-Host "CREATING THREAT PROTECTION POLICIES" -ForegroundColor Red
Write-Host ""
Write-Host "#########################################" -ForegroundColor Gray
Write-Host ""
#
#Enable org customization
Write-Host "Checking if ATP is enabled for the Tenant" -ForegroundColor Yellow
$isDehydrated = $(Get-OrganizationConfig).IsDehydrated
#
if($isDehydrated -eq $true)
{
    Write-Host "Turning on ATP" -ForegroundColor Yellow
    Enable-OrganizationCustomization
    Write-Host "Waiting 60 seconds for replication " -ForegroundColor Green
    Start-Sleep -seconds 60
}
Write-Host "Done" -ForegroundColor Green
#
#Enable auditing
Write-Host "Enabling Audit Logs" -ForegroundColor Yellow
$auditLogConfig = Get-AdminAuditLogConfig 
#
if($auditLogConfig.AdminAuditLogEnabled -eq $false)
{
    Set-AdminAuditLogConfig -AdminAuditLogEnabled $true
}
#
if($auditLogConfig.UnifiedAuditLogIngestionEnabled -eq $false)
{
    Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true
}
Write-Host "Done" -ForegroundColor Green
#
# Configure Quarantine Policy
Write-Host "Creating Quarantine Policy" -ForegroundColor Yellow
$result = New-QuarantinePolicy -Name "Default $CustName Quarantine Policy" -EndUserQuarantinePermissionsValue 23 -ESNEnabled $true
Write-Host "Done" -ForegroundColor Green
#
# Configure Anti-Phishing
Write-Host "Creating Anti Phishing Policy" -ForegroundColor Yellow
$result = New-AntiPhishPolicy -Name "Default $CustName Anti-Phishing Policy" -AuthenticationFailAction Quarantine -Enabled $true -EnableFirstContactSafetyTips $true -EnableMailboxIntelligence $true -EnableMailboxIntelligenceProtection $true -EnableOrganizationDomainsProtection $true -EnableSimilarDomainsSafetyTips $true -EnableSimilarUsersSafetyTips $true -EnableSpoofIntelligence $true -EnableTargetedDomainsProtection $true -EnableTargetedUserProtection $true -EnableUnauthenticatedSender $true -EnableUnusualCharactersSafetyTips $true -ImpersonationProtectionState Automatic -MailboxIntelligenceProtectionAction Quarantine -MailboxIntelligenceQuarantineTag "Default $CustName Quarantine Policy" -PhishThresholdLevel 1 -SpoofQuarantineTag "Default $CustName Quarantine Policy" -TargetedDomainProtectionAction Quarantine -TargetedDomainQuarantineTag "Default $CustName Quarantine Policy" -TargetedDomainsToProtect $domains -TargetedUserProtectionAction Quarantine -TargetedUserQuarantineTag "Default $CustName Quarantine Policy" 
$result = New-AntiPhishRule -Name "Default $CustName Anti-Phishing Rule" -AntiPhishPolicy "Default $CustName Anti-Phishing Policy" -Enabled $false -Priority 0 -RecipientDomainIs $domains
Write-Host "Done" -ForegroundColor Green
#
# Configure Safe Links
Write-Host "Creating Safe Links Policy" -ForegroundColor Yellow
$result = New-SafeLinksPolicy -Name "Default $CustName Safe Links Policy" -DeliverMessageAfterScan $true -DisableUrlRewrite $false -AllowClickThrough $false -DoNotRewriteUrls $true -TrackClicks $false -EnableForInternalSenders $true -EnableSafeLinksForTeams $true -ScanUrls $true
$result = New-SafeLinksRule -Name "Default $CustName Safe Links Rule" -SafeLinksPolicy "Default $CustName Safe Links Policy" -Enabled $false -Priority 0 -RecipientDomainIs $domains
Write-Host "Done" -ForegroundColor Green
#
# Configure Safe Attachments 
Write-Host "Creating Safe Attachments Policy" -ForegroundColor Yellow
$result = New-SafeAttachmentPolicy -Name "Default $CustName Safe Attachment Policy" -Enable $true -Action Replace -ActionOnError $true
$result = New-SafeAttachmentRule -Name "Default $CustName Safe Attachment Rule" -SafeAttachmentPolicy "Default $CustName Safe Attachment Policy" -Enabled $false -Priority 0 -RecipientDomainIs $domains
Write-Host "Done" -ForegroundColor Green
#
# Configure Anti Spam 
Write-Host "Creating Anti Spam Policy" -ForegroundColor Yellow
$result = New-HostedContentFilterPolicy -Name "Default $CustName Spam Policy" -EnableRegionBlockList $true -HighConfidencePhishAction Quarantine -HighConfidencePhishQuarantineTag "Default $CustName Quarantine Policy" -HighConfidenceSpamAction Quarantine -HighConfidenceSpamQuarantineTag "Default $CustName Quarantine Policy" -IncreaseScoreWithBizOrInfoUrls On -IncreaseScoreWithImageLinks On -IncreaseScoreWithNumericIps On -IncreaseScoreWithRedirectToOtherPort On -MarkAsSpamBulkMail On -MarkAsSpamEmbedTagsInHtml On -MarkAsSpamEmptyMessages On -MarkAsSpamFormTagsInHtml On -MarkAsSpamFramesInHtml On -MarkAsSpamFromAddressAuthFail On -MarkAsSpamJavaScriptInHtml On -MarkAsSpamNdrBackscatter On -MarkAsSpamSensitiveWordList On -PhishQuarantineTag "Default $CustName Quarantine Policy" -PhishSpamAction Quarantine -PhishZapEnabled $false -QuarantineRetentionPeriod 30 -RegionBlockList AF,AL,DZ,AO,AM,AZ,BH,BY,BR,CF,TD,CN,CO,CG,DO,CU,DJ,EG,EE,GE,HK,JO,KE,KG,LV,LR,ET,HT,IR,KZ,KW,LA,LB,IQ,LY,MO,NI,MM,NG,NE,KP,OM,PK,PS,PH,QA,RW,RU,SA,SK,SO,RS,SI,ZA,SZ,SY,TJ,TN,TR,TM,UA,AE,UZ,VE,VN -SpamAction Quarantine -SpamQuarantineTag "Default $CustName Quarantine Policy" -SpamZapEnabled $false
$result = New-HostedContentFilterRule -Name "Default $CustName Spam Rule" -HostedContentFilterPolicy "Default $CustName Spam Policy" -Priority 0 -Enabled $false -RecipientDomainIs $domains
Write-Host "Done" -ForegroundColor Green
#
Write-Host "#########################################" -ForegroundColor Gray
#
Write-Host "Polices Created" -ForegroundColor Red
Write-Host "*****You will need to confirm and turn them on*****" -ForegroundColor Red
#
Write-Host "Follow directions below to add all users to Impersonation protection" -ForegroundColor Yellow
Write-Host "Copy and paste the following:" -ForegroundColor Red
Write-Host ""
Write-Host "Connect-ExchangeOnline"
Write-Host '$CustName='"`"$CustName`""
Write-Host "Set-AntiPhishPolicy -Identity `"Default $CustName Anti-Phishing Policy`" -TargetedUsersToProtect $Userlist"


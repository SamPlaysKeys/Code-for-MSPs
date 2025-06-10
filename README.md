# Code for MSPs

A collection of PowerShell scripts and utilities designed for Managed Service Providers (MSPs) to automate and streamline IT administration tasks for Windows environments, Microsoft 365, and Azure.
This has been re-uploaded due to consistency issues with the original repository.

## Repository Overview

This repository contains scripts for automating common MSP tasks including:

- Azure AD and Microsoft 365 management
- Windows system administration and configuration
- User management and provisioning
- Network configuration and management
- Security and compliance automation
- System maintenance and monitoring
- Windows deployment automation

## Script Categories

### Azure and Microsoft 365

- `Azure AD Migration Prep.ps1` - Prepares an environment for Azure AD migration
- `Azure AD Sync Prep.ps1` - Sets up Azure AD Connect sync prerequisites
- `Azure Users to CSV.ps1` - Exports Azure AD users to CSV format
- `AutopilotPush.ps1` - Automates Windows Autopilot deployment
- `O365 hardmatch.ps1` - Forces a hard match between on-premises and cloud identities
- `OnlineArchive.ps1` - Manages Exchange Online archiving
- `ATPPolicies.ps1` - Configures Advanced Threat Protection policies
- `PullScriptsIntune.ps1` - Extracts scripts from Microsoft Intune
- `list-powered-off-Azure-vms.ps1` - Lists Azure VMs that are currently powered off
- `upgrade-vm-disks.ps1` - Upgrades Azure VM disk configurations

### Intune Management

- `Intune - Block IPv6 Router Discovery/` - Folder containing Intune compliance scripts for IPv6 router discovery management
  - `Detection-IPv6RouterDiscovery.ps1` - Detection script to check IPv6 router discovery settings
  - `Remediation-IPv6RouterDiscovery.ps1` - Remediation script to disable IPv6 router discovery

### System Administration

- `Get-WindowsKey.ps1` / `GetWindowsKey2012R2.ps1` - Retrieves Windows license keys
- `BitlockerChecking.ps1` - Checks BitLocker status on drives
- `CheckDriveSize.ps1` - Reports drive space usage
- `PowerOptions.ps1` / `PowerSleepSettings.ps1` / `SetPowerPlanOptions.ps1` - Manages power settings
- `Win11_Upgrade.ps1` - Assists with Windows 11 upgrades
- `Syncro_Teams_Killer.ps1` - Terminates Teams processes
- `dellremoval.ps1` - Removes Dell bloatware
- `ipv6disable.ps1` - Disables IPv6 networking
- `MoveRecoveryPartition.sh` - Shell script for managing recovery partitions
- `CheckVersion.ps1` - Checks software version information
- `adminprompt.ps1` - Elevates PowerShell to admin privileges
- `ComputerName.ps1` - Gets or sets computer names
- `CreateFIleDesktop.ps1` - Creates files on desktop

### User Management

- `CreateAdminUser.ps1` - Creates local administrator accounts
- `Create user profile.ps1` - Sets up user profiles
- `ProfileDataMigration.ps1` - Migrates user profile data
- `PasswordGenerate.ps1` / `PasswordGenerator.ps1` - Generates secure passwords
- `Get login info.ps1` - Retrieves user login information

### Network Configuration

- `Add-MappedDrive.ps1` - Creates mapped network drives
- `DNSSettings.ps1` / `SetDNS.bat` - Configures DNS settings
- `Add-Printer.ps1` / `Remove Printers.ps1` / `printers.ps1` / `print.spooler.admin.ps1` - Manages printer installations
- `iplocation.ps1` - Determines geographic location from IP addresses
- `L2tp Search.ps1` - Searches for L2TP VPN connections

### Utilities and UI

- `SimpleUIPopup.ps1` / `SimpleUIQuery.ps1` - Creates simple UI dialogs
- `DownloadFile.ps1` - Downloads files from URLs
- `Speaking.ps1` - Text-to-speech utilities
- `PowershellGuiShortcuts.txt` - Reference for PowerShell GUI shortcuts
- `MakeSounds.ps1` - Generates system sounds
- `XMLPWSH.Testing.ps1` - Tests XML processing in PowerShell
- `Install and Uninstall Extensions.ps1` - Manages browser extensions
- `DomotzSyncroSilentInstaller.ps1` - Silent installer for Domotz and Syncro RMM tools
- `Cheese w options and taskkill.ps1` - Example of process management

## Setup and Usage

Most scripts are designed to be standalone and can be executed directly in PowerShell. To use this repository:

1. Clone the repository or download individual scripts as needed
2. Review the script content before execution to understand its purpose and parameters
3. Run scripts with appropriate parameters and privileges

Example:

```powershell
# Example usage
.\ScriptName.ps1 -Parameter1 Value1 -Parameter2 Value2
```

## Line Ending Configuration

This repository is configured to handle line endings appropriately for different operating systems:

- PowerShell scripts (.ps1) use CRLF (Windows-style) line endings
- Shell scripts (.sh) use LF (Unix-style) line endings
- Text files use LF line endings

The configuration is managed via the `.gitattributes` file to ensure consistency across platforms.

## Security

When working with these scripts, follow these security best practices:

- Review all script content before execution
- Never run scripts in production environments without prior testing
- Ensure proper authentication and authorization when scripts access sensitive resources
- Store credentials securely and never hardcode them in scripts
- Use the principle of least privilege when configuring accounts used by these scripts

### Credential Handling

When scripts require credentials:

1. **Never hardcode credentials** in scripts or commit them to source control
2. **Use secure credential storage**:
   - Azure Key Vault for cloud applications
   - Windows Credential Manager for local scripts
   - PowerShell's `Get-Credential` cmdlet for interactive use
3. **Implement credential encryption**:
   ```powershell
   # Securely save credentials to file
   Get-Credential | Export-CliXml -Path ".\credentials.xml"
   
   # Import credentials (can only be decrypted by same user on same computer)
   $Credential = Import-CliXml -Path ".\credentials.xml"
   ```
4. **Use least-privilege service accounts** instead of administrative accounts whenever possible
5. **Audit credential usage** to detect unauthorized access

## License

This repository is available under the [MIT License](LICENSE).


## Disclaimer

These scripts are provided as-is with no warranty. Always test scripts in a non-production environment before deploying to production systems.

# Create .intunewin package file
$IntuneWin32Package = New-IntuneWin32AppPackage -SourceFolder ($PSScriptRoot + "\Source\VCRedist") -SetupFile "Install-VCRedist.ps1" -OutputFolder ($PSScriptRoot + "\Output")

# Get MSI meta data from .intunewin file
#$IntuneWinMetaData = Get-IntuneWin32AppMetaData -FilePath $IntuneWin32Package.Path

# Create custom display name like 'Name' and 'Version'
$Version = "2008-2022"
$DisplayName = "Visual C++ Redistributables" + " " + $Version

# Create detection rule
$ScriptFile = $PSScriptRoot + "\Detection\Get-VCRedistDetection.ps1"
$DetectionRule = New-IntuneWin32AppDetectionRuleScript -ScriptFile $ScriptFile -EnforceSignatureCheck $false -RunAs32Bit $false

# Create custom requirement rule
$RequirementRule = New-IntuneWin32AppRequirementRule -Architecture "All" -MinimumSupportedOperatingSystem 1607

# Convert image file to icon
$ImageFile = $PSScriptRoot + "\Icons\VisualC.png"
$Icon = New-IntuneWin32AppIcon -FilePath $ImageFile

# Add new EXE Win32 app
$Win32AppArgs = @{
    "FilePath"             = $IntuneWin32Package.Path
    "DisplayName"          = $DisplayName
    "Description"          = "Install Visual C++ Redistributables."
    "Publisher"            = "Microsoft"
    "InstallExperience"    = "system"
    "RestartBehavior"      = "suppress"
    "DetectionRule"        = $DetectionRule
    "RequirementRule"      = $RequirementRule
    "InstallCommandLine"   = "powershell.exe -ExecutionPolicy Bypass -File .\Install-VCRedist.ps1"
    "UninstallCommandLine" = "cmd.exe /c"
    "Icon"                 = $Icon
}
Add-IntuneWin32App @Win32AppArgs
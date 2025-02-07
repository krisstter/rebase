param(
    [Parameter(Mandatory = $true)]
    [string]$SiteName,

    [Parameter(Mandatory = $true)]
    [string]$SitePhysicalPath,

    [Parameter(Mandatory = $true)]
    [string]$BindingInformation,

    [Parameter(Mandatory = $false)]
    [string]$User,

    [Parameter(Mandatory = $false)]
    [string]$Password,

    [Parameter(Mandatory = $false)]
    [string]$VirtualDirName,

    [Parameter(Mandatory = $false)]
    [ValidateSet("Integrated", "Classic")]  # Ensures only valid values
    [string]$PipelineMode = "Integrated"    # Default to Integrated
)

# Path to appcmd.exe
$appcmd = "$env:SystemRoot\system32\inetsrv\appcmd.exe"

# Define the app pool name
$appPoolName = "$SiteName"

# Ensure the application pool exists
Write-Host "Ensuring application pool '$appPoolName' exists..."
& $appcmd add apppool /name:"$appPoolName" 2>$null  # Ignore errors if already exists

# Set Managed Pipeline Mode (Integrated or Classic)
Write-Host "Setting application pool '$appPoolName' to use '$PipelineMode' mode."
& $appcmd set apppool /apppool.name:"$appPoolName" /managedPipelineMode:$PipelineMode

# Configure Application Pool Identity
if (-not [string]::IsNullOrEmpty($User) -and -not [string]::IsNullOrEmpty($Password)) {
    Write-Host "Using specific user for app pool '$appPoolName'"
    & $appcmd set apppool /apppool.name:"$appPoolName" /processModel.identityType:"SpecificUser" /processModel.userName:"$User" /processModel.password:"$Password"
} else {
    Write-Host "No user credentials provided. Using ApplicationPoolIdentity."
    & $appcmd set apppool /apppool.name:"$appPoolName" /processModel.identityType:"ApplicationPoolIdentity"
}

# Restart IIS
Write-Host "Restarting IIS..."
iisreset

<#
.SYNOPSIS
    Displays comprehensive system information using PowerShell.

.DESCRIPTION
    This script demonstrates how to gather system information using various PowerShell cmdlets.
    It showcases working with objects, properties, and formatting output.

.PARAMETER Detailed
    Shows additional detailed information including hardware details.

.PARAMETER ExportPath
    If specified, exports the information to a CSV file at the given path.

.PARAMETER ShowServices
    Includes running services information in the output.

.EXAMPLE
    .\system-info.ps1
    
    Displays basic system information

.EXAMPLE
    .\system-info.ps1 -Detailed -ShowServices
    
    Displays detailed system information including services

.EXAMPLE
    .\system-info.ps1 -ExportPath "C:\Reports\system-info.csv"
    
    Exports system information to a CSV file

.NOTES
    File Name      : system-info.ps1
    Author         : PowerShell Learning Guide
    Prerequisite   : PowerShell 5.1 or later
    
    This script demonstrates:
    - System information gathering
    - Object property access
    - Conditional logic
    - Data export functionality
    - Error handling
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$Detailed,
    
    [Parameter(Mandatory = $false)]
    [ValidateScript({ 
        $folder = Split-Path $_
        if ($folder -and !(Test-Path $folder)) {
            throw "Directory '$folder' does not exist"
        }
        $true
    })]
    [string]$ExportPath,
    
    [Parameter(Mandatory = $false)]
    [switch]$ShowServices
)

function Get-SystemInformation {
    param(
        [bool]$IncludeDetailed,
        [bool]$IncludeServices
    )
    
    Write-Host "Gathering System Information..." -ForegroundColor Yellow
    
    # Basic system information
    $computerInfo = Get-ComputerInfo
    $osInfo = Get-WmiObject -Class Win32_OperatingSystem
    $computerSystem = Get-WmiObject -Class Win32_ComputerSystem
    
    # Create system info object
    $systemInfo = [PSCustomObject]@{
        ComputerName = $env:COMPUTERNAME
        OperatingSystem = $computerInfo.WindowsProductName
        Version = $computerInfo.WindowsVersion
        BuildNumber = $computerInfo.WindowsBuildLabEx
        Architecture = $computerInfo.OsArchitecture
        TotalMemoryGB = [Math]::Round($computerInfo.TotalPhysicalMemory / 1GB, 2)
        FreeMemoryGB = [Math]::Round($osInfo.FreePhysicalMemory / 1MB / 1024, 2)
        Processor = $computerSystem.Model
        Domain = $computerSystem.Domain
        LastBootTime = $osInfo.ConvertToDateTime($osInfo.LastBootUpTime)
        Uptime = (Get-Date) - $osInfo.ConvertToDateTime($osInfo.LastBootUpTime)
        PowerShellVersion = $PSVersionTable.PSVersion.ToString()
        TimeZone = (Get-TimeZone).DisplayName
        CurrentUser = $env:USERNAME
    }
    
    # Display basic information
    Write-Host "`n=== BASIC SYSTEM INFORMATION ===" -ForegroundColor Cyan
    Write-Host "Computer Name    : $($systemInfo.ComputerName)" -ForegroundColor Green
    Write-Host "Operating System : $($systemInfo.OperatingSystem)" -ForegroundColor Green
    Write-Host "Version          : $($systemInfo.Version)" -ForegroundColor Green
    Write-Host "Architecture     : $($systemInfo.Architecture)" -ForegroundColor Green
    Write-Host "Total Memory     : $($systemInfo.TotalMemoryGB) GB" -ForegroundColor Green
    Write-Host "Free Memory      : $($systemInfo.FreeMemoryGB) GB" -ForegroundColor Green
    Write-Host "Processor        : $($systemInfo.Processor)" -ForegroundColor Green
    Write-Host "Last Boot Time   : $($systemInfo.LastBootTime)" -ForegroundColor Green
    Write-Host "Uptime           : $($systemInfo.Uptime.Days) days, $($systemInfo.Uptime.Hours) hours" -ForegroundColor Green
    Write-Host "PowerShell Ver   : $($systemInfo.PowerShellVersion)" -ForegroundColor Green
    Write-Host "Current User     : $($systemInfo.CurrentUser)" -ForegroundColor Green
    
    if ($IncludeDetailed) {
        Write-Host "`n=== DETAILED INFORMATION ===" -ForegroundColor Cyan
        
        # Disk information
        Write-Host "`n--- Disk Information ---" -ForegroundColor Yellow
        Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
            $freePercent = [Math]::Round(($_.FreeSpace / $_.Size) * 100, 1)
            Write-Host "Drive $($_.DeviceID) - Size: $([Math]::Round($_.Size / 1GB, 1)) GB, Free: $([Math]::Round($_.FreeSpace / 1GB, 1)) GB ($freePercent%)" -ForegroundColor White
        }
        
        # Network adapters
        Write-Host "`n--- Network Adapters ---" -ForegroundColor Yellow
        Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled } | ForEach-Object {
            Write-Host "Adapter: $($_.Description)" -ForegroundColor White
            Write-Host "  IP Address: $($_.IPAddress[0])" -ForegroundColor Gray
            Write-Host "  Subnet Mask: $($_.IPSubnet[0])" -ForegroundColor Gray
            if ($_.DefaultIPGateway) {
                Write-Host "  Gateway: $($_.DefaultIPGateway[0])" -ForegroundColor Gray
            }
        }
        
        # CPU information
        Write-Host "`n--- Processor Information ---" -ForegroundColor Yellow
        Get-WmiObject -Class Win32_Processor | ForEach-Object {
            Write-Host "Processor: $($_.Name)" -ForegroundColor White
            Write-Host "  Cores: $($_.NumberOfCores)" -ForegroundColor Gray
            Write-Host "  Logical Processors: $($_.NumberOfLogicalProcessors)" -ForegroundColor Gray
            Write-Host "  Max Clock Speed: $($_.MaxClockSpeed) MHz" -ForegroundColor Gray
        }
    }
    
    if ($IncludeServices) {
        Write-Host "`n=== RUNNING SERVICES ===" -ForegroundColor Cyan
        $runningServices = Get-Service | Where-Object { $_.Status -eq "Running" } | Sort-Object DisplayName
        Write-Host "Total Running Services: $($runningServices.Count)" -ForegroundColor Yellow
        
        $runningServices | Select-Object -First 10 | ForEach-Object {
            Write-Host "  $($_.DisplayName) ($($_.Name))" -ForegroundColor White
        }
        
        if ($runningServices.Count -gt 10) {
            Write-Host "  ... and $($runningServices.Count - 10) more services" -ForegroundColor Gray
        }
    }
    
    return $systemInfo
}

# Main script execution
try {
    $systemData = Get-SystemInformation -IncludeDetailed $Detailed -IncludeServices $ShowServices
    
    # Export to CSV if requested
    if ($ExportPath) {
        Write-Host "`nExporting system information to: $ExportPath" -ForegroundColor Yellow
        $systemData | Export-Csv -Path $ExportPath -NoTypeInformation -Force
        Write-Host "Export completed successfully!" -ForegroundColor Green
    }
    
    # Performance counters example
    if ($Detailed) {
        Write-Host "`n=== PERFORMANCE COUNTERS ===" -ForegroundColor Cyan
        $cpuUsage = Get-Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 3
        $avgCpu = ($cpuUsage.CounterSamples | Measure-Object -Property CookedValue -Average).Average
        Write-Host "Average CPU Usage: $([Math]::Round($avgCpu, 1))%" -ForegroundColor White
    }
    
    Write-Host "`nSystem information gathering completed!" -ForegroundColor Cyan
    
} catch {
    Write-Error "Error gathering system information: $($_.Exception.Message)"
    exit 1
} 
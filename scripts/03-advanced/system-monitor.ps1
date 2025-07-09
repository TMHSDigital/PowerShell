<#
.SYNOPSIS
    Advanced system monitoring script with alerting and reporting capabilities.

.DESCRIPTION
    This script demonstrates advanced PowerShell concepts including:
    - Performance counter monitoring
    - Real-time alerting
    - HTML report generation
    - Email notifications
    - Background monitoring
    - Configuration management

.PARAMETER ConfigPath
    Path to JSON configuration file. If not specified, uses default settings.

.PARAMETER MonitorDuration
    How long to monitor in minutes. Default is 60 minutes.

.PARAMETER ReportPath
    Where to save the HTML report. Default is current directory.

.PARAMETER EmailAlert
    Send email alerts when thresholds are exceeded.

.PARAMETER ContinuousMode
    Run in continuous monitoring mode until stopped.

.PARAMETER Quiet
    Suppress console output (useful for scheduled tasks).

.EXAMPLE
    .\system-monitor.ps1 -MonitorDuration 30 -ReportPath "C:\Reports"
    
    Monitor system for 30 minutes and save report to C:\Reports

.EXAMPLE
    .\system-monitor.ps1 -ContinuousMode -EmailAlert -Quiet
    
    Run continuous monitoring with email alerts in quiet mode

.NOTES
    File Name      : system-monitor.ps1
    Author         : PowerShell Learning Guide
    Prerequisite   : PowerShell 5.1 or later, Run as Administrator
    
    This script demonstrates:
    - Advanced parameter handling
    - Configuration management with JSON
    - Performance counter monitoring
    - HTML report generation
    - Email functionality
    - Background jobs
    - Real-time data processing
    - Exception handling patterns
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$ConfigPath,
    
    [Parameter(Mandatory = $false)]
    [ValidateRange(1, 1440)]
    [int]$MonitorDuration = 60,
    
    [Parameter(Mandatory = $false)]
    [string]$ReportPath = (Get-Location).Path,
    
    [Parameter(Mandatory = $false)]
    [switch]$EmailAlert,
    
    [Parameter(Mandatory = $false)]
    [switch]$ContinuousMode,
    
    [Parameter(Mandatory = $false)]
    [switch]$Quiet
)

# Default configuration
$defaultConfig = @{
    Thresholds = @{
        CPUPercent = 80
        MemoryPercent = 85
        DiskSpacePercent = 90
        DiskQueueLength = 10
    }
    Email = @{
        SMTPServer = "smtp.gmail.com"
        Port = 587
        UseSSL = $true
        From = "monitor@company.com"
        To = @("admin@company.com")
        Subject = "System Alert - {0}"
    }
    Counters = @(
        "\Processor(_Total)\% Processor Time",
        "\Memory\% Committed Bytes In Use",
        "\PhysicalDisk(_Total)\Current Disk Queue Length",
        "\Network Interface(*)\Bytes Total/sec"
    )
    SampleInterval = 5
    AlertCooldown = 300
}

# Global variables
$script:config = $null
$script:alertLog = @{}
$script:monitoringData = @()
$script:isRunning = $false

function Write-MonitorLog {
    param(
        [string]$Message,
        [ValidateSet("Info", "Warning", "Error", "Success", "Alert")]
        [string]$Level = "Info",
        [switch]$Force
    )
    
    if ($Quiet -and !$Force) { return }
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "Info" { "White" }
        "Warning" { "Yellow" }
        "Error" { "Red" }
        "Success" { "Green" }
        "Alert" { "Magenta" }
    }
    
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Initialize-Configuration {
    param([string]$ConfigFile)
    
    if ($ConfigFile -and (Test-Path $ConfigFile)) {
        try {
            $customConfig = Get-Content $ConfigFile | ConvertFrom-Json -AsHashtable
            $script:config = Merge-Hashtables $defaultConfig $customConfig
            Write-MonitorLog "Loaded configuration from: $ConfigFile" -Level "Success"
        } catch {
            Write-MonitorLog "Failed to load config file, using defaults: $($_.Exception.Message)" -Level "Warning"
            $script:config = $defaultConfig
        }
    } else {
        $script:config = $defaultConfig
        Write-MonitorLog "Using default configuration" -Level "Info"
    }
}

function Merge-Hashtables {
    param(
        [hashtable]$Default,
        [hashtable]$Custom
    )
    
    $merged = $Default.Clone()
    foreach ($key in $Custom.Keys) {
        if ($merged[$key] -is [hashtable] -and $Custom[$key] -is [hashtable]) {
            $merged[$key] = Merge-Hashtables $merged[$key] $Custom[$key]
        } else {
            $merged[$key] = $Custom[$key]
        }
    }
    return $merged
}

function Get-SystemMetrics {
    try {
        # Get performance counters
        $counterData = Get-Counter -Counter $script:config.Counters -SampleInterval 1 -MaxSamples 1 -ErrorAction SilentlyContinue
        
        # Get disk space info
        $diskInfo = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
            [PSCustomObject]@{
                Drive = $_.DeviceID
                TotalSizeGB = [Math]::Round($_.Size / 1GB, 2)
                FreeSpaceGB = [Math]::Round($_.FreeSpace / 1GB, 2)
                PercentFree = [Math]::Round(($_.FreeSpace / $_.Size) * 100, 1)
                PercentUsed = [Math]::Round((1 - ($_.FreeSpace / $_.Size)) * 100, 1)
            }
        }
        
        # Process counter data
        $metrics = @{
            Timestamp = Get-Date
            CPU = ($counterData.CounterSamples | Where-Object { $_.Path -like "*Processor*" } | Select-Object -First 1).CookedValue
            Memory = ($counterData.CounterSamples | Where-Object { $_.Path -like "*Memory*" } | Select-Object -First 1).CookedValue
            DiskQueue = ($counterData.CounterSamples | Where-Object { $_.Path -like "*Disk Queue*" } | Select-Object -First 1).CookedValue
            DiskInfo = $diskInfo
            ProcessCount = (Get-Process).Count
            ServiceCount = (Get-Service | Where-Object { $_.Status -eq "Running" }).Count
        }
        
        return $metrics
    } catch {
        Write-MonitorLog "Error collecting metrics: $($_.Exception.Message)" -Level "Error"
        return $null
    }
}

function Test-Thresholds {
    param([hashtable]$Metrics)
    
    $alerts = @()
    
    # CPU threshold
    if ($Metrics.CPU -gt $script:config.Thresholds.CPUPercent) {
        $alerts += [PSCustomObject]@{
            Type = "CPU"
            Current = [Math]::Round($Metrics.CPU, 1)
            Threshold = $script:config.Thresholds.CPUPercent
            Severity = if ($Metrics.CPU -gt 95) { "Critical" } else { "Warning" }
            Message = "CPU usage is $([Math]::Round($Metrics.CPU, 1))% (threshold: $($script:config.Thresholds.CPUPercent)%)"
        }
    }
    
    # Memory threshold
    if ($Metrics.Memory -gt $script:config.Thresholds.MemoryPercent) {
        $alerts += [PSCustomObject]@{
            Type = "Memory"
            Current = [Math]::Round($Metrics.Memory, 1)
            Threshold = $script:config.Thresholds.MemoryPercent
            Severity = if ($Metrics.Memory -gt 95) { "Critical" } else { "Warning" }
            Message = "Memory usage is $([Math]::Round($Metrics.Memory, 1))% (threshold: $($script:config.Thresholds.MemoryPercent)%)"
        }
    }
    
    # Disk queue threshold
    if ($Metrics.DiskQueue -gt $script:config.Thresholds.DiskQueueLength) {
        $alerts += [PSCustomObject]@{
            Type = "DiskQueue"
            Current = [Math]::Round($Metrics.DiskQueue, 1)
            Threshold = $script:config.Thresholds.DiskQueueLength
            Severity = "Warning"
            Message = "Disk queue length is $([Math]::Round($Metrics.DiskQueue, 1)) (threshold: $($script:config.Thresholds.DiskQueueLength))"
        }
    }
    
    # Disk space thresholds
    foreach ($disk in $Metrics.DiskInfo) {
        if ($disk.PercentUsed -gt $script:config.Thresholds.DiskSpacePercent) {
            $alerts += [PSCustomObject]@{
                Type = "DiskSpace"
                Current = $disk.PercentUsed
                Threshold = $script:config.Thresholds.DiskSpacePercent
                Severity = if ($disk.PercentUsed -gt 95) { "Critical" } else { "Warning" }
                Message = "Disk $($disk.Drive) is $($disk.PercentUsed)% full (threshold: $($script:config.Thresholds.DiskSpacePercent)%)"
            }
        }
    }
    
    return $alerts
}

function Send-AlertEmail {
    param(
        [array]$Alerts,
        [hashtable]$Metrics
    )
    
    if (!$EmailAlert -or $Alerts.Count -eq 0) { return }
    
    try {
        $emailBody = @"
<html>
<head><title>System Alert - $env:COMPUTERNAME</title></head>
<body>
<h2>System Alert - $env:COMPUTERNAME</h2>
<p><strong>Alert Time:</strong> $(Get-Date)</p>
<h3>Active Alerts:</h3>
<ul>
$(($Alerts | ForEach-Object { "<li><strong>[$($_.Severity)]</strong> $($_.Message)</li>" }) -join "`n")
</ul>
<h3>Current System Status:</h3>
<ul>
<li>CPU Usage: $([Math]::Round($Metrics.CPU, 1))%</li>
<li>Memory Usage: $([Math]::Round($Metrics.Memory, 1))%</li>
<li>Disk Queue Length: $([Math]::Round($Metrics.DiskQueue, 1))</li>
<li>Running Processes: $($Metrics.ProcessCount)</li>
<li>Running Services: $($Metrics.ServiceCount)</li>
</ul>
</body>
</html>
"@
        
        $emailParams = @{
            To = $script:config.Email.To
            From = $script:config.Email.From
            Subject = $script:config.Email.Subject -f $env:COMPUTERNAME
            Body = $emailBody
            BodyAsHtml = $true
            SmtpServer = $script:config.Email.SMTPServer
            Port = $script:config.Email.Port
            UseSsl = $script:config.Email.UseSSL
        }
        
        Send-MailMessage @emailParams
        Write-MonitorLog "Alert email sent successfully" -Level "Success"
        
    } catch {
        Write-MonitorLog "Failed to send alert email: $($_.Exception.Message)" -Level "Error"
    }
}

function Generate-HTMLReport {
    param([array]$MonitoringData)
    
    $reportFile = Join-Path $ReportPath "SystemMonitorReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
    
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>System Monitoring Report - $env:COMPUTERNAME</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background-color: #2E86AB; color: white; padding: 20px; border-radius: 5px; }
        .summary { background-color: #F5F5F5; padding: 15px; margin: 20px 0; border-radius: 5px; }
        .metrics { display: flex; flex-wrap: wrap; gap: 20px; margin: 20px 0; }
        .metric-box { background-color: white; border: 1px solid #ddd; padding: 15px; border-radius: 5px; min-width: 200px; }
        .alert { background-color: #FFE5E5; border-left: 5px solid #FF0000; padding: 10px; margin: 10px 0; }
        .warning { background-color: #FFF3CD; border-left: 5px solid #FFC107; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #2E86AB; color: white; }
        .chart { width: 100%; height: 300px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>System Monitoring Report</h1>
        <p>Computer: $env:COMPUTERNAME | Generated: $(Get-Date)</p>
    </div>
    
    <div class="summary">
        <h2>Monitoring Summary</h2>
        <p><strong>Monitoring Period:</strong> $(($MonitoringData | Select-Object -First 1).Timestamp) to $(($MonitoringData | Select-Object -Last 1).Timestamp)</p>
        <p><strong>Total Samples:</strong> $($MonitoringData.Count)</p>
        <p><strong>Sample Interval:</strong> $($script:config.SampleInterval) seconds</p>
    </div>
    
    <div class="metrics">
        <div class="metric-box">
            <h3>CPU Usage</h3>
            <p><strong>Current:</strong> $([Math]::Round(($MonitoringData | Select-Object -Last 1).CPU, 1))%</p>
            <p><strong>Average:</strong> $([Math]::Round(($MonitoringData | Measure-Object -Property CPU -Average).Average, 1))%</p>
            <p><strong>Peak:</strong> $([Math]::Round(($MonitoringData | Measure-Object -Property CPU -Maximum).Maximum, 1))%</p>
        </div>
        
        <div class="metric-box">
            <h3>Memory Usage</h3>
            <p><strong>Current:</strong> $([Math]::Round(($MonitoringData | Select-Object -Last 1).Memory, 1))%</p>
            <p><strong>Average:</strong> $([Math]::Round(($MonitoringData | Measure-Object -Property Memory -Average).Average, 1))%</p>
            <p><strong>Peak:</strong> $([Math]::Round(($MonitoringData | Measure-Object -Property Memory -Maximum).Maximum, 1))%</p>
        </div>
        
        <div class="metric-box">
            <h3>Disk Queue</h3>
            <p><strong>Current:</strong> $([Math]::Round(($MonitoringData | Select-Object -Last 1).DiskQueue, 1))</p>
            <p><strong>Average:</strong> $([Math]::Round(($MonitoringData | Measure-Object -Property DiskQueue -Average).Average, 1))</p>
            <p><strong>Peak:</strong> $([Math]::Round(($MonitoringData | Measure-Object -Property DiskQueue -Maximum).Maximum, 1))</p>
        </div>
    </div>
    
    <h2>Recent Data Points</h2>
    <table>
        <tr><th>Timestamp</th><th>CPU %</th><th>Memory %</th><th>Disk Queue</th><th>Processes</th><th>Services</th></tr>
        $(($MonitoringData | Select-Object -Last 20 | ForEach-Object {
            "<tr><td>$($_.Timestamp.ToString('HH:mm:ss'))</td><td>$([Math]::Round($_.CPU, 1))</td><td>$([Math]::Round($_.Memory, 1))</td><td>$([Math]::Round($_.DiskQueue, 1))</td><td>$($_.ProcessCount)</td><td>$($_.ServiceCount)</td></tr>"
        }) -join "`n")
    </table>
    
    <div style="margin-top: 40px; text-align: center; color: #666;">
        <p>Report generated by PowerShell System Monitor | $(Get-Date)</p>
    </div>
</body>
</html>
"@
    
    try {
        $html | Out-File -FilePath $reportFile -Encoding UTF8
        Write-MonitorLog "HTML report saved to: $reportFile" -Level "Success"
        return $reportFile
    } catch {
        Write-MonitorLog "Failed to save HTML report: $($_.Exception.Message)" -Level "Error"
        return $null
    }
}

function Start-Monitoring {
    Write-MonitorLog "Starting system monitoring..." -Level "Info"
    Write-MonitorLog "Monitor duration: $(if ($ContinuousMode) { 'Continuous' } else { "$MonitorDuration minutes" })" -Level "Info"
    Write-MonitorLog "Sample interval: $($script:config.SampleInterval) seconds" -Level "Info"
    
    $script:isRunning = $true
    $startTime = Get-Date
    $sampleCount = 0
    
    try {
        while ($script:isRunning) {
            $metrics = Get-SystemMetrics
            
            if ($metrics) {
                $script:monitoringData += $metrics
                $sampleCount++
                
                # Check thresholds
                $alerts = Test-Thresholds -Metrics $metrics
                
                if ($alerts.Count -gt 0) {
                    foreach ($alert in $alerts) {
                        $alertKey = "$($alert.Type)_$(Get-Date -Format 'yyyyMMddHH')"
                        
                        # Check cooldown period
                        if (!$script:alertLog.ContainsKey($alertKey) -or 
                            ((Get-Date) - $script:alertLog[$alertKey]).TotalSeconds -gt $script:config.AlertCooldown) {
                            
                            Write-MonitorLog $alert.Message -Level "Alert"
                            $script:alertLog[$alertKey] = Get-Date
                            
                            # Send email if first alert of this type in cooldown period
                            if ($EmailAlert) {
                                Send-AlertEmail -Alerts @($alert) -Metrics $metrics
                            }
                        }
                    }
                }
                
                # Progress update
                if (!$Quiet -and ($sampleCount % 12 -eq 0)) { # Every minute
                    Write-MonitorLog "Sample $sampleCount - CPU: $([Math]::Round($metrics.CPU, 1))% | Memory: $([Math]::Round($metrics.Memory, 1))% | Processes: $($metrics.ProcessCount)" -Level "Info"
                }
                
                # Keep only last 1000 samples to manage memory
                if ($script:monitoringData.Count -gt 1000) {
                    $script:monitoringData = $script:monitoringData | Select-Object -Last 800
                }
            }
            
            # Check if we should stop (non-continuous mode)
            if (!$ContinuousMode -and ((Get-Date) - $startTime).TotalMinutes -ge $MonitorDuration) {
                break
            }
            
            Start-Sleep -Seconds $script:config.SampleInterval
        }
    } catch {
        Write-MonitorLog "Error during monitoring: $($_.Exception.Message)" -Level "Error"
    } finally {
        Write-MonitorLog "Monitoring stopped. Collected $sampleCount samples." -Level "Info"
        
        # Generate final report
        if ($script:monitoringData.Count -gt 0) {
            $reportFile = Generate-HTMLReport -MonitoringData $script:monitoringData
            if ($reportFile) {
                Write-MonitorLog "Final report available at: $reportFile" -Level "Success"
            }
        }
    }
}

# Signal handler for graceful shutdown
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    $script:isRunning = $false
}

# Main execution
try {
    Write-MonitorLog "System Monitor starting on $env:COMPUTERNAME" -Level "Info"
    
    # Initialize configuration
    Initialize-Configuration -ConfigFile $ConfigPath
    
    # Validate report path
    if (!(Test-Path $ReportPath)) {
        New-Item -Path $ReportPath -ItemType Directory -Force | Out-Null
    }
    
    # Start monitoring
    Start-Monitoring
    
} catch {
    Write-MonitorLog "Critical error: $($_.Exception.Message)" -Level "Error" -Force
    exit 1
} finally {
    Write-MonitorLog "System Monitor shutdown complete" -Level "Info" -Force
} 
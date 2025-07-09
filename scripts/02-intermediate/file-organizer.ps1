<#
.SYNOPSIS
    Organizes files in a directory by type, date, or size.

.DESCRIPTION
    This script demonstrates intermediate PowerShell concepts by organizing files
    in a specified directory. It can sort files by extension, creation date, or size
    into organized folder structures.

.PARAMETER SourcePath
    The path containing files to organize. Defaults to current directory.

.PARAMETER OrganizeBy
    How to organize the files: ByType, ByDate, or BySize.

.PARAMETER DestinationPath
    Where to create the organized structure. Defaults to SourcePath.

.PARAMETER WhatIf
    Shows what would happen without actually moving files.

.PARAMETER CreateDateFolders
    When organizing by date, create year/month folder structure.

.PARAMETER MinimumFileSize
    Only organize files larger than this size (in KB). Default is 0.

.EXAMPLE
    .\file-organizer.ps1 -SourcePath "C:\Downloads" -OrganizeBy ByType
    
    Organizes files in Downloads folder by file extension

.EXAMPLE
    .\file-organizer.ps1 -SourcePath "C:\Photos" -OrganizeBy ByDate -CreateDateFolders
    
    Organizes photos by year and month

.EXAMPLE
    .\file-organizer.ps1 -OrganizeBy BySize -MinimumFileSize 1024 -WhatIf
    
    Shows how files would be organized by size (1MB+) without moving them

.NOTES
    File Name      : file-organizer.ps1
    Author         : PowerShell Learning Guide
    Prerequisite   : PowerShell 5.1 or later
    
    This script demonstrates:
    - Advanced parameter validation
    - File system operations
    - Loops and conditional logic
    - Error handling with detailed logging
    - Progress reporting
    - WhatIf functionality
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $false)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$SourcePath = (Get-Location).Path,
    
    [Parameter(Mandatory = $true)]
    [ValidateSet("ByType", "ByDate", "BySize")]
    [string]$OrganizeBy,
    
    [Parameter(Mandatory = $false)]
    [string]$DestinationPath = $SourcePath,
    
    [Parameter(Mandatory = $false)]
    [switch]$CreateDateFolders,
    
    [Parameter(Mandatory = $false)]
    [ValidateRange(0, [int]::MaxValue)]
    [int]$MinimumFileSize = 0
)

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("Info", "Warning", "Error", "Success")]
        [string]$Level = "Info"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "Info" { "White" }
        "Warning" { "Yellow" }
        "Error" { "Red" }
        "Success" { "Green" }
    }
    
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Get-FileTypeFolder {
    param([string]$Extension)
    
    $typeMap = @{
        '.jpg' = 'Images'
        '.jpeg' = 'Images'
        '.png' = 'Images'
        '.gif' = 'Images'
        '.bmp' = 'Images'
        '.tiff' = 'Images'
        '.pdf' = 'Documents'
        '.doc' = 'Documents'
        '.docx' = 'Documents'
        '.txt' = 'Documents'
        '.rtf' = 'Documents'
        '.xls' = 'Spreadsheets'
        '.xlsx' = 'Spreadsheets'
        '.csv' = 'Spreadsheets'
        '.ppt' = 'Presentations'
        '.pptx' = 'Presentations'
        '.mp3' = 'Audio'
        '.wav' = 'Audio'
        '.flac' = 'Audio'
        '.mp4' = 'Video'
        '.avi' = 'Video'
        '.mkv' = 'Video'
        '.mov' = 'Video'
        '.zip' = 'Archives'
        '.rar' = 'Archives'
        '.7z' = 'Archives'
        '.exe' = 'Executables'
        '.msi' = 'Executables'
    }
    
    if ($typeMap.ContainsKey($Extension.ToLower())) {
        return $typeMap[$Extension.ToLower()]
    } else {
        return 'Other'
    }
}

function Get-SizeCategory {
    param([long]$SizeInBytes)
    
    $sizeKB = $SizeInBytes / 1KB
    $sizeMB = $SizeInBytes / 1MB
    $sizeGB = $SizeInBytes / 1GB
    
    if ($sizeGB -ge 1) {
        return "Large (1GB+)"
    } elseif ($sizeMB -ge 100) {
        return "Medium (100MB-1GB)"
    } elseif ($sizeMB -ge 10) {
        return "Small (10-100MB)"
    } elseif ($sizeMB -ge 1) {
        return "Tiny (1-10MB)"
    } else {
        return "Micro (<1MB)"
    }
}

function New-OrganizedFolder {
    param(
        [string]$BasePath,
        [string]$FolderName
    )
    
    $folderPath = Join-Path $BasePath $FolderName
    
    if (!(Test-Path $folderPath)) {
        try {
            New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
            Write-Log "Created folder: $folderPath" -Level "Success"
            return $folderPath
        } catch {
            Write-Log "Failed to create folder: $folderPath - $($_.Exception.Message)" -Level "Error"
            return $null
        }
    }
    
    return $folderPath
}

function Move-FileToOrganizedLocation {
    param(
        [System.IO.FileInfo]$File,
        [string]$DestinationFolder
    )
    
    $destinationPath = Join-Path $DestinationFolder $File.Name
    
    # Handle file name conflicts
    $counter = 1
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)
    $extension = $File.Extension
    
    while (Test-Path $destinationPath) {
        $newName = "$baseName`_$counter$extension"
        $destinationPath = Join-Path $DestinationFolder $newName
        $counter++
    }
    
    try {
        if ($PSCmdlet.ShouldProcess($File.FullName, "Move to $destinationPath")) {
            Move-Item -Path $File.FullName -Destination $destinationPath -Force
            Write-Log "Moved: $($File.Name) -> $DestinationFolder" -Level "Success"
            return $true
        }
    } catch {
        Write-Log "Failed to move $($File.Name): $($_.Exception.Message)" -Level "Error"
        return $false
    }
    
    return $false
}

# Main script execution
try {
    Write-Log "Starting file organization process..." -Level "Info"
    Write-Log "Source Path: $SourcePath" -Level "Info"
    Write-Log "Destination Path: $DestinationPath" -Level "Info"
    Write-Log "Organize By: $OrganizeBy" -Level "Info"
    Write-Log "Minimum File Size: $MinimumFileSize KB" -Level "Info"
    
    # Get all files in source directory
    Write-Log "Scanning for files..." -Level "Info"
    $allFiles = Get-ChildItem -Path $SourcePath -File -Recurse:$false | Where-Object { 
        ($_.Length / 1KB) -ge $MinimumFileSize 
    }
    
    if ($allFiles.Count -eq 0) {
        Write-Log "No files found matching criteria." -Level "Warning"
        exit 0
    }
    
    Write-Log "Found $($allFiles.Count) files to organize" -Level "Info"
    
    # Initialize counters
    $processedCount = 0
    $successCount = 0
    $errorCount = 0
    
    # Process each file
    foreach ($file in $allFiles) {
        $processedCount++
        $percentComplete = [Math]::Round(($processedCount / $allFiles.Count) * 100, 1)
        
        Write-Progress -Activity "Organizing Files" -Status "Processing $($file.Name)" -PercentComplete $percentComplete
        
        try {
            $targetFolder = switch ($OrganizeBy) {
                "ByType" {
                    $typeFolder = Get-FileTypeFolder -Extension $file.Extension
                    New-OrganizedFolder -BasePath $DestinationPath -FolderName $typeFolder
                }
                "ByDate" {
                    if ($CreateDateFolders) {
                        $year = $file.CreationTime.Year
                        $month = $file.CreationTime.ToString("MM-MMMM")
                        $yearFolder = New-OrganizedFolder -BasePath $DestinationPath -FolderName $year.ToString()
                        New-OrganizedFolder -BasePath $yearFolder -FolderName $month
                    } else {
                        $dateFolder = $file.CreationTime.ToString("yyyy-MM-dd")
                        New-OrganizedFolder -BasePath $DestinationPath -FolderName $dateFolder
                    }
                }
                "BySize" {
                    $sizeCategory = Get-SizeCategory -SizeInBytes $file.Length
                    New-OrganizedFolder -BasePath $DestinationPath -FolderName $sizeCategory
                }
            }
            
            if ($targetFolder) {
                if (Move-FileToOrganizedLocation -File $file -DestinationFolder $targetFolder) {
                    $successCount++
                } else {
                    $errorCount++
                }
            } else {
                Write-Log "Could not create target folder for $($file.Name)" -Level "Error"
                $errorCount++
            }
            
        } catch {
            Write-Log "Error processing $($file.Name): $($_.Exception.Message)" -Level "Error"
            $errorCount++
        }
    }
    
    Write-Progress -Activity "Organizing Files" -Completed
    
    # Summary
    Write-Log "`n=== ORGANIZATION SUMMARY ===" -Level "Info"
    Write-Log "Total files processed: $processedCount" -Level "Info"
    Write-Log "Successfully organized: $successCount" -Level "Success"
    Write-Log "Errors encountered: $errorCount" -Level $(if ($errorCount -gt 0) { "Warning" } else { "Info" })
    
    if ($WhatIfPreference) {
        Write-Log "This was a WhatIf run - no files were actually moved." -Level "Warning"
    }
    
    Write-Log "File organization completed!" -Level "Success"
    
} catch {
    Write-Log "Critical error during file organization: $($_.Exception.Message)" -Level "Error"
    exit 1
} finally {
    Write-Progress -Activity "Organizing Files" -Completed
} 
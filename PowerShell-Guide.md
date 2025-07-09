# PowerShell Complete Guide: Beginner to Professional

## Table of Contents
1. [Getting Started](#getting-started)
2. [Basic Concepts](#basic-concepts)
3. [Essential Commands](#essential-commands)
4. [Variables and Data Types](#variables-and-data-types)
5. [Operators](#operators)
6. [Control Flow](#control-flow)
7. [Functions](#functions)
8. [Objects and Properties](#objects-and-properties)
9. [Pipeline](#pipeline)
10. [File System Operations](#file-system-operations)
11. [Text Processing](#text-processing)
12. [Error Handling](#error-handling)
13. [Modules and Scripts](#modules-and-scripts)
14. [Advanced Features](#advanced-features)
15. [Professional Best Practices](#professional-best-practices)

## Getting Started

### Installation and Setup
PowerShell comes pre-installed on Windows 10/11. For older versions or cross-platform:

```powershell
# Check PowerShell version
$PSVersionTable.PSVersion

# Update PowerShell (Windows)
winget install Microsoft.PowerShell

# Install PowerShell on Linux/macOS
# Visit: https://github.com/PowerShell/PowerShell/releases
```

### Basic Syntax Rules
- Commands use Verb-Noun format (Get-Process, Set-Location)
- Case-insensitive
- Comments start with #
- Line continuation with backtick `
- Command separation with semicolon ;

## Basic Concepts

### Help System
```powershell
# Get help for any command
Get-Help Get-Process
Get-Help Get-Process -Examples
Get-Help Get-Process -Detailed
Get-Help Get-Process -Full

# Update help files
Update-Help

# Find commands
Get-Command *process*
Get-Command -Verb Get
Get-Command -Noun Service
```

### Command Structure
```powershell
# Basic structure: Verb-Noun -Parameter Value
Get-Process -Name notepad
Get-ChildItem -Path C:\ -Recurse -Force

# Multiple parameters
Copy-Item -Path "source.txt" -Destination "backup.txt" -Force

# Positional parameters (order matters)
Copy-Item "source.txt" "backup.txt"
```

## Essential Commands

### Navigation and File Operations
```powershell
# Navigation
Get-Location                    # Current directory (pwd equivalent)
Set-Location C:\Users          # Change directory (cd equivalent)
Set-Location ..                # Go up one level
Set-Location ~                 # Go to home directory
Push-Location C:\Temp          # Save current location and move
Pop-Location                   # Return to saved location

# Listing files and directories
Get-ChildItem                  # List current directory (ls/dir equivalent)
Get-ChildItem -Force           # Include hidden files
Get-ChildItem -Recurse         # Recursive listing
Get-ChildItem *.txt            # Filter by extension
Get-ChildItem -Directory       # Only directories
Get-ChildItem -File            # Only files

# File operations
New-Item -ItemType File -Name "test.txt"           # Create file (touch equivalent)
New-Item -ItemType Directory -Name "newfolder"     # Create directory (mkdir equivalent)
Remove-Item "test.txt"                             # Delete file (rm equivalent)
Remove-Item "folder" -Recurse                      # Delete directory recursively
Copy-Item "source.txt" "destination.txt"          # Copy file (cp equivalent)
Move-Item "old.txt" "new.txt"                      # Move/rename file (mv equivalent)
```

### System Information
```powershell
# System info
Get-ComputerInfo
Get-Host
$env:COMPUTERNAME
$env:USERNAME

# Process management
Get-Process                    # List all processes (ps equivalent)
Get-Process notepad            # Specific process
Stop-Process -Name notepad     # Kill process (kill equivalent)
Start-Process notepad          # Start process

# Service management
Get-Service                    # List all services
Get-Service -Name Spooler      # Specific service
Start-Service -Name Spooler    # Start service
Stop-Service -Name Spooler     # Stop service
Restart-Service -Name Spooler  # Restart service
```

## Variables and Data Types

### Variable Declaration and Assignment
```powershell
# Basic variable assignment
$name = "John"
$age = 30
$isActive = $true

# Strongly typed variables
[string]$text = "Hello"
[int]$number = 42
[bool]$flag = $false
[datetime]$date = Get-Date

# Arrays
$fruits = @("apple", "banana", "orange")
$numbers = 1,2,3,4,5
$mixed = @("text", 123, $true)

# Hash tables (dictionaries)
$person = @{
    Name = "John"
    Age = 30
    City = "New York"
}

# Access hash table values
$person.Name
$person["Age"]
```

### Special Variables
```powershell
# Automatic variables
$_                 # Current object in pipeline
$?                 # Success of last command
$^                 # First token of last line
$$                 # Last token of last line
$args              # Command line arguments
$error             # Array of recent errors
$home              # User's home directory
$host              # Current host program
$pid               # Process ID
$profile           # Path to PowerShell profile
$pwd               # Current directory

# Environment variables
$env:PATH
$env:USERNAME
$env:COMPUTERNAME
$env:TEMP
```

## Operators

### Arithmetic Operators
```powershell
$a = 10
$b = 3

$a + $b    # Addition: 13
$a - $b    # Subtraction: 7
$a * $b    # Multiplication: 30
$a / $b    # Division: 3.33333333333333
$a % $b    # Modulus: 1
```

### Comparison Operators
```powershell
# Equality
$a -eq $b      # Equal
$a -ne $b      # Not equal
$a -gt $b      # Greater than
$a -ge $b      # Greater than or equal
$a -lt $b      # Less than
$a -le $b      # Less than or equal

# String comparison (case-insensitive by default)
"Hello" -eq "hello"        # True
"Hello" -ceq "hello"       # False (case-sensitive)
"Hello" -ieq "hello"       # True (explicitly case-insensitive)

# Pattern matching
"Hello World" -like "*World"     # True
"Hello World" -notlike "*Mars"   # True
"Hello123" -match "\d+"          # True (regex)
"Hello123" -notmatch "\d+"       # False
```

### Logical Operators
```powershell
$true -and $false    # False
$true -or $false     # True
-not $true           # False
!$false              # True
```

### Assignment Operators
```powershell
$a = 10
$a += 5     # $a = 15
$a -= 3     # $a = 12
$a *= 2     # $a = 24
$a /= 4     # $a = 6
$a %= 4     # $a = 2
```

## Control Flow

### If Statements
```powershell
$age = 25

if ($age -ge 18) {
    Write-Output "Adult"
} elseif ($age -ge 13) {
    Write-Output "Teenager"
} else {
    Write-Output "Child"
}

# One-liner if
if ($age -ge 18) { "Adult" }
```

### Switch Statements
```powershell
$day = "Monday"

switch ($day) {
    "Monday" { "Start of work week" }
    "Friday" { "TGIF!" }
    "Saturday" { "Weekend!" }
    "Sunday" { "Weekend!" }
    default { "Regular day" }
}

# Switch with conditions
switch ($age) {
    {$_ -lt 13} { "Child" }
    {$_ -lt 20} { "Teenager" }
    {$_ -lt 65} { "Adult" }
    default { "Senior" }
}
```

### Loops

#### For Loop
```powershell
# Traditional for loop
for ($i = 0; $i -lt 10; $i++) {
    Write-Output "Number: $i"
}

# For loop with array
$names = @("Alice", "Bob", "Charlie")
for ($i = 0; $i -lt $names.Length; $i++) {
    Write-Output "Name $($i+1): $($names[$i])"
}
```

#### ForEach Loop
```powershell
# ForEach with array
$fruits = @("apple", "banana", "orange")
foreach ($fruit in $fruits) {
    Write-Output "I like $fruit"
}

# ForEach with range
foreach ($num in 1..5) {
    Write-Output "Number: $num"
}

# ForEach with hash table
$person = @{Name="John"; Age=30; City="NYC"}
foreach ($key in $person.Keys) {
    Write-Output "$key = $($person[$key])"
}
```

#### While Loop
```powershell
$counter = 0
while ($counter -lt 5) {
    Write-Output "Counter: $counter"
    $counter++
}
```

#### Do-While and Do-Until
```powershell
# Do-While (executes at least once)
$number = 0
do {
    Write-Output "Number: $number"
    $number++
} while ($number -lt 3)

# Do-Until
$number = 0
do {
    Write-Output "Number: $number"
    $number++
} until ($number -eq 3)
```

## Functions

### Basic Function Definition
```powershell
# Simple function
function Say-Hello {
    Write-Output "Hello, World!"
}

# Call the function
Say-Hello

# Function with parameters
function Say-HelloTo {
    param(
        [string]$Name
    )
    Write-Output "Hello, $Name!"
}

Say-HelloTo -Name "John"
Say-HelloTo "John"  # Positional parameter
```

### Advanced Function Features
```powershell
# Function with multiple parameters and defaults
function Get-UserInfo {
    param(
        [Parameter(Mandatory=$true)]
        [string]$UserName,
        
        [Parameter(Mandatory=$false)]
        [string]$Department = "Unknown",
        
        [switch]$Detailed
    )
    
    $info = "User: $UserName, Department: $Department"
    
    if ($Detailed) {
        $info += ", Created: $(Get-Date)"
    }
    
    return $info
}

# Usage
Get-UserInfo -UserName "John"
Get-UserInfo -UserName "John" -Department "IT" -Detailed
```

### Function with Pipeline Support
```powershell
function Convert-ToUpper {
    param(
        [Parameter(ValueFromPipeline=$true)]
        [string]$InputString
    )
    
    process {
        return $InputString.ToUpper()
    }
}

# Usage
"hello world" | Convert-ToUpper
@("hello", "world") | Convert-ToUpper
```

## Objects and Properties

### Working with Objects
```powershell
# Get object properties and methods
Get-Process | Get-Member
Get-Service | Get-Member -MemberType Property
Get-Service | Get-Member -MemberType Method

# Select specific properties
Get-Process | Select-Object Name, CPU, WorkingSet
Get-Service | Select-Object Name, Status, StartType

# Create custom objects
$customObject = [PSCustomObject]@{
    Name = "John"
    Age = 30
    Department = "IT"
}

# Array of custom objects
$employees = @(
    [PSCustomObject]@{Name="John"; Age=30; Dept="IT"},
    [PSCustomObject]@{Name="Jane"; Age=25; Dept="HR"},
    [PSCustomObject]@{Name="Bob"; Age=35; Dept="Finance"}
)

# Access object properties
$customObject.Name
$employees[0].Dept
```

### Object Manipulation
```powershell
# Sort objects
Get-Process | Sort-Object CPU -Descending
$employees | Sort-Object Age

# Filter objects
Get-Process | Where-Object {$_.CPU -gt 100}
$employees | Where-Object {$_.Age -gt 25}

# Group objects
Get-Service | Group-Object Status
$employees | Group-Object Dept

# Measure objects
Get-ChildItem | Measure-Object -Property Length -Sum -Average -Maximum
```

## Pipeline

### Understanding the Pipeline
```powershell
# Basic pipeline usage
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5

# Multiple operations
Get-ChildItem -Path C:\Windows\System32 -Filter "*.exe" | 
    Where-Object {$_.Length -gt 1MB} | 
    Sort-Object Length -Descending | 
    Select-Object Name, Length | 
    Format-Table -AutoSize

# Pipeline with ForEach-Object
1..10 | ForEach-Object { $_ * 2 }
Get-Process | ForEach-Object { "Process: $($_.Name)" }
```

### Advanced Pipeline Techniques
```powershell
# Tee-Object (split pipeline)
Get-Process | Tee-Object -FilePath "processes.txt" | Sort-Object CPU

# Out-GridView (interactive filtering)
Get-Service | Out-GridView -PassThru | Stop-Service -WhatIf

# Export pipeline results
Get-Process | Export-Csv -Path "processes.csv" -NoTypeInformation
Get-Service | ConvertTo-Json | Out-File "services.json"
Get-EventLog -LogName System -Newest 100 | Export-Clixml "events.xml"
```

## File System Operations

### File Content Operations
```powershell
# Read file content
Get-Content "file.txt"
Get-Content "file.txt" -TotalCount 10    # First 10 lines
Get-Content "file.txt" -Tail 5           # Last 5 lines

# Write file content
"Hello World" | Out-File "hello.txt"
"Line 1" | Set-Content "file.txt"
"Line 2" | Add-Content "file.txt"

# Read/Write with encoding
Get-Content "file.txt" -Encoding UTF8
"Content" | Out-File "file.txt" -Encoding UTF8

# Work with CSV files
$data = Import-Csv "data.csv"
$data | Export-Csv "output.csv" -NoTypeInformation

# Work with JSON
$json = Get-Content "data.json" | ConvertFrom-Json
$data | ConvertTo-Json | Out-File "output.json"
```

### File System Searches
```powershell
# Find files by name
Get-ChildItem -Path C:\ -Name "*.log" -Recurse

# Find files by size
Get-ChildItem -Path C:\Temp | Where-Object {$_.Length -gt 1MB}

# Find files by date
Get-ChildItem | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-7)}

# Search file content
Select-String -Path "*.txt" -Pattern "error"
Select-String -Path "*.log" -Pattern "error|warning" -CaseSensitive
```

### Advanced File Operations
```powershell
# File attributes
Get-ItemProperty "file.txt"
Set-ItemProperty "file.txt" -Name IsReadOnly -Value $true

# File/folder permissions
Get-Acl "C:\Temp"
$acl = Get-Acl "C:\Temp"
Set-Acl -Path "C:\NewFolder" -AclObject $acl

# Monitor file changes
Register-ObjectEvent -InputObject (New-Object IO.FileSystemWatcher "C:\Temp") -EventName Changed -Action {
    Write-Host "File changed: $($Event.SourceEventArgs.FullPath)"
}
```

## Text Processing

### String Manipulation
```powershell
$text = "Hello, World!"

# Basic operations
$text.Length                    # 13
$text.ToUpper()                # "HELLO, WORLD!"
$text.ToLower()                # "hello, world!"
$text.Substring(0, 5)          # "Hello"
$text.Replace("World", "PowerShell")  # "Hello, PowerShell!"

# String methods
$text.Contains("World")        # True
$text.StartsWith("Hello")      # True
$text.EndsWith("!")            # True
$text.IndexOf("o")             # 4
$text.Split(",")               # @("Hello", " World!")
```

### Regular Expressions
```powershell
# Basic regex matching
"abc123def" -match "\d+"       # True
$matches[0]                    # "123"

# Replace with regex
"Phone: 123-456-7890" -replace "\d{3}-\d{3}-\d{4}", "XXX-XXX-XXXX"

# Multiple matches
[regex]::Matches("abc123def456ghi", "\d+") | ForEach-Object { $_.Value }

# Named groups
$email = "john.doe@company.com"
if ($email -match "(?<user>[\w.]+)@(?<domain>[\w.]+)") {
    "User: $($matches.user)"
    "Domain: $($matches.domain)"
}
```

### Text Processing with Pipeline
```powershell
# Process text files
Get-Content "log.txt" | 
    Where-Object {$_ -match "ERROR"} | 
    ForEach-Object {$_.ToUpper()} | 
    Out-File "errors.txt"

# Extract specific data
Get-Content "access.log" | 
    Where-Object {$_ -match "(\d+\.\d+\.\d+\.\d+)"} | 
    ForEach-Object { $matches[1] } | 
    Sort-Object -Unique
```

## Error Handling

### Try-Catch-Finally
```powershell
try {
    $result = 10 / 0
    Write-Output "Result: $result"
}
catch [System.DivideByZeroException] {
    Write-Error "Cannot divide by zero!"
}
catch {
    Write-Error "An unexpected error occurred: $($_.Exception.Message)"
}
finally {
    Write-Output "Cleanup operations"
}
```

### Error Handling Best Practices
```powershell
# Set error action preference
$ErrorActionPreference = "Stop"        # Stop on any error
$ErrorActionPreference = "Continue"    # Continue on errors (default)
$ErrorActionPreference = "SilentlyContinue"  # Suppress error messages

# Per-command error handling
Get-Process -Name "nonexistent" -ErrorAction SilentlyContinue
Get-Service -Name "fake" -ErrorAction Stop

# Test operations safely
if (Test-Path "C:\file.txt") {
    Remove-Item "C:\file.txt"
}

# Validate parameters
function Test-Number {
    param([int]$Number)
    
    if ($Number -lt 0) {
        throw "Number must be positive"
    }
    
    return $Number * 2
}
```

### Custom Error Messages
```powershell
function Get-UserData {
    param([string]$UserName)
    
    if (-not $UserName) {
        Write-Error "UserName parameter is required" -ErrorAction Stop
    }
    
    try {
        # Simulate API call
        if ($UserName -eq "admin") {
            throw "Access denied for admin user"
        }
        
        return @{Name = $UserName; Status = "Active"}
    }
    catch {
        Write-Warning "Failed to get user data for $UserName"
        throw $_
    }
}
```

## Modules and Scripts

### Script Files
```powershell
# Create a script file (Save as script.ps1)
param(
    [Parameter(Mandatory=$true)]
    [string]$Name,
    [int]$Count = 1
)

Write-Output "Script Parameters:"
Write-Output "Name: $Name"
Write-Output "Count: $Count"

for ($i = 1; $i -le $Count; $i++) {
    Write-Output "Hello $Name - Iteration $i"
}

# Run the script
.\script.ps1 -Name "John" -Count 3
```

### PowerShell Modules
```powershell
# List available modules
Get-Module -ListAvailable

# Import a module
Import-Module -Name ActiveDirectory

# Find modules online
Find-Module -Name "*Azure*"

# Install modules from PowerShell Gallery
Install-Module -Name Az -Scope CurrentUser
Install-Module -Name PSReadLine -Force

# Create a simple module (Save as MyModule.psm1)
function Get-Greeting {
    param([string]$Name = "World")
    return "Hello, $Name!"
}

function Get-TimeStamp {
    return Get-Date -Format "yyyy-MM-dd HH:mm:ss"
}

Export-ModuleMember -Function Get-Greeting, Get-TimeStamp

# Import custom module
Import-Module .\MyModule.psm1
Get-Greeting -Name "PowerShell"
```

### PowerShell Profile
```powershell
# Check if profile exists
Test-Path $PROFILE

# Create profile directory if needed
New-Item -ItemType Directory -Path (Split-Path $PROFILE) -Force

# Edit profile
notepad $PROFILE

# Example profile content:
# Set location to a preferred directory
Set-Location C:\Dev

# Create aliases
Set-Alias ll Get-ChildItem
Set-Alias grep Select-String

# Custom functions
function Get-PublicIP {
    Invoke-RestMethod -Uri "http://ipinfo.io/ip"
}

# Custom prompt
function prompt {
    $currentPath = (Get-Location).Path.Replace($env:USERPROFILE, "~")
    "PS $currentPath> "
}
```

## Advanced Features

### Remoting
```powershell
# Enable PowerShell Remoting
Enable-PSRemoting -Force

# Create remote session
$session = New-PSSession -ComputerName "Server01"

# Run commands remotely
Invoke-Command -Session $session -ScriptBlock { Get-Process }

# Copy files to/from remote computer
Copy-Item -Path "local.txt" -Destination "C:\temp\" -ToSession $session
Copy-Item -Path "C:\temp\remote.txt" -Destination ".\local\" -FromSession $session

# Interactive remote session
Enter-PSSession -Session $session
# ... work on remote computer ...
Exit-PSSession

# Clean up
Remove-PSSession $session
```

### Background Jobs
```powershell
# Start background job
$job = Start-Job -ScriptBlock { 
    Start-Sleep 10
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5
}

# Check job status
Get-Job
Get-Job -Id $job.Id

# Wait for job completion
Wait-Job $job

# Get job results
Receive-Job $job

# Remove completed jobs
Remove-Job $job

# Thread jobs (faster for simple tasks)
$threadJob = Start-ThreadJob -ScriptBlock { 1..1000 | ForEach-Object { $_ * $_ } }
```

### Advanced Pipeline Features
```powershell
# Parallel processing with ForEach-Object -Parallel (PowerShell 7+)
1..10 | ForEach-Object -Parallel {
    Start-Sleep 1
    "Processed $_"
} -ThrottleLimit 5

# Pipeline with Begin, Process, End blocks
function Process-Numbers {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true)]
        [int]$Number
    )
    
    begin {
        Write-Output "Starting processing..."
        $total = 0
    }
    
    process {
        $total += $Number
        Write-Output "Processing: $Number"
    }
    
    end {
        Write-Output "Total: $total"
    }
}

1..5 | Process-Numbers
```

### Working with APIs and Web Services
```powershell
# REST API calls
$response = Invoke-RestMethod -Uri "https://api.github.com/users/octocat"
$response.name

# POST request with JSON
$body = @{
    name = "test"
    description = "Test repository"
} | ConvertTo-Json

$headers = @{
    Authorization = "token your_token_here"
    Accept = "application/vnd.github.v3+json"
}

Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method POST -Body $body -Headers $headers -ContentType "application/json"

# Download files
Invoke-WebRequest -Uri "https://example.com/file.zip" -OutFile "download.zip"

# Web scraping
$html = Invoke-WebRequest -Uri "https://example.com"
$html.Links | Select-Object href, innerText
```

## Professional Best Practices

### Script Organization and Documentation
```powershell
<#
.SYNOPSIS
    Brief description of the script's purpose.

.DESCRIPTION
    Detailed description of what the script does.

.PARAMETER Path
    Description of the Path parameter.

.PARAMETER Recurse
    Description of the Recurse parameter.

.EXAMPLE
    .\MyScript.ps1 -Path "C:\Temp" -Recurse
    
    This example shows how to run the script with parameters.

.NOTES
    Author: Your Name
    Date: 2025-01-XX
    Version: 1.0
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, HelpMessage="Specify the path to process")]
    [ValidateScript({Test-Path $_})]
    [string]$Path,
    
    [Parameter(Mandatory=$false)]
    [switch]$Recurse
)

# Script implementation here...
```

### Performance Optimization
```powershell
# Use ArrayList instead of regular arrays for large datasets
$arrayList = [System.Collections.ArrayList]@()
$arrayList.Add("item") | Out-Null  # Suppress output

# Use StringBuilder for string concatenation
$sb = [System.Text.StringBuilder]::new()
1..1000 | ForEach-Object { $sb.AppendLine("Line $_") | Out-Null }
$result = $sb.ToString()

# Measure execution time
Measure-Command {
    # Your code here
    Get-Process | Sort-Object CPU
}

# Use .NET methods when appropriate
[System.IO.File]::ReadAllText("file.txt")  # Faster than Get-Content for large files
```

### Security Best Practices
```powershell
# Secure credential handling
$credential = Get-Credential
$securePassword = ConvertTo-SecureString -String "password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("username", $securePassword)

# Execution policy management
Get-ExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Input validation
function Test-EmailAddress {
    param([string]$Email)
    
    if ($Email -notmatch "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$") {
        throw "Invalid email address format"
    }
    
    return $true
}

# Avoid storing sensitive data in scripts
# Use environment variables or secure credential storage instead
$apiKey = $env:API_KEY
```

### Testing and Debugging
```powershell
# Debug with breakpoints
Set-PSBreakpoint -Script "script.ps1" -Line 10

# Step through code
Set-PSDebug -Step

# Trace execution
Set-PSDebug -Trace 1

# Write debug information
Write-Debug "Debug message" -Debug
Write-Verbose "Verbose message" -Verbose

# Unit testing with Pester (install first: Install-Module -Name Pester)
Describe "Math Functions" {
    It "Should add two numbers correctly" {
        $result = 2 + 3
        $result | Should -Be 5
    }
    
    It "Should handle division by zero" {
        { 10 / 0 } | Should -Throw
    }
}
```

### Advanced Scripting Patterns
```powershell
# Splatting parameters
$params = @{
    Path = "C:\Temp"
    Filter = "*.txt"
    Recurse = $true
}
Get-ChildItem @params

# Dynamic parameter creation
function Get-DynamicParam {
    [CmdletBinding()]
    param()
    
    DynamicParam {
        $attributes = New-Object System.Management.Automation.ParameterAttribute
        $attributes.Mandatory = $true
        
        $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
        $attributeCollection.Add($attributes)
        
        $dynParam = New-Object System.Management.Automation.RuntimeDefinedParameter('DynamicParameter', [string], $attributeCollection)
        
        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        $paramDictionary.Add('DynamicParameter', $dynParam)
        
        return $paramDictionary
    }
    
    process {
        Write-Output "Dynamic parameter value: $($PSBoundParameters.DynamicParameter)"
    }
}

# Class-based approach (PowerShell 5+)
class Calculator {
    [int] Add([int]$a, [int]$b) {
        return $a + $b
    }
    
    [int] Multiply([int]$a, [int]$b) {
        return $a * $b
    }
}

$calc = [Calculator]::new()
$calc.Add(5, 3)
```

## Quick Reference Commands

### Essential One-Liners
```powershell
# System information
Get-ComputerInfo | Select-Object WindowsProductName, TotalPhysicalMemory, CsProcessors

# Disk usage
Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}

# Top CPU processes
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, WorkingSet

# Network connections
Get-NetTCPConnection | Where-Object State -eq "Established" | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort

# Event log errors (last 24 hours)
Get-WinEvent -FilterHashtable @{LogName='System'; Level=2; StartTime=(Get-Date).AddDays(-1)} | Select-Object TimeCreated, Id, LevelDisplayName, Message

# File size summary
Get-ChildItem -Recurse | Where-Object {!$_.PSIsContainer} | Measure-Object -Property Length -Sum | Select-Object @{Name="TotalSize(MB)";Expression={[math]::Round($_.Sum/1MB,2)}}

# Find large files
Get-ChildItem -Recurse | Where-Object {$_.Length -gt 100MB} | Sort-Object Length -Descending | Select-Object Name, @{Name="Size(MB)";Expression={[math]::Round($_.Length/1MB,2)}}

# Registry query
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion" | Select-Object ProductName, ReleaseId, CurrentBuild

# User accounts
Get-LocalUser | Select-Object Name, Enabled, LastLogon, PasswordRequired

# Installed software
Get-WmiObject -Class Win32_Product | Select-Object Name, Version, Vendor | Sort-Object Name
```

This guide covers PowerShell from basic concepts to advanced professional techniques. Each section includes practical, copyable commands with explanations of their usage. The progression moves from fundamental operations to sophisticated scripting patterns that professional PowerShell developers use daily. 
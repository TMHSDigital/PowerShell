<#
.SYNOPSIS
    A simple "Hello World" script demonstrating basic PowerShell concepts.

.DESCRIPTION
    This script demonstrates fundamental PowerShell concepts including:
    - Parameter handling
    - Output methods
    - Basic validation
    - Help documentation

.PARAMETER Name
    The name to include in the greeting. Defaults to "World" if not specified.

.PARAMETER Language
    The language for the greeting. Supported languages: English, Spanish, French, German.

.PARAMETER Loud
    If specified, the greeting will be displayed in uppercase.

.PARAMETER Count
    Number of times to repeat the greeting. Must be between 1 and 10.

.EXAMPLE
    .\hello-world.ps1
    
    Displays: Hello, World!

.EXAMPLE
    .\hello-world.ps1 -Name "PowerShell" -Loud
    
    Displays: HELLO, POWERSHELL!

.EXAMPLE
    .\hello-world.ps1 -Name "Usuario" -Language Spanish -Count 2
    
    Displays the Spanish greeting twice

.NOTES
    File Name      : hello-world.ps1
    Author         : PowerShell Learning Guide
    Prerequisite   : PowerShell 5.1 or later
    
    This script demonstrates:
    - Parameter declaration and validation
    - Switch parameters
    - Basic string manipulation
    - Output formatting
    - Help documentation structure
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false, HelpMessage = "Enter the name to greet")]
    [ValidateNotNullOrEmpty()]
    [string]$Name = "World",
    
    [Parameter(Mandatory = $false)]
    [ValidateSet("English", "Spanish", "French", "German")]
    [string]$Language = "English",
    
    [Parameter(Mandatory = $false)]
    [switch]$Loud,
    
    [Parameter(Mandatory = $false)]
    [ValidateRange(1, 10)]
    [int]$Count = 1
)

# Function to get greeting in different languages
function Get-Greeting {
    param(
        [string]$Lang,
        [string]$Name
    )
    
    switch ($Lang) {
        "English" { return "Hello, $Name!" }
        "Spanish" { return "¡Hola, $Name!" }
        "French"  { return "Bonjour, $Name!" }
        "German"  { return "Hallo, $Name!" }
        default   { return "Hello, $Name!" }
    }
}

# Main script logic
try {
    Write-Verbose "Starting hello-world script with parameters:"
    Write-Verbose "Name: $Name"
    Write-Verbose "Language: $Language"
    Write-Verbose "Loud: $Loud"
    Write-Verbose "Count: $Count"
    
    # Generate the greeting
    $greeting = Get-Greeting -Lang $Language -Name $Name
    
    # Apply uppercase if Loud switch is used
    if ($Loud) {
        $greeting = $greeting.ToUpper()
    }
    
    # Output the greeting the specified number of times
    for ($i = 1; $i -le $Count; $i++) {
        if ($Count -gt 1) {
            Write-Host "[$i] $greeting" -ForegroundColor Green
        } else {
            Write-Host $greeting -ForegroundColor Green
        }
    }
    
    # Demonstrate different output methods
    Write-Verbose "Demonstrating output methods:"
    Write-Output "This goes to the output stream"
    Write-Information "This is informational" -InformationAction Continue
    
    # Show script completion
    Write-Host "`nScript completed successfully!" -ForegroundColor Cyan
    
} catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
    exit 1
}

# Demonstrate automatic variables
Write-Verbose "Script file: $($MyInvocation.MyCommand.Name)"
Write-Verbose "Script path: $($MyInvocation.MyCommand.Path)"
Write-Verbose "PowerShell version: $($PSVersionTable.PSVersion)" 
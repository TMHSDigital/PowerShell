<#
.SYNOPSIS
    Generates secure passwords with customizable criteria.

.DESCRIPTION
    This utility script demonstrates:
    - Cryptographically secure random generation
    - Parameter validation and sets
    - Character set manipulation
    - Password strength validation
    - Clipboard integration

.PARAMETER Length
    Length of the password to generate (8-128 characters).

.PARAMETER Count
    Number of passwords to generate (1-50).

.PARAMETER IncludeSpecial
    Include special characters (!@#$%^&*).

.PARAMETER ExcludeAmbiguous
    Exclude ambiguous characters (0, O, l, I, 1).

.PARAMETER RequireAll
    Ensure password contains at least one character from each selected character set.

.PARAMETER NoUppercase
    Exclude uppercase letters.

.PARAMETER NoLowercase
    Exclude lowercase letters.

.PARAMETER NoNumbers
    Exclude numbers.

.PARAMETER CustomSpecial
    Custom set of special characters to use instead of default.

.PARAMETER CopyToClipboard
    Copy the first generated password to clipboard.

.PARAMETER ExportPath
    Export generated passwords to a file.

.EXAMPLE
    .\password-generator.ps1 -Length 16 -Count 5 -IncludeSpecial
    
    Generates 5 passwords, 16 characters long, with special characters

.EXAMPLE
    .\password-generator.ps1 -Length 20 -RequireAll -ExcludeAmbiguous -CopyToClipboard
    
    Generates one secure 20-character password and copies to clipboard

.NOTES
    File Name      : password-generator.ps1
    Author         : PowerShell Learning Guide
    Prerequisite   : PowerShell 5.1 or later
    
    This script demonstrates:
    - Secure random number generation
    - Advanced parameter validation
    - Character set manipulation
    - Clipboard operations
    - Password strength calculation
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateRange(8, 128)]
    [int]$Length = 12,
    
    [Parameter(Mandatory = $false)]
    [ValidateRange(1, 50)]
    [int]$Count = 1,
    
    [Parameter(Mandatory = $false)]
    [switch]$IncludeSpecial,
    
    [Parameter(Mandatory = $false)]
    [switch]$ExcludeAmbiguous,
    
    [Parameter(Mandatory = $false)]
    [switch]$RequireAll,
    
    [Parameter(Mandatory = $false)]
    [switch]$NoUppercase,
    
    [Parameter(Mandatory = $false)]
    [switch]$NoLowercase,
    
    [Parameter(Mandatory = $false)]
    [switch]$NoNumbers,
    
    [Parameter(Mandatory = $false)]
    [ValidateLength(1, 50)]
    [string]$CustomSpecial,
    
    [Parameter(Mandatory = $false)]
    [switch]$CopyToClipboard,
    
    [Parameter(Mandatory = $false)]
    [string]$ExportPath
)

# Character sets
$upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
$lowerCase = "abcdefghijklmnopqrstuvwxyz"
$numbers = "0123456789"
$specialChars = "!@#$%^&*()-_=+[]{}|;:,.<>?"
$ambiguousChars = "0Ol1I"

function Get-SecureRandom {
    param(
        [int]$Min,
        [int]$Max
    )
    
    # Use cryptographically secure random number generator
    $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
    $bytes = New-Object byte[] 4
    $rng.GetBytes($bytes)
    $rng.Dispose()
    
    $randomInt = [BitConverter]::ToUInt32($bytes, 0)
    return $Min + ($randomInt % ($Max - $Min))
}

function Get-CharacterSet {
    param()
    
    $charSet = ""
    $requiredSets = @()
    
    # Build character set based on parameters
    if (!$NoUppercase) {
        $chars = $upperCase
        if ($ExcludeAmbiguous) {
            $chars = $chars -replace "[$([regex]::Escape($ambiguousChars))]", ""
        }
        $charSet += $chars
        $requiredSets += $chars
    }
    
    if (!$NoLowercase) {
        $chars = $lowerCase
        if ($ExcludeAmbiguous) {
            $chars = $chars -replace "[$([regex]::Escape($ambiguousChars))]", ""
        }
        $charSet += $chars
        $requiredSets += $chars
    }
    
    if (!$NoNumbers) {
        $chars = $numbers
        if ($ExcludeAmbiguous) {
            $chars = $chars -replace "[$([regex]::Escape($ambiguousChars))]", ""
        }
        $charSet += $chars
        $requiredSets += $chars
    }
    
    if ($IncludeSpecial) {
        $chars = if ($CustomSpecial) { $CustomSpecial } else { $specialChars }
        $charSet += $chars
        $requiredSets += $chars
    }
    
    if ($charSet.Length -eq 0) {
        throw "No character sets selected. At least one character type must be enabled."
    }
    
    return @{
        CharSet = $charSet
        RequiredSets = $requiredSets
    }
}

function New-SecurePassword {
    param(
        [string]$CharacterSet,
        [array]$RequiredSets,
        [int]$PasswordLength,
        [bool]$EnsureAllTypes
    )
    
    $password = ""
    $charArray = $CharacterSet.ToCharArray()
    
    # If RequireAll is specified, ensure at least one character from each set
    if ($EnsureAllTypes -and $RequiredSets.Count -gt 0) {
        foreach ($set in $RequiredSets) {
            if ($set.Length -gt 0) {
                $setArray = $set.ToCharArray()
                $randomIndex = Get-SecureRandom -Min 0 -Max $setArray.Length
                $password += $setArray[$randomIndex]
            }
        }
    }
    
    # Fill remaining positions
    $remainingLength = $PasswordLength - $password.Length
    for ($i = 0; $i -lt $remainingLength; $i++) {
        $randomIndex = Get-SecureRandom -Min 0 -Max $charArray.Length
        $password += $charArray[$randomIndex]
    }
    
    # Shuffle the password to randomize required character positions
    $passwordArray = $password.ToCharArray()
    for ($i = $passwordArray.Length - 1; $i -gt 0; $i--) {
        $j = Get-SecureRandom -Min 0 -Max ($i + 1)
        $temp = $passwordArray[$i]
        $passwordArray[$i] = $passwordArray[$j]
        $passwordArray[$j] = $temp
    }
    
    return -join $passwordArray
}

function Test-PasswordStrength {
    param([string]$Password)
    
    $score = 0
    $feedback = @()
    
    # Length scoring
    if ($Password.Length -ge 12) { $score += 2 }
    elseif ($Password.Length -ge 8) { $score += 1 }
    else { $feedback += "Password should be at least 8 characters long" }
    
    # Character variety scoring
    if ($Password -cmatch "[A-Z]") { $score += 1 }
    else { $feedback += "Consider adding uppercase letters" }
    
    if ($Password -cmatch "[a-z]") { $score += 1 }
    else { $feedback += "Consider adding lowercase letters" }
    
    if ($Password -match "\d") { $score += 1 }
    else { $feedback += "Consider adding numbers" }
    
    if ($Password -match "[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]") { $score += 2 }
    else { $feedback += "Consider adding special characters" }
    
    # Pattern detection
    if ($Password -match "(.)\1{2,}") { 
        $score -= 1
        $feedback += "Avoid repeating characters"
    }
    
    if ($Password -match "(012|123|234|345|456|567|678|789|890|abc|bcd|cde|def)") {
        $score -= 1
        $feedback += "Avoid sequential characters"
    }
    
    # Strength rating
    $strength = switch ($score) {
        { $_ -ge 6 } { "Very Strong" }
        { $_ -ge 4 } { "Strong" }
        { $_ -ge 2 } { "Medium" }
        default { "Weak" }
    }
    
    return @{
        Score = $score
        Strength = $strength
        Feedback = $feedback
    }
}

function Copy-ToClipboard {
    param([string]$Text)
    
    try {
        if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5) {
            Set-Clipboard -Value $Text
            Write-Host "Password copied to clipboard!" -ForegroundColor Green
        } else {
            # Cross-platform clipboard support
            if (Get-Command xclip -ErrorAction SilentlyContinue) {
                $Text | xclip -selection clipboard
                Write-Host "Password copied to clipboard (xclip)!" -ForegroundColor Green
            } elseif (Get-Command pbcopy -ErrorAction SilentlyContinue) {
                $Text | pbcopy
                Write-Host "Password copied to clipboard (pbcopy)!" -ForegroundColor Green
            } else {
                Write-Warning "Clipboard functionality not available on this platform"
            }
        }
    } catch {
        Write-Warning "Failed to copy to clipboard: $($_.Exception.Message)"
    }
}

# Main execution
try {
    Write-Host "PowerShell Secure Password Generator" -ForegroundColor Cyan
    Write-Host "===================================" -ForegroundColor Cyan
    
    # Validate parameters
    if ($NoUppercase -and $NoLowercase -and $NoNumbers -and !$IncludeSpecial) {
        throw "Cannot exclude all character types. At least one must be enabled."
    }
    
    # Get character sets
    $charInfo = Get-CharacterSet
    Write-Verbose "Character set length: $($charInfo.CharSet.Length)"
    Write-Verbose "Required sets: $($charInfo.RequiredSets.Count)"
    
    # Generate passwords
    $passwords = @()
    Write-Host "`nGenerating $Count password(s) of length $Length..." -ForegroundColor Yellow
    
    for ($i = 1; $i -le $Count; $i++) {
        $password = New-SecurePassword -CharacterSet $charInfo.CharSet -RequiredSets $charInfo.RequiredSets -PasswordLength $Length -EnsureAllTypes $RequireAll
        $strength = Test-PasswordStrength -Password $password
        
        $passwordInfo = [PSCustomObject]@{
            Index = $i
            Password = $password
            Length = $password.Length
            Strength = $strength.Strength
            Score = $strength.Score
        }
        
        $passwords += $passwordInfo
        
        # Display password with strength
        $strengthColor = switch ($strength.Strength) {
            "Very Strong" { "Green" }
            "Strong" { "Cyan" }
            "Medium" { "Yellow" }
            "Weak" { "Red" }
        }
        
        Write-Host "`nPassword $i`: " -NoNewline -ForegroundColor White
        Write-Host $password -ForegroundColor White -BackgroundColor DarkBlue
        Write-Host "Strength: " -NoNewline -ForegroundColor Gray
        Write-Host $strength.Strength -ForegroundColor $strengthColor
        Write-Host "Score: $($strength.Score)/7" -ForegroundColor Gray
        
        if ($strength.Feedback.Count -gt 0 -and $Verbose) {
            Write-Host "Suggestions:" -ForegroundColor Yellow
            $strength.Feedback | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
        }
    }
    
    # Copy first password to clipboard if requested
    if ($CopyToClipboard -and $passwords.Count -gt 0) {
        Copy-ToClipboard -Text $passwords[0].Password
    }
    
    # Export to file if requested
    if ($ExportPath) {
        try {
            $exportData = $passwords | Select-Object Index, Password, Length, Strength, Score
            $exportData | Export-Csv -Path $ExportPath -NoTypeInformation
            Write-Host "`nPasswords exported to: $ExportPath" -ForegroundColor Green
        } catch {
            Write-Error "Failed to export passwords: $($_.Exception.Message)"
        }
    }
    
    # Summary
    Write-Host "`n=== GENERATION SUMMARY ===" -ForegroundColor Cyan
    Write-Host "Passwords generated: $Count" -ForegroundColor White
    Write-Host "Password length: $Length characters" -ForegroundColor White
    Write-Host "Character set size: $($charInfo.CharSet.Length) characters" -ForegroundColor White
    
    $strengthCounts = $passwords | Group-Object Strength | Sort-Object Name
    Write-Host "Strength distribution:" -ForegroundColor White
    $strengthCounts | ForEach-Object {
        Write-Host "  $($_.Name): $($_.Count)" -ForegroundColor Gray
    }
    
    if ($RequireAll) {
        Write-Host "All character types enforced: Yes" -ForegroundColor White
    }
    if ($ExcludeAmbiguous) {
        Write-Host "Ambiguous characters excluded: Yes" -ForegroundColor White
    }
    
    Write-Host "`nPassword generation completed successfully!" -ForegroundColor Green
    
} catch {
    Write-Error "Password generation failed: $($_.Exception.Message)"
    exit 1
} 
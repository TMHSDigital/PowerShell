# PowerShell Complete Guide

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![macOS](https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=macos&logoColor=F0F0F0)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PowerShell Gallery](https://img.shields.io/badge/PowerShell%20Gallery-blue.svg)](https://www.powershellgallery.com/)
[![Documentation](https://img.shields.io/badge/docs-latest-brightgreen.svg)](./PowerShell-Guide.md)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

> A comprehensive PowerShell learning resource that takes you from beginner to professional level with practical examples, best practices, and real-world scenarios.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
- [Guide Structure](#guide-structure)
- [Demo Scripts](#demo-scripts)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage Examples](#usage-examples)
- [Learning Path](#learning-path)
- [Contributing](#contributing)
- [Resources](#resources)
- [License](#license)
- [Support](#support)

## Overview

This repository contains a complete PowerShell education guide designed for developers, system administrators, and IT professionals. Whether you're just starting with PowerShell or looking to master advanced concepts, this guide provides structured learning with hands-on examples.

### Why This Guide?

- **Comprehensive Coverage**: From basic commands to advanced scripting patterns
- **Practical Examples**: All code examples are tested and ready to use
- **Progressive Learning**: Structured path from beginner to professional
- **Real-World Scenarios**: Examples based on actual use cases
- **Cross-Platform**: Covers PowerShell Core for Windows, Linux, and macOS

## Features

- **15 Detailed Sections** covering all PowerShell concepts
- **200+ Code Examples** with explanations
- **Best Practices** for professional PowerShell development
- **Performance Optimization** techniques
- **Security Guidelines** for safe scripting
- **Testing and Debugging** strategies
- **Module Development** patterns
- **API Integration** examples

## Getting Started

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/TMHSDigital/PowerShell.git
   cd PowerShell
   ```

2. **Open the main guide**
   ```bash
   # Windows
   notepad PowerShell-Guide.md
   
   # Linux/macOS
   less PowerShell-Guide.md
   ```

3. **Start learning**
   Begin with the [Basic Concepts](./PowerShell-Guide.md#basic-concepts) section

### Online Reading

You can read the guide directly on GitHub: [PowerShell Complete Guide](./PowerShell-Guide.md)

## Guide Structure

The guide is organized into progressive sections:

### Beginner Level
- **Getting Started** - Installation and setup
- **Basic Concepts** - Fundamental PowerShell concepts
- **Essential Commands** - Core commands for daily use
- **Variables and Data Types** - Working with data
- **Operators** - Arithmetic, comparison, and logical operators

### Intermediate Level
- **Control Flow** - Loops, conditions, and branching
- **Functions** - Creating reusable code blocks
- **Objects and Properties** - Object-oriented PowerShell
- **Pipeline** - Mastering PowerShell's signature feature
- **File System Operations** - File and directory management

### Advanced Level
- **Text Processing** - Regular expressions and string manipulation
- **Error Handling** - Robust error management
- **Modules and Scripts** - Code organization and distribution
- **Advanced Features** - Remoting, jobs, and advanced patterns
- **Professional Best Practices** - Security, performance, and testing

### Quick Reference
- **Essential One-Liners** - Powerful commands for immediate use

## Demo Scripts

The repository includes a comprehensive collection of demo scripts organized by difficulty level:

### Scripts Directory Structure

```
scripts/
├── 01-beginner/        # Basic PowerShell concepts
├── 02-intermediate/    # System administration tasks
├── 03-advanced/        # Complex automation and monitoring
├── 04-automation/      # DevOps and infrastructure scripts
├── 05-utilities/       # Standalone utility tools
└── README.md          # Detailed scripts documentation
```

### Featured Scripts

| Category | Script | Description |
|----------|--------|-------------|
| **Beginner** | `hello-world.ps1` | Comprehensive introduction to PowerShell scripting |
| **Beginner** | `system-info.ps1` | System information gathering and reporting |
| **Intermediate** | `file-organizer.ps1` | Automated file organization by type, date, or size |
| **Advanced** | `system-monitor.ps1` | Real-time system monitoring with alerting |
| **Utilities** | `password-generator.ps1` | Secure password generation with customization |

### Quick Start with Scripts

```powershell
# Navigate to scripts directory
Set-Location .\scripts

# Run a beginner script
.\01-beginner\hello-world.ps1 -Name "PowerShell" -Language English -Verbose

# Try system information gathering
.\01-beginner\system-info.ps1 -Detailed -ShowServices

# Organize files (with WhatIf for safety)
.\02-intermediate\file-organizer.ps1 -OrganizeBy ByType -WhatIf

# Generate secure passwords
.\05-utilities\password-generator.ps1 -Length 16 -IncludeSpecial -RequireAll
```

**For complete scripts documentation**: See [scripts/README.md](./scripts/README.md)

## Prerequisites

### Software Requirements

| Component | Minimum Version | Recommended | Platform |
|-----------|-----------------|-------------|----------|
| PowerShell | 5.1 | 7.4+ | Windows |
| PowerShell Core | 6.0 | 7.4+ | Linux/macOS |
| .NET Framework | 4.5 | Latest | Windows |
| .NET Core | 2.0 | Latest | Cross-platform |

### Knowledge Prerequisites

- Basic command-line experience
- Understanding of file systems
- Familiarity with programming concepts (helpful but not required)

## Installation

### Windows

PowerShell comes pre-installed on Windows 10/11. For the latest version:

```powershell
# Using winget
winget install Microsoft.PowerShell

# Using Chocolatey
choco install powershell-core

# Using Scoop
scoop install pwsh
```

### Linux

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y wget apt-transport-https software-properties-common
wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt update
sudo apt install -y powershell

# CentOS/RHEL/Fedora
sudo dnf install -y powershell
```

### macOS

```bash
# Using Homebrew
brew install --cask powershell

# Using MacPorts
sudo port install powershell
```

## Usage Examples

### Basic Command Examples

```powershell
# Get system information
Get-ComputerInfo | Select-Object WindowsProductName, TotalPhysicalMemory

# List running processes
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10

# Find large files
Get-ChildItem -Recurse | Where-Object {$_.Length -gt 100MB} | Sort-Object Length -Descending
```

### Script Example

```powershell
# Example: System Health Check Script
param(
    [string]$ComputerName = $env:COMPUTERNAME,
    [switch]$Detailed
)

Write-Host "System Health Check for: $ComputerName" -ForegroundColor Green

# CPU Usage
$cpu = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average
Write-Host "CPU Usage: $($cpu.Average)%" -ForegroundColor Yellow

# Memory Usage
$memory = Get-WmiObject Win32_OperatingSystem
$memoryUsage = [math]::Round((($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / $memory.TotalVisibleMemorySize) * 100, 2)
Write-Host "Memory Usage: $memoryUsage%" -ForegroundColor Yellow

# Disk Space
Get-WmiObject Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | ForEach-Object {
    $freeSpace = [math]::Round(($_.FreeSpace / $_.Size) * 100, 2)
    Write-Host "Drive $($_.DeviceID) Free Space: $freeSpace%" -ForegroundColor Yellow
}
```

## Learning Path

### 1. Foundation (Week 1-2)
- [ ] Complete [Getting Started](./PowerShell-Guide.md#getting-started)
- [ ] Master [Basic Concepts](./PowerShell-Guide.md#basic-concepts)
- [ ] Practice [Essential Commands](./PowerShell-Guide.md#essential-commands)

### 2. Core Skills (Week 3-4)
- [ ] Learn [Variables and Data Types](./PowerShell-Guide.md#variables-and-data-types)
- [ ] Understand [Control Flow](./PowerShell-Guide.md#control-flow)
- [ ] Create [Functions](./PowerShell-Guide.md#functions)

### 3. Intermediate (Week 5-6)
- [ ] Master the [Pipeline](./PowerShell-Guide.md#pipeline)
- [ ] Work with [Objects and Properties](./PowerShell-Guide.md#objects-and-properties)
- [ ] Learn [File System Operations](./PowerShell-Guide.md#file-system-operations)

### 4. Advanced (Week 7-8)
- [ ] Advanced [Text Processing](./PowerShell-Guide.md#text-processing)
- [ ] Implement [Error Handling](./PowerShell-Guide.md#error-handling)
- [ ] Build [Modules and Scripts](./PowerShell-Guide.md#modules-and-scripts)

### 5. Professional (Week 9-10)
- [ ] Apply [Best Practices](./PowerShell-Guide.md#professional-best-practices)
- [ ] Learn [Advanced Features](./PowerShell-Guide.md#advanced-features)
- [ ] Practice real-world scenarios

## Contributing

We welcome contributions to improve this PowerShell guide! Here's how you can help:

### Types of Contributions

- **Content Improvements**: Fix errors, add clarity, update examples
- **New Examples**: Add practical real-world scenarios
- **Platform Coverage**: Examples for Linux/macOS specific scenarios
- **Translations**: Help translate the guide to other languages
- **Bug Reports**: Report issues or outdated information

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-improvement
   ```
3. **Make your changes**
4. **Test your examples** (ensure all code works)
5. **Commit with clear messages**
   ```bash
   git commit -m "Add: Advanced pipeline examples for data processing"
   ```
6. **Push and create a Pull Request**

### Contribution Guidelines

- All code examples must be tested and functional
- Follow the existing formatting and style
- Include explanations for complex examples
- No emojis in documentation
- Reference official PowerShell documentation when applicable

## Resources

### Official Documentation
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [PowerShell Gallery](https://www.powershellgallery.com/)
- [PowerShell GitHub Repository](https://github.com/PowerShell/PowerShell)

### Additional Learning
- [PowerShell Cmdlet Reference](https://docs.microsoft.com/en-us/powershell/module/)
- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/strongly-encouraged-development-guidelines)
- [PowerShell Community](https://devblogs.microsoft.com/powershell/)

### Tools and Extensions
- [PowerShell ISE](https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/ise/introducing-the-windows-powershell-ise)
- [Visual Studio Code PowerShell Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)
- [Windows Terminal](https://github.com/microsoft/terminal)

## Compatibility

| PowerShell Version | Windows | Linux | macOS | Status |
|-------------------|---------|-------|--------|--------|
| 5.1 | ✅ | ❌ | ❌ | Legacy |
| 6.x | ✅ | ✅ | ✅ | EOL |
| 7.0+ | ✅ | ✅ | ✅ | Current |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### MIT License Summary

- ✅ Commercial use
- ✅ Modification
- ✅ Distribution
- ✅ Private use
- ❌ Liability
- ❌ Warranty

## Support

### Getting Help

- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/TMHSDigital/PowerShell/issues)
- **Discussions**: Ask questions in [GitHub Discussions](https://github.com/TMHSDigital/PowerShell/discussions)
- **Documentation**: Check the [complete guide](./PowerShell-Guide.md) first

### Response Times

- **Bug Reports**: 24-48 hours
- **Feature Requests**: 1-2 weeks
- **Questions**: 24 hours

### Community

- **PowerShell Community**: [Reddit r/PowerShell](https://reddit.com/r/PowerShell)
- **Stack Overflow**: Tag your questions with `powershell`
- **Discord**: [PowerShell Discord Server](https://discord.gg/powershell)

---

## Statistics

![GitHub repo size](https://img.shields.io/github/repo-size/TMHSDigital/PowerShell)
![GitHub language count](https://img.shields.io/github/languages/count/TMHSDigital/PowerShell)
![GitHub top language](https://img.shields.io/github/languages/top/TMHSDigital/PowerShell)
![GitHub last commit](https://img.shields.io/github/last-commit/TMHSDigital/PowerShell)
![GitHub commit activity](https://img.shields.io/github/commit-activity/m/TMHSDigital/PowerShell)

**Made with ❤️ for the PowerShell community**

**Maintainer**: [TMHSDigital](https://github.com/TMHSDigital)
# PowerShell Demo Scripts

This directory contains practical PowerShell scripts organized by difficulty level and use case. Each script demonstrates specific PowerShell concepts and provides real-world examples you can adapt for your own needs.

## Directory Structure

```
scripts/
├── 01-beginner/        # Basic PowerShell concepts and syntax
├── 02-intermediate/    # File management and system administration
├── 03-advanced/        # Complex automation and API integration
├── 04-automation/      # DevOps and infrastructure automation
├── 05-utilities/       # Standalone utility scripts
└── README.md          # This file
```

## Getting Started

### Prerequisites
- PowerShell 5.1+ (Windows) or PowerShell 7+ (Cross-platform)
- Administrative privileges may be required for some scripts
- Internet connection for scripts that interact with APIs

### Running Scripts

```powershell
# Navigate to scripts directory
Set-Location .\scripts

# Get help for any script
Get-Help .\01-beginner\hello-world.ps1 -Detailed

# Run a script with parameters
.\01-beginner\system-info.ps1 -Detailed

# Run interactively (some scripts support this)
.\02-intermediate\file-organizer.ps1
```

### Safety First

- **Always review scripts before running them**
- **Test in a safe environment first**
- **Use -WhatIf parameter when available**
- **Run with appropriate privileges only**

## Script Categories

### 01-Beginner Scripts

Perfect for learning PowerShell fundamentals:

| Script | Description | Key Concepts |
|--------|-------------|--------------|
| `hello-world.ps1` | Basic script structure and output | Write-Host, parameters |
| `basic-math.ps1` | Arithmetic operations and variables | Variables, operators, calculations |
| `file-operations.ps1` | File and directory manipulation | Get-ChildItem, New-Item, Copy-Item |
| `system-info.ps1` | System information gathering | Get-ComputerInfo, WMI objects |
| `simple-pipeline.ps1` | Pipeline basics | Pipeline, Where-Object, Select-Object |

### 02-Intermediate Scripts

System administration and file management:

| Script | Description | Key Concepts |
|--------|-------------|--------------|
| `file-organizer.ps1` | Organize files by type/date | File operations, loops, sorting |
| `log-analyzer.ps1` | Parse and analyze log files | Text processing, regex, filtering |
| `backup-manager.ps1` | Create and manage backups | Compression, scheduling, validation |
| `user-management.ps1` | Local user account operations | User management, security |
| `network-scanner.ps1` | Network connectivity testing | Network operations, parallel processing |

### 03-Advanced Scripts

Complex automation and integration:

| Script | Description | Key Concepts |
|--------|-------------|--------------|
| `system-monitor.ps1` | Comprehensive system monitoring | Performance counters, alerting |
| `api-client.ps1` | REST API interaction examples | HTTP requests, JSON handling |
| `report-generator.ps1` | HTML/CSV report creation | Data processing, formatting |
| `scheduled-tasks.ps1` | Task scheduler management | Windows tasks, automation |
| `module-template/` | PowerShell module development | Module structure, best practices |

### 04-Automation Scripts

DevOps and infrastructure automation:

| Script | Description | Key Concepts |
|--------|-------------|--------------|
| `deployment-script.ps1` | Application deployment automation | Deployment patterns, validation |
| `health-check.ps1` | Infrastructure health monitoring | Monitoring, reporting, alerting |
| `cleanup-tools.ps1` | System maintenance and cleanup | Maintenance, optimization |
| `batch-processor.ps1` | Bulk data processing | Parallel processing, error handling |

### 05-Utilities

Standalone utility scripts:

| Script | Description | Key Concepts |
|--------|-------------|--------------|
| `password-generator.ps1` | Secure password generation | Security, randomization |
| `text-converter.ps1` | Text encoding and conversion | Text processing, encoding |
| `file-hasher.ps1` | File integrity verification | Cryptography, file validation |
| `port-scanner.ps1` | Network port scanning | Network diagnostics, security |

## Learning Path

### Week 1-2: Fundamentals
1. Start with `01-beginner/hello-world.ps1`
2. Work through basic operations with `basic-math.ps1`
3. Learn file operations with `file-operations.ps1`
4. Explore system information with `system-info.ps1`
5. Master pipelines with `simple-pipeline.ps1`

### Week 3-4: Practical Applications
1. Organize files with `02-intermediate/file-organizer.ps1`
2. Analyze data with `log-analyzer.ps1`
3. Create backups with `backup-manager.ps1`
4. Test networking with `network-scanner.ps1`

### Week 5-6: Advanced Concepts
1. Monitor systems with `03-advanced/system-monitor.ps1`
2. Work with APIs using `api-client.ps1`
3. Generate reports with `report-generator.ps1`
4. Explore module development in `module-template/`

### Week 7+: Automation & Production
1. Deploy applications with `04-automation/deployment-script.ps1`
2. Monitor infrastructure with `health-check.ps1`
3. Create utilities from `05-utilities/`

## Script Features

All scripts include:

- **Comprehensive help documentation** (`Get-Help script.ps1`)
- **Parameter validation** with proper error messages
- **Error handling** with try/catch blocks
- **Verbose output** options for debugging
- **Examples** in the help documentation
- **Comments** explaining key concepts

## Common Parameters

Most scripts support these common parameters:

- `-WhatIf` - Show what would happen without executing
- `-Verbose` - Display detailed information
- `-Debug` - Show debug information
- `-Force` - Override confirmations (use carefully)

## Best Practices Demonstrated

- **Proper error handling** with try/catch/finally
- **Parameter validation** and type enforcement
- **Help documentation** with examples
- **Modular design** with functions
- **Security considerations** for sensitive operations
- **Performance optimization** techniques
- **Cross-platform compatibility** where applicable

## Contributing

When adding new scripts:

1. **Follow naming conventions** (verb-noun format)
2. **Include comprehensive help** documentation
3. **Add parameter validation**
4. **Implement error handling**
5. **Test thoroughly** on target platforms
6. **Update this README** with script information
7. **Add examples** in help documentation

## Troubleshooting

### Common Issues

**Execution Policy Errors:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Permission Denied:**
```powershell
# Run PowerShell as Administrator, or check file permissions
```

**Module Not Found:**
```powershell
# Install required modules
Install-Module -Name ModuleName -Scope CurrentUser
```

### Getting Help

1. **Script-specific help**: `Get-Help .\script.ps1 -Examples`
2. **PowerShell help**: `Get-Help about_Scripts`
3. **Main guide**: See `../PowerShell-Guide.md`
4. **Community**: Check GitHub Issues or Discussions

## Security Notes

- **Review all scripts** before execution
- **Understand what each script does**
- **Run with minimum required privileges**
- **Test in isolated environments first**
- **Keep scripts updated** with security patches
- **Use secure credential handling** practices

## Version Compatibility

| Script Category | PowerShell 5.1 | PowerShell 7+ | Cross-Platform |
|-----------------|-----------------|---------------|----------------|
| 01-Beginner | ✅ | ✅ | ✅ |
| 02-Intermediate | ✅ | ✅ | Partial |
| 03-Advanced | ✅ | ✅ | Partial |
| 04-Automation | ✅ | ✅ | Limited |
| 05-Utilities | ✅ | ✅ | ✅ |

**Note**: Windows-specific features (like Windows services, registry, etc.) are marked as Limited or Partial for cross-platform compatibility.

---

**Happy scripting!** Remember to always test scripts in a safe environment before using them in production. 
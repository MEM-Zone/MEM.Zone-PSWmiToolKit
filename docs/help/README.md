# Readme for Install-SRSReport

## Welcome to our awesome SRS Report Installer :)

This repository is a solution installing SRS Reports using PowerShell.

## Latest release

See [releases](https://SCCM.Zone/Install-SRSReport-RELEASES).

## Changelog

See [changelog](https://SCCM.Zone/Install-SRSReport-CHANGELOG).

## Prerequisites

### Software

* Microsoft SQL Server Reporting Services (SSRS) 2017 or above.
* [ReportingServiceTools cmdlet](https://github.com/microsoft/ReportingServicesTools)

> Notes
> If the ReportingServiceTools is not present the user will be asked to allow installation.

## Functions

### Get-RINode

Gets a report item node information.

### Set-RINodeValue

Updates the shared DataSource of a report or multiple reports on a report server.

### Install-RIReport

Uploads a report or reports in a folder on disk to a report server.

### Set-RIDataSourceReference

Updates the shared DataSource of a report or multiple reports on a report server.

### Add-RISQLExtension

Adds sql extension(s) from a folder on disk to specified SQL database.

## Extensions

There are two types of extensions currently supported. You can find two examples in the `Extensions` folder.

* Permission
* User Defined function

Notes
> The extensions need to be in the same folder and have the `perm` for Permission or `ufn` for user defined function prefix.

## Usage

```PowerShell
## Get syntax help
Get-Help .\Install-SRSReport.ps1

## Typical installation example
#  With extensions
.\Install-SRSReport.ps1 -ReportServerUri 'http://CM-SQL-RS-01A/ReportServer' -ReportFolder '/ConfigMgr_XXX/SRSDashboards' -ServerInstance 'CM-SQL-RS-01A' -Database 'CM_XXX' -Overwrite -Verbose
#  Without extensions (Permissions will still be granted on prerequisite views and tables)
.\Install-SRSReport.ps1 -ReportServerUri 'http://CM-SQL-RS-01A/ReportServer' -ReportFolder '/ConfigMgr_XXX/SRSDashboards' -ServerInstance 'CM-SQL-RS-01A' -Database 'CM_XXX' -ExcludeExtensions -Verbose
#  Extensions only
.\Install-SRSReport.ps1 -ServerInstance 'CM-SQL-RS-01A' -Database 'CM_XXX' -ExtensionsOnly -Overwrite -Verbose
```

>**Notes**
> If you don't use `Windows Authentication` (you should!) in your SQL server you can use the `-UseSQLAuthentication` switch.
> PowerShell script needs to be run as administrator.

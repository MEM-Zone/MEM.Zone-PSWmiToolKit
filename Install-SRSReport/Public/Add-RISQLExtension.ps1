#region Function Add-RISQLExtension
Function Add-RISQLExtension {
<#
.SYNOPSIS
    Adds an sql extension(s) to specified SQL database.
.DESCRIPTION
    Adds an sql extension(s) from a folder on disk to specified SQL database.
.PARAMETER Path
    Specifies a extension file or folder on disk.
.PARAMETER ServerInstance
    Specifies a character string or SQL Server Management Objects (SMO) object that specifies the name of an instance of the Database Engine. For default instances, only specify the computer name: MyComputer. For named instances, use the format ComputerName\InstanceName.
.PARAMETER Database
    Specifies the name of a database. This cmdlet connects to this database in the instance that is specified in the ServerInstance parameter.
.PARAMETER ConnectionTimeout
    Specifies the number of seconds when this cmdlet times out if it cannot successfully connect to an instance of the Database Engine. The timeout value must be an integer value between 0 and 65534. If 0 is specified, connection attempts does not time out.
    Default is: '0'.
.PARAMETER UseSQLAuthentication
    Specifies to use SQL Server Authentication instead of Windows Authentication. You will be asked for credentials if this switch is used.
.PARAMETER FunctionsOnly
    Specifies to add only function extensions.
.PARAMETER PermissionsOnly
    Specifies to add only permission extensions.
.PARAMETER Overwrite
    Specifies to overwrite the extension if it's already installed.
.EXAMPLE
    Invoke-RISQLExtension -Path 'C:\DAS\Extensions' -ServerInstance 'CM-SQL-RS-01A' -Database 'CM_XXX' -ConnectionTimeout 20 -Overwrite
.EXAMPLE
    Invoke-RISQLExtension -Path 'C:\DAS\Extensions\ufn_CM_GetNextMaintenanceWindow.sql' -ServerInstance 'CM-SQL-RS-01A' -Database 'CM_XXX' -ConnectionTimeout 20 -Overwrite
.EXAMPLE
    Invoke-RISQLExtension -Path 'C:\DAS\Extensions' -ServerInstance 'CM-SQL-RS-01A' -Database 'CM_XXX' -ConnectionTimeout 20 -Overwrite -FunctionsOnly
.EXAMPLE
    Invoke-RISQLExtension -Path 'C:\DAS\Extensions' -ServerInstance 'CM-SQL-RS-01A' -Database 'CM_XXX' -ConnectionTimeout 20 -PermissionsOnly
.INPUTS
    None.
.OUTPUTS
    System.Data.DataRow
    System.String
    System.Exception
.NOTES
    This is an public function and can be called directly.
.LINK
    https://SCCM.Zone/
.LINK
    https://SCCM.Zone/CM-SRS-Dashboards-GIT
.LINK
    https://SCCM.Zone/CM-SRS-Dashboards-ISSUES
.COMPONENT
    RS
.FUNCTIONALITY
    RS Catalog Item Installer
#>
    [CmdletBinding(DefaultParameterSetName='FunctionsAndPermissions')]
    Param (
        [Parameter(Mandatory=$false,ParameterSetName='FunctionsAndPermissions',HelpMessage='SQL extension file or folder on disk',Position=0)]
        [Parameter(Mandatory=$false,ParameterSetName='Functions',HelpMessage='SQL extension file or folder on disk',Position=0)]
        [Parameter(Mandatory=$false,ParameterSetName='Permissions',HelpMessage='SQL extension file or folder on disk',Position=0)]
        [ValidateNotNullorEmpty()]
        [Alias('FolderPath','FilePath','ItemPath')]
        [string]$Path,
        [Parameter(Mandatory=$true,ParameterSetName='FunctionsAndPermissions',HelpMessage='SQL server and instance name',Position=1)]
        [Parameter(Mandatory=$true,ParameterSetName='Functions',HelpMessage='SQL server and instance name',Position=1)]
        [Parameter(Mandatory=$true,ParameterSetName='Permissions',HelpMessage='SQL server and instance name',Position=1)]
        [ValidateNotNullorEmpty()]
        [Alias('Server')]
        [string]$ServerInstance,
        [Parameter(Mandatory=$true,ParameterSetName='FunctionAndPermissions',HelpMessage='Database name',Position=2)]
        [Parameter(Mandatory=$true,ParameterSetName='Functions',HelpMessage='Database name',Position=2)]
        [Parameter(Mandatory=$true,ParameterSetName='Permissions',HelpMessage='Database name',Position=2)]
        [ValidateNotNullorEmpty()]
        [Alias('Dbs')]
        [string]$Database,
        [Parameter(Mandatory=$false,ParameterSetName='FunctionAndPermissions',Position=5)]
        [Parameter(Mandatory=$false,ParameterSetName='Functions',Position=5)]
        [Parameter(Mandatory=$false,ParameterSetName='Permissions',Position=5)]
        [ValidateNotNullorEmpty()]
        [Alias('Tmo')]
        [int]$ConnectionTimeout = 0,
        [Parameter(Mandatory=$false,ParameterSetName='FunctionAndPermissions',Position=6)]
        [Parameter(Mandatory=$false,ParameterSetName='Functions',Position=6)]
        [Parameter(Mandatory=$false,ParameterSetName='Permissions',Position=6)]
        [Alias('SQLAuth')]
        [switch]$UseSQLAuthentication,
        [Parameter(Mandatory=$false,ParameterSetName='FunctionAndPermissions',Position=7)]
        [Parameter(Mandatory=$false,ParameterSetName='Functions',Position=7)]
        [ValidateNotNullorEmpty()]
        [Alias('Force')]
        [switch]$Overwrite,
        [Parameter(Mandatory=$false,ParameterSetName='Functions',Position=8)]
        [ValidateNotNullorEmpty()]
        [Alias('Fun')]
        [switch]$FunctionsOnly,
        [Parameter(Mandatory=$false,ParameterSetName='Permissions',Position=7)]
        [ValidateNotNullorEmpty()]
        [Alias('Perm')]
        [switch]$PermissionsOnly
    )
    Process {
        Try {

            ## Get extensions
            $Functions = Get-ChildItem -Path $ExtensionsPath -Filter 'ufn*.sql' | Select-Object -Property 'FullName', 'BaseName'
            $Permissions = Get-ChildItem -Path $ExtensionsPath -Filter 'perm*.sql' | Select-Object -Property 'FullName', 'BaseName'

            ## Process functions
            ForEach ($Function in $Functions) {

                ## Set variables
                [string]$FunctionName = $($Function.BaseName)
                [string]$FunctionPath = $($Function.FullName)
                [string]$InstallFunction = Get-Content -Path $FunctionPath | Out-String
                [string]$CleanupFunction =
@"
                /* Drop function if it exists */
                IF OBJECT_ID('[dbo].[$FunctionName]') IS NOT NULL
                    BEGIN
                        DROP FUNCTION [dbo].[$FunctionName]
                    END
"@
                If (($($PSCmdlet.ParameterSetName) -eq 'Functions') -or ($($PSCmdlet.ParameterSetName) -eq 'FunctionAndPermissions')) {
                    ## Perform function cleanup
                    If ($Overwrite) {
                        Write-Verbose -Message "Performing [$FunctionName] function cleanup..."
                        Invoke-SQLCommand -ServerInstance $ServerInstance -Database $Database -Query $CleanupFunction -UseSQLAuthentication:$UseSQLAuthentication
                    }

                    ## Install function
                    Write-Verbose -Message "Installing [$FunctionName] function..."
                    Invoke-SQLCommand -ServerInstance $ServerInstance -Database $Database -Query $InstallFunction -UseSQLAuthentication:$UseSQLAuthentication
                }
                If (($($PSCmdlet.ParameterSetName) -eq 'Permissions') -or ($($PSCmdlet.ParameterSetName) -eq 'FunctionAndPermissions')) {
                    ## Process permissions
                    ForEach ($Permission in $Permissions) {

                        ## Set variables
                        [string]$PermissionName = $($Permission.BaseName)
                        [string]$PermissionPath = $($Permission.FullName)
                        [string]$GrantPermission = Get-Content -Path $PermissionPath | Out-String

                        ## Grant permissions
                        Write-Verbose -Message "Granting permissions from [$PermissionName]..."
                        Invoke-SQLCommand -ServerInstance $ServerInstance -Database $Database -Query $GrantPermission -UseSQLAuthentication:$UseSQLAuthentication
                    }
                }
            }
        }
        Catch {
            Throw
        }
        Finally {
            Write-Output $Table
        }
    }
}
#endregion
#region Function Set-RIDataSourceReference
Function Set-RIDataSourceReference {
<#
.SYNOPSIS
    Updates the shared DataSource of report(s) on a report server.
.DESCRIPTION
    Updates the shared DataSource of a report or multiple reports on a report server.
.PARAMETER Path
    Specifies a report file or folder on report server. Must begin with an '/'.
.PARAMETER ReportServerUri
    Specifies the SQL Server Reporting Services Instance URL.
.PARAMETER DataSourceName
    Specifies a DataSource Name to set.
.PARAMETER DataSourcePath
    Specifies a DataSource Path to set. Must begin with an '/'.
.PARAMETER DataSourceRoot
    Specifies a DataSource Root from where to get DataSources to set. Must begin with an '/'.
.PARAMETER FilterConnection
    Specifies to filter DataSources based on DataSource Connection String. Supports wildcards.
.EXAMPLE
    Set-RIDataSourceReference -Path '/ConfigMgr_XXX/SRSDashboards' -ReportServerUri 'http://SQL-RS-01/ReportServer' -DataSourceName 'CMSQLDatabase' -DataSourcePath '/ConfigMgr_XXX/{5C8358F2-4BB6-4a1b-A16E-5D96795D8602}'
.EXAMPLE
    Set-RIDataSourceReference -Path '/ConfigMgr_XXX/SRSDashboards' -ReportServerUri 'http://SQL-RS-01/ReportServer' -DataSourceName 'CMSQLDatabase' -DataSourceRoot '/ConfigMgr_XXX' -FilterConnection 'Catalog=CM_XXX;'
.INPUTS
    None.
.OUTPUTS
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
    [CmdletBinding(DefaultParameterSetName='DataSource')]
    Param (
        [Parameter(Mandatory=$true,ParameterSetName='DataSource',HelpMessage='Report file or folder on a report server',Position=0)]
        [Parameter(Mandatory=$true,ParameterSetName='GetDataSource',HelpMessage='Report file or folder on a report server',Position=0)]
        [ValidateNotNullorEmpty()]
        [Alias('RSFolderPath','RSReportPath','RSItemPath')]
        [string]$Path,
        [Parameter(Mandatory=$true,ParameterSetName='DataSource',HelpMessage='URL to your SSRS instance',Position=1)]
        [Parameter(Mandatory=$true,ParameterSetName='GetDataSource',HelpMessage='URL to your SSRS instance',Position=1)]
        [ValidateNotNullorEmpty()]
        [Alias('RS','RSUri','Uri')]
        [string]$ReportServerUri,
        [Parameter(Mandatory=$true,ParameterSetName='DataSource',HelpMessage='Report DataSource name',Position=2)]
        [Parameter(Mandatory=$true,ParameterSetName='GetDataSource',HelpMessage='Report DataSource name',Position=2)]
        [ValidateNotNullorEmpty()]
        [Alias('DSName')]
        [string]$DataSourceName,
        [Parameter(Mandatory=$true,ParameterSetName='DataSource',HelpMessage='RS shared DataSource path (/RSFolder)',Position=3)]
        [ValidateNotNullorEmpty()]
        [Alias('DSPath')]
        [string]$DataSourcePath,
        [Parameter(Mandatory=$true,ParameterSetName='GetDataSource',HelpMessage='RS DataSource root folder (/RSFolder)',Position=3)]
        [ValidateNotNullorEmpty()]
        [Alias('DSRoot')]
        [psobject]$DataSourceRoot,
        [Parameter(Mandatory=$true,ParameterSetName='GetDataSource',HelpMessage='RS DataSource connection string filter pattern',Position=4)]
        [ValidateNotNullorEmpty()]
        [Alias('Filter')]
        [string]$FilterConnection
    )
    Begin {

        ## Set variables
        [psobject]$DataSourcesInfo = @()

        ## Check if path is a folder
        [bool]$IsContainer = If (Get-RsFolderContent -ReportServerUri $ReportServerUri -Path $DataSourceRoot -ErrorAction 'SilentlyContinue') { $true } Else { $false }
    }
    Process {
        Try {

            If ($($PSCmdlet.ParameterSetName) -eq 'DataSource') {
                If ($IsContainer) { Throw 'Path is a folder!' }

                ## Set DataSource
                Write-Verbose -Message 'Updating datasource [$DataSourceName]...'
                $SetDataSource = Set-RsDataSourceReference -Path $ReportPath -ReportServerUri $ReportServerUri -DataSourcePath $DataSourcePath -DataSourceName $DataSourceName
            }
            If ($($PSCmdlet.ParameterSetName) -eq 'GetDataSource') {
                If (-not $IsContainer) { Throw 'Path is not a folder!' }

                ## Get report server DataSources
                Write-Verbose -Message 'Retrieving report server datasources...'
                $RSDataSources = Get-RsFolderContent -ReportServerUri $ReportServerUri -Path $DataSourceRoot | Where-Object -Property 'TypeName' -eq 'DataSource'

                ## Get report server DataSource info
                ForEach ($RSDataSource in $RSDataSources) {
                    #  Set variables
                    [string]$RsDataSourcePath = $($RSDataSource.Path)
                    #  Get DataSource info
                    Write-Verbose -Message 'Getting datasource info...'
                    If ($FilterConnection) {
                        Write-Verbose -Message "Filtering dataSource connection string on [$FilterConnection]..."
                        $GetDataSource = Get-RsDataSource -ReportServerUri $ReportServerUri -Path $RsDataSourcePath | Where-Object -Property 'ConnectString' -Match $FilterConnection
                    }
                    Else {
                        $GetDataSource = Get-RsDataSource -ReportServerUri $ReportServerUri -Path $RsDataSourcePath
                    }

                    If ($GetDataSource) {
                        $DataSourceInfoProps = @{ Path = $RsDataSourcePath }
                        #  Add to DataSourcesInfo object
                        $DataSourcesInfo += New-Object 'PSObject' -Property $DataSourceInfoProps
                    }
                }
                #  Check if we have any DataSources
                If (-not $DataSourcesInfo) { Throw "No datasources found or match filter criteria!" }

                ## Update uploaded report(s) DataSource(s)
                Write-Verbose -Message 'Getting reports to update...'
                [string[]]$ReportPaths = Get-RsFolderContent -ReportServerUri $ReportServerUri -Path $ReportFolder | Where-Object -Property 'TypeName' -eq 'Report' | Select-Object -ExpandProperty 'Path'
                If ($($ReportPaths.Count) -eq 0) { Throw "No reports found at this path [$ReportFolder]!" }
                Write-Verbose -Message "Processing [#$($ReportPaths.Count)] reports..."
                ForEach ($ReportPath in $ReportPaths) {
                    ForEach ($DataSource in $DataSourcesInfo) {
                        #  Set variables
                        [string]$DataSourcePath = $($DataSource.Path)
                        #  Set DataSource
                        Set-RsDataSourceReference -Path $ReportPath -ReportServerUri $ReportServerUri -DataSourcePath $DataSourcePath -DataSourceName $DataSourceName
                    }
                }
            }
        }
        Catch {
            Throw (New-Object System.Exception("Error while installing report(s)! $($_.Exception.Message)", $_.Exception))
        }
        Finally {
            Write-Output $SetDataSource
        }
    }
}
#endregion

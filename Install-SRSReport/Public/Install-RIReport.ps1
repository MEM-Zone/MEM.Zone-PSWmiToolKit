#region Function Install-RIReport
Function Install-RIReport {
<#
.SYNOPSIS
    Uploads a report(s) on disk to a report server.
.DESCRIPTION
    Uploads a report or reports in a folder on disk to a report server.
.PARAMETER Path
    Specifies a path to a file or folder on disk to upload to a report server.
.PARAMETER ReportServerUri
    Specifies the SQL Server Reporting Services Instance URL.
.PARAMETER ReportFolder
    Specifies the report server Folder to upload the item to. Must begin with an '/'. Default is: '/'
.PARAMETER SetReportNodeValue
    Optionally specifies report node info for which to modify the value in a hashtable format. Parameter is a hashtable.
    You can also specify a string but you must separate the name and value with a new line character (`n).
    If the 'Path' parameter is a folder, all reports in the folder will be modified.
    [hashtable]@{ NodeName  = 'ReportName'; NodeValue = 'NewValue'; NsPrefix  = 'NamespacePrefix' }
.PARAMETER Overwrite
    Overwrite the old item(s), if an existing report with same name exists at the specified destination.
.EXAMPLE
    Install-RIReport -Path 'C:\DAS\Reports' -ReportServerUri 'http://CM-SQL-RS-01A/ReportServer' -ReportFolder '/ConfigMgr_XXX/SRSDashboards' -Overwrite
.EXAMPLE
    Install-RIReport -Path 'C:\DAS\Reports\SU Compliance by Collection.rdl' -ReportServerUri 'http://CM-SQL-RS-01A/ReportServer' -ReportFolder '/ConfigMgr_XXX/SRSDashboards' -Overwrite
.EXAMPLE
    [hashtable]$SetReportNodeValue = @{ NodeName  = 'ReportName'; NodeValue = '/ConfigMgr_XXX/SRSDashboards'; NsPrefix  = 'ns' }
    Install-RIReport -Path 'C:\DAS\Reports\SU Compliance by Collection.rdl' -ReportServerUri 'http://CM-SQL-RS-01A/ReportServer' -ReportFolder '/ConfigMgr_XXX/SRSDashboards' -SetReportNodeValue $SetReportNodeValue
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
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,HelpMessage='File or folder on disk',Position=0)]
        [ValidateNotNullorEmpty()]
        [Alias('FolderPath','FilePath','ItemPath')]
        [string]$Path,
        [Parameter(Mandatory=$true,HelpMessage='URL to your SQL Server Reporting Services Instance',Position=1)]
        [ValidateNotNullorEmpty()]
        [Alias('RS','RSUri','Uri')]
        [string]$ReportServerUri,
        [Parameter(Mandatory=$false,HelpMessage='Destination folder on report server (/RSFolder)',Position=2)]
        [ValidateNotNullorEmpty()]
        [Alias('Destination','RsFolder')]
        [string]$ReportFolder = '/',
        [Parameter(Mandatory=$false,HelpMessage='[hashtable]@{ NodeName  = "ReportName"; NodeValue = "NewValue"; NsPrefix  = "NamespacePrefix" }',Position=3)]
        [ValidateNotNullorEmpty()]
        [Alias('SetPropertyValue','SetNodeValue')]
        [hashtable]$SetReportNodeValue,
        [Parameter(Mandatory=$false,Position=4)]
        [Alias('Force')]
        [switch]$Overwrite
    )
    Begin {
        Write-Debug -Message "Path [$Path], ReportServerUri [$ReportServerUri], ReportFolder [$ReportFolder], Overwrite [$Overwrite]"
    }
    Process {
        Try {
            ## Check if path is a folder
            [bool]$IsContainer = Test-Path $Path -PathType 'Container' -ErrorAction 'SilentlyContinue'

            ## Get report file paths
            [string[]]$ReportFilePaths = Get-ChildItem -Path $Path -Recurse | Select-Object -ExpandProperty 'FullName' -ErrorAction 'Stop'

            ## Set report value
            If ($SetReportNodeValue) {
                ForEach ($FilePath in $ReportFilePaths) {
                    [hashtable]$NodeParams = @{
                        Path      = $FilePath
                        NodeName  = $($SetReportNodeValue.NodeName)
                        NodeValue = $($SetReportNodeValue.NodeValue)
                        NsPrefix  = $($SetReportNodeValue.NsPrefix)
                    }

                    [string]$NewNodeValue = Set-RINodeValue @NodeParams | Out-String
                    Write-Debug -Message $NewNodeValue
                }
            }

            ## If destination does not exists, create it.
            If ($ReportFolder -ne '/') {
                [string]$RsFolderParent = (Split-Path -Path $ReportFolder -Parent).Replace('\', '/')
                [string]$RsFolderLeaf = (Split-Path -Path $ReportFolder -Leaf).Replace('\', '/')
                New-RsFolder -ReportServerUri $ReportServerUri -Path $RsFolderParent -Name $RsFolderLeaf
            }

            ## Upload report file(s)
            If ($IsContainer) {
                Write-RsFolderContent -ReportServerUri $ReportServerUri -Path $Path -Destination $ReportFolder -Overwrite:$OverWrite
            }
            Else {
                Write-RsCatalogItem -ReportServerUri $ReportServerUri -Path $Path -Destination $ReportFolder -Overwrite:$OverWrite
            }

            ## Save result
            $Result = 'Succesfully installed reports!'
        }
        Catch {
            If ($($_.Exception.Message) -notlike '*already exists*') {
                Throw (New-Object System.Exception("Could install report(s) [$Path] ! $($_.Exception.Message)", $_.Exception))
            }
        }
        Finally {
            Write-Output $Result
        }
    }
}
#endregion
#region Function New-NamespaceManager
Function New-NamespaceManager {
<#
.SYNOPSIS
    Creates a report namespace manager.
.DESCRIPTION
    Creates a report item namespace manager
.PARAMETER Path
    Specifies the report item Path.
.EXAMPLE
    New-NamespaceManager -Path 'C:\DAS\SU Compliance by Collection.rdl'
.INPUTS
    None.
.OUTPUTS
    System.PsObject
    System.Exception
.NOTES
    This is an private function should tipically not be called directly.
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
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullorEmpty()]
        [Alias('FilePath','ItemPath')]
        [string]$Path
    )

    Begin {

        ## Create Xml objects
        $ReportFile = New-Object -TypeName 'System.Xml.XmlDocument'
        $Namespaces = New-Object -TypeName 'System.Xml.XmlDocument'
    }
    Process {
        Try {
            Write-Verbose -Message 'Creating namespace manager...'

            ## Load report file
            $ReportFile.Load($Path)

            ## Get report namespaces
            $Namespaces = $ReportFile.SelectSingleNode('/*').Attributes | Where-Object -Property 'Prefix' -eq 'xmlns'

            ## Add namespaces to namespace manager
            $Namespaces | ForEach-Object {
                $NamespaceManager += @{$_.LocalName = $_.Value}
            }
            #  Add default namespace to namespace manager
            $NamespaceManager += @{ns = $ReportFile.DocumentElement.NamespaceURI}
        }
        Catch {
            Throw (New-Object System.Exception("Could not create report [$Path] Namespace Manager! $($_.Exception.Message)", $_.Exception))
        }
        Finally {
            Write-Output -InputObject $NamespaceManager
        }
    }
}
#endregion
#region Function Get-RINode
Function Get-RINode {
<#
.SYNOPSIS
    Gets a report node.
.DESCRIPTION
    Gets a report item node information.
.PARAMETER Path
    Specifies the report item Path.
.PARAMETER NodeName
    Specifies the node Name.
.PARAMETER NamespacePrefix
    Specifies the xml namespace prefix.
.EXAMPLE
    Get-RINode -Path 'C:\DAS\SU Compliance by Collection.rdl' -NodeName 'ReportName' -NamespacePrefix 'ns'
.INPUTS
    None.
.OUTPUTS
    System.Xml.XmlDocument
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
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullorEmpty()]
        [Alias('ReportPath','ItemPath')]
        [string]$Path,
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateNotNullorEmpty()]
        [Alias('PropertyName','Node')]
        [string]$NodeName,
        [Parameter(Mandatory=$true,Position=2)]
        [ValidateNotNullorEmpty()]
        [Alias('Prefix','Ns','NsPrefix')]
        [string]$NamespacePrefix
    )
    Begin {

        ## Create NamespaceManager
        [hashtable]$NamespaceManager = New-NamespaceManager -Path $Path

        ## Assemble node name
        [string]$Node = "//${NamespacePrefix}:${NodeName}"
    }
    Process {
        Try {
            Write-Verbose -Message "Getting [$Node] info..."
            $Result = Select-Xml -Path $Path -XPath $Node -Namespace $NamespaceManager | Select-Object -Property *, @{Label="Value"; Expression={($_.Node.InnerXml).Trim()}}
        }
        Catch {
            Throw (New-Object System.Exception("Could not get report node [$Node]! $($_.Exception.Message)", $_.Exception))
        }
        Finally {
            Write-Output -InputObject $Result
        }
    }
}
#endregion
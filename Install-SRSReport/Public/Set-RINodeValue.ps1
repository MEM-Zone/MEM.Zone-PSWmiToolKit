#region Function Set-RINodeValue
Function Set-RINodeValue {
<#
.SYNOPSIS
    Sets a report node value.
.DESCRIPTION
    Sets a report item node value.
.PARAMETER Path
    Specifies the report item Path.
.PARAMETER NodeName
    Specifies the node Name.
.PARAMETER NodeValue
    Specifies the node Value to be set.
.PARAMETER NamespacePrefix
    Specifies the xml namespace prefix.
.EXAMPLE
    Set-RINode -Path 'C:\DAS\SU Compliance by Collection.rdl' -NodeName 'ReportName' -NodeValue '\Reports\DAS' -NamespacePrefix 'ns'
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
        [Alias('FilePath','ItemPath')]
        [string]$Path,
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateNotNullorEmpty()]
        [Alias('Node','PropertyName')]
        [string]$NodeName,
        [Parameter(Mandatory=$true,Position=2)]
        [ValidateNotNullorEmpty()]
        [Alias('Value','PropertyValue')]
        [string]$NodeValue,
        [Parameter(Mandatory=$true,Position=3)]
        [ValidateNotNullorEmpty()]
        [Alias('Prefix','Ns','NsPrefix')]
        [string]$NamespacePrefix
    )

    Begin {

        ## Set variables
        [bool]$SetNode = $false
        #  Assemble node name
        [string]$Node = "//${NamespacePrefix}:${NodeName}"
        #  Create report file object
        $ReportFile = New-Object -TypeName 'System.Xml.XmlDocument'
        #  Create Namespace Manager
        [hashtable]$NamespaceManager = New-NamespaceManager -Path $Path
    }
    Process {
        Try {
            Write-Verbose -Message "Setting node value to [$NodeValue]..."

            ## Load report file
            $ReportFile.Load($Path)

            ## Set Node Values
            $ReportFile | Select-Xml -XPath $Node -Namespace $NamespaceManager | ForEach-Object {
                $_.Node.Set_InnerText($NodeValue)
                $SetNode = $true
            }

            ## Save report file
            $ReportFile.Save($Path)

            If ($SetNode) {
                ## Set Result variable
                $Result = Select-Xml -Path $Path -XPath $Node -Namespace $NamespaceManager | Select-Object -Property *, @{Label="Value"; Expression= {($_.Node.InnerXml).Trim()}}
            }
            Else {
                $Result = $null
                Write-Verbose -Message "Node [$Node] does not exist!"
            }
        }
        Catch {
            Throw (New-Object System.Exception("Could not set report node [$Node] value [$NodeValue]! $($_.Exception.Message)", $_.Exception))
        }
        Finally {
            Write-Output -InputObject $Result
        }
    }
}
#endregion
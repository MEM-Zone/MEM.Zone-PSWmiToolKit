#region Function Get-WmiNamespaceRecursive
Function Get-WmiNamespaceRecursive {
<#
.SYNOPSIS
    This function is used to get wmi namespaces recursively.
.DESCRIPTION
    This function is used to get wmi namespaces recursively and returns a custom object.
.PARAMETER Namespace
    Specifies the root namespace(s) path(s) to search. Cand be piped.
.EXAMPLE
    C:\PS> $Result = Get-WmiNamespaceRecursive -NameSpace 'ROOT\SCCM'
.EXAMPLE
    C:\PS> $Result = 'ROOT\SCCM', 'ROOT\Appv' | Get-WmiNamespaceRecursive
.INPUTS
    System.String[].
.OUTPUTS
    System.Management.Automation.PSCustomObject.
        'Name'
        'Path'
        'FullName'
.NOTES
    As this is a recursive function it will run multiple times so you might want to assign it to a variable for sorting.
    You also might want to disable logging when running this function.

    This is an internal module function and should not typically be called directly.
.LINK
    https://MEM.Zone/
.LINK
    https://MEM.Zone/PSWmiToolKit-RELEASES
.LINK
    https://MEM.Zone/PSWmiToolKit-GIT
.LINK
    https://MEM.Zone/PSWmiToolKit-ISSUES

.COMPONENT
    WMI
.FUNCTIONALITY
    WMI Management
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,ValueFromPipeline,Position=0)]
        [ValidateNotNullorEmpty()]
        [string[]]$Namespace
    )

    Begin {
        ## Initialize/Reset result object
        [PSCustomObject]$GetNamespaceRecursive = @()
    }
    Process {
        Try {

            ## Get all namespaces in the current root namespace
            $Namespaces = Get-WmiNamespace -Namespace $Namespace -List

            ## Search in the current namespace for other namespaces
            If ($Namespaces) {
                $Namespaces | ForEach-Object {
                    #  Assemble the result object
                    $GetNamespaceRecursive += [PsCustomObject]@{
                        Name = $_.Name
                        Path = $_.Path
                        FullName = $_.FullName
                    }

                    #  Call the function again for the next namespace
                    Get-WmiNamespaceRecursive -Namespace $_.FullName
                }
            }
        }
        Catch {
            Write-Log -Message "Failed to retrieve wmi namespace [$Namespace] recursively. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
    }
    End {
        Write-Output -InputObject $GetNamespaceRecursive
    }
}
#endregion
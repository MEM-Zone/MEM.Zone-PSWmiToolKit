#region Function Get-WmiNameSpaceRecursive
Function Get-WmiNamespaceRecursive {
<#
.SYNOPSIS
    This function is used to get wmi namespaces recursively.
.DESCRIPTION
    This function is used to get wmi namespaces recursively and return a custom object.
    As this is a recursive function it will run multiple times so you might want to assign it to a variable for sorting.
    You also might want to disable logging when running this function.
.PARAMETER NamespaceRoot
    Specifies the root namespace path from which to start searching.
.EXAMPLE
    Get-WmiNamespaceRecursive -NameSpace 'ROOT\SCCM'
.INPUTS
    None.
.OUTPUTS
    None.
.NOTES
    This is a private module function and should not typically be called directly.
.LINK
    https://sccm-zone.com
.LINK
    https://github.com/JhonnyTerminus/SCCM
.COMPONENT
    WMI
.FUNCTIONALITY
    WMI Management
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullorEmpty()]
        [string]$NamespaceRoot
    )

    Begin {
        ## Initialize/Reset resutl object
        [PSCustomObject]$GetNamespaceRecursive = @()
    }
    Process {
        Try {

            ## Get all namespaces in the current root namespace
            $Namespaces = Get-WmiNameSpace -Namespace "$NamespaceRoot" -List -ErrorAction 'SilentlyContinue'

            ## Search in the current namespace for other namespaces
            ForEach ($Namespace in $Namespaces) {

                #  Assemble the result object
                $GetNamespaceRecursive += [PsCustomObject]@{
                    Name = $Namespace.Name
                    Path = $Namespace.Path
                    FullName = $Namespace.FullName
                }

                #  Call the function again for the next namespace
                Get-WmiNamespaceRecursive -Namespace $Namespace.FullName
            }
        }
        Catch {
            Write-Log -Message "Failed to retrieve wmi namespace [$NamespaceRoot] recursively. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
    }
    End {
        Write-Output -InputObject $GetNamespaceRecursive
    }
}
#endregion
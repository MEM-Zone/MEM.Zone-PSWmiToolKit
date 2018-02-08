#region Function Rename-WmiNamespace
Function Rename-WmiNamespace {
<#
.SYNOPSIS
    This function is used to rename a WMI namespace.
.DESCRIPTION
    This function is used to rename a WMI namespace by creating a new namespace, copying all existing classes to it and removing the old one.
.PARAMETER Namespace
    Specifies the root namespace where to search for the namespace name. Default is: ROOT\cimv2.
.PARAMETER Name
    Specifies the namespace name to be renamed.
.PARAMETER NewName
    Specifies the new namespace name.
.EXAMPLE
    Rename-WmiNamespace -Namespace 'ROOT\cimv2' -Name 'SCCM' -NewName 'SCCMZone'
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://sccm-zone.com
.LINK
    https://github.com/JhonnyTerminus/SCCM
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false,Position=0)]
        [ValidateNotNullorEmpty()]
        [string]$Namespace = 'ROOT\cimv2',
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateNotNullorEmpty()]
        [string]$Name,
        [Parameter(Mandatory=$true,Position=2)]
        [ValidateNotNullorEmpty()]
        [string]$NewName
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Set namespace paths
            $NamespaceSource = Join-Path -Path $Namespace -ChildPath $Name
            $NamespaceDestination = Join-Path -Path $Namespace -ChildPath $NewName

            ## Check if the source namespace exists
            $null = Get-WmiNamespace -Namespace $NamespaceSource -ErrorVariable 'Stop'

            #  Create the new namespace but throw an error if it already exists
            New-WmiNamespace -Namespace $NamespaceDestination -ErrorAction 'Stop'

            #  Copy the old namespace
            Copy-WmiNamespace -NamespaceSource $NamespaceSource -NamespaceDestination $NamespaceDestination -Force -ErrorAction 'Stop'

            #  Remove old Namespace
            Remove-WmiNamespace -Namespace $NamespaceSource -Recurse -Force

            #  Write success message to console
            Write-Log -Message "Succesfully renamed namespace [$NamespaceSource -> $NamespaceDestination]" -Source ${CmdletName}
        }
        Catch {
            Write-Log -Message "Failed to rename namespace. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {}
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion
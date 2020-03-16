#region Function Remove-WmiNamespace
Function Remove-WmiNamespace {
<#
.SYNOPSIS
    This function is used to delete a WMI namespace.
.DESCRIPTION
    This function is used to delete a WMI namespace by name.
.PARAMETER Namespace
    Specifies the namespace to remove.
.PARAMETER Force
    This switch deletes all existing classes in the specified path. Default is: $false.
.PARAMETER Recurse
    This switch deletes all existing child namespaces in the specified path.
.EXAMPLE
    Remove-WmiNamespace -Namespace 'ROOT\SCCM' -Force -Recurse
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://sccm-zone.com
.LINK
    https://github.com/Ioan-Popovici/SCCM
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullorEmpty()]
        [string]$Namespace,
        [Parameter(Mandatory=$false,Position=2)]
        [ValidateNotNullorEmpty()]
        [switch]$Force = $false,
        [Parameter(Mandatory=$false,Position=2)]
        [ValidateNotNullorEmpty()]
        [switch]$Recurse = $false
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Set namespace root
            $NamespaceRoot = Split-Path -Path $Namespace
            ## Set namespace name
            $NamespaceName = Split-Path -Path $Namespace -Leaf

            ## Check if the namespace exists
            $null = Get-WmiNamespace -Namespace $Namespace -ErrorAction 'Stop'

            ## Check if there are any classes
            $ClassTest = Get-WmiClass -Namespace $Namespace -ErrorAction 'SilentlyContinue'

            ## Check if there are any child namespaces or if the -Recurse switch was specified
            $ChildNamespaceTest = (Get-WmiNamespace -Namespace $($Namespace + '\*') -ErrorAction 'SilentlyContinue').Name
            If ((-not $ChildNamespaceTest) -or $Recurse) {

                #   Remove all existing classes and instances if the -Force switch was specified
                If ($Force -and $ClassTest) {
                    Remove-WmiClass -Namespace $Namespace -RemoveAll
                }
                ElseIf ($ClassTest) {
                    $NamespaceHasClassesErr = "Classes [$($ClassTest.Count)] detected in namespace [$Namespace]. Use the -Force switch to remove classes."
                    Write-Log -Message $NamespaceHasClassesErr -Severity 2 -Source ${CmdletName} -DebugMessage
                    Write-Error -Message $NamespaceHasClassesErr -Category 'InvalidOperation'
                }

                #  Create the Namespace Object
                $NameSpaceObject = (New-Object -TypeName 'System.Management.ManagementClass' -ArgumentList "\\.\$NamespaceRoot`:__NAMESPACE").CreateInstance()
                $NameSpaceObject.Name = $NamespaceName

                #  Remove the Namespace
                $null = $NameSpaceObject.Delete()
                $NameSpaceObject.Dispose()
            }
            ElseIf ($ChildNamespaceTest) {
                $ChildNamespaceDetectedErr = "Child namespace [$ChildNamespaceTest] detected in namespace [$Namespace]. Use the -Recurse switch to remove Child namespaces."
                Write-Log -Message $ChildNamespaceDetectedErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $ChildNamespaceDetectedErr -Category 'InvalidOperation'
            }
        }
        Catch {
            Write-Log -Message "Failed to remove namespace [$Namespace]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {}
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion